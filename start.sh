
###################################
# Pass SIGTERM to mattermost proc #
###################################
function _term {
  echo "Sending SIGTERM to mattermost"

  kill --TERM "$PID" 2>/dev/null
}

trap _term SIGTERM


####################
# Start Mattermost #
####################
bin/mattermost --config=/app/default-config.json &

PID=$!

#####################################################################
# Let the Mattermost proc start up, then touch /tmp/app-initialized #
# to indicate to the nginx process we're ready for traffic          #
#####################################################################
sleep 3
touch /tmp/app-initialized

#####################################
# Wait for this process to complete #
#####################################
wait "$PID"
