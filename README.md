
# Deploy Mattermost Team or Enterprise Edition to Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

This buildpack is an [inline buildpack](https://github.com/kr/heroku-buildpack-inline/) (tldr: this repo deploys to Heroku and uses itself as a buildpack) for deploying [Mattermost](https://mattermost.org) to [Heroku](https://heroku.com).
It must be used in tandem with [This customized Nginx Buildpack](https://github.com/cadecairos/nginx-buildpack) that allow mattermost to communicate with Nginx using a TCP port instead of a socket.


### Only tested on 5.1.0 Team edition. Changes made:
- update the `default-config.json` with the latest version from [their server repo](https://github.com/mattermost/mattermost-server)
- replace the binary name from `platform` to `mattermost` as they have [changed it](https://docs.mattermost.com/administration/changelog.html) for 5.0.0
- update the mattermost url in `bin/compile` as they changed the path from 4 to 5

### Setup
1. Click the Deploy to Heroku button above
2. Login if needed, give the app a name and click deploy
3. Go to Manage App, Settings, Reveal Config Vars, and copy the value for `DATABASE_URL`
4. Set the value `MM_SQLSETTINGS_DATASOURCE` to the copied value
5. You should be good to go now

## Configuration options

### Buildpack Specific Variables

Set `MATTERMOST_VERSION` to the release version you'd like to install. i.e. '4.5.0'
Set `MATTERMOST_TYPE` to either 'team' or 'enterprise'

### Mattermost Configuration

Mattermost-Heroku supports every configuration option available in Mattermost (although some make no sense to use with Mattermost+Nginx on Heroku, i.e. "Forward80To443"). To set an environment variable, prefix it with "MM_" followed by the setting type, and then the setting key, in all upper case. [You can read up about how this works in the Mattermost configuration documentation](https://docs.mattermost.com/administration/config-settings.html#configuration-settings)

## Rebuilding

If you maintain a fork of this repo, you can link the Heroku app to your fork, which will enable you to build from the Heroku dashboard's deploy page.

An alternative to this would be to use the [Heroku Build API to create a new build](https://devcenter.heroku.com/articles/build-and-release-using-the-api#creating-builds)

For example, a curl request like this would do the trick (substitute the right variables):

```bash
curl -n -X POST https://api.heroku.com/apps/$YOUR_APP/builds \
-d '{"source_blob": {"url":"https://github.com/mozilla/mattermost-heroku/archive/{$LATEST_BUILDPACK_VERSION}.tar.gz", "version": "${COMMIT_HASH}"}}' \
-H 'Accept: application/vnd.heroku+json; version=3' \
-H "Content-Type: application/json"
```

The "version" parameter is optional in the example above.

This curl request can be made manually from a developer's machine, or it can be set up as a job in something like [Jenkins]()https://jenkins.io/. Keep in mind that Authorization headers will need to be included in the request.

Also, the example above assumes that the machine it's being run on has heroku.com credentials saved in your `~/.netrc` file.

## Warnings

1. Don't make configuration changes in the Mattermost admin console.
   Any configuration changes in the Mattermost admin console will be lost on dyno restart (which may be every 24 hours) and will not be distributed across multiple dynos.
2. Not using s3 means any uploads will be lost on dyno restart or application reconfiguration or redeploy and won't be consistent across multiple dynos.
   Without s3 backing this is not anything more than a one time demo.

## Enterprise Edition
Activate it as instructed in the docs https://docs.mattermost.com/install/ee-install.html
