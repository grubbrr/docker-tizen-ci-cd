# docker-tizen-ci-cd
Github action that installs and runs the Tizen cli tools in a docker container for Samsung TV app development.

## Inputs

### `type`

**Required** The type of application to build and package for tizen. (web|native)

### `app-directory`

**Required** the location of the tizen app folder inside the github repo. Default `"tizen"`.

### `cert-pw`

**Required** a password to use for the certificate that the package will be signed with. Use Github secrets.

### `cert-name`

The name of the cert that will be used for signing the app. Default `"devcert"`.

### `zip`

Zip final package for deployment. Default `"false"` (true|false).

### `exclusions`

Files to be excluded from a package. Default `".build/* .build .sign/* .sign webUnitTest/* webUnitTest .externalToolBuilders/* .externalToolBuilders .buildResult/* .buildResult .settings/* .settings .package/* .package .tproject .project .sdk_delta.info .rds_delta *.wgt .tizen-ui-builder-tool.xml *.zip"`

## Development
It is encouraged if building on windows you limit the memory that WSL can consume. In powershell run the following:

```powershell
wsl --shutdown
notepad "$env:USERPROFILE/.wslconfig"
```

Ensure this file has the folowing lines or something similar:

```
[wsl2]
memory=3GB   # Limits VM memory in WSL 2 up to 3GB
processors=4 # Makes the WSL 2 VM use two virtual processors
```

### Docker image

For local dev updating of the `entrypoint.sh` file in the docker image:

```sh
docker image build -t tizen-test . # --no-cache # when changing builder layers
```

## Reference

[Docker-tizen-studio-ide](https://github.com/ubergeek77/Docker-tizen-studio-ide)

[Tizen official sdk repository](http://download.tizen.org/sdk/tizenstudio/official/binary/)