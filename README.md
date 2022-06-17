# docker-tizen-ci-cd
Github action that installs and runs the Tizen cli tools in a docker container for Samsung TV app development.

## Usage

```yml
jobs:
  pack-tizen:
    name: Tizen Kiosk Package
    runs-on: ubuntu-latest
    steps:
        - name: Create Package
        uses: grubbrr/docker-tizen-ci-cd@v2.0.2
        with:
            command: web
            app-directory: tizen
            cert-pw: ${{ secrets.tizen_cert_pw }}
            zip: true
            version: 1.0.1
```

## Inputs

### `command`

**Required** The type of application to build and package for tizen. (web|native)

### `app-directory`

**Required** the location of the tizen app folder inside the github repo. Default `"tizen"`.

### `cert-pw`

**Required** a password to use for the certificate that the package will be signed with. Use Github secrets.

### `cert-name`

The name of the cert that will be used for signing the app. Default `"devcert"`.

### `zip`

Zip final package for deployment. Default `"false"` (true|false).

### `type`

When generating a zip file, the pkginfo.xml type field. Default `"Kiosk"`.

### `exclusions`

Files to be excluded from a package. Default `".build/* .build .sign/* .sign webUnitTest/* webUnitTest .externalToolBuilders/* .externalToolBuilders .buildResult/* .buildResult .settings/* .settings .package/* .package .tproject .project .sdk_delta.info .rds_delta *.wgt .tizen-ui-builder-tool.xml *.zip"`

### `version`

The version that the package will be.

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
docker image build -t docker-tizen-ci-cd . # --no-cache # when changing builder layers

docker run -v "C:\projects\kiosk-v2":"/tizen" -e GITHUB_WORKSPACE="/tizen" --rm docker-tizen-ci-cd web tizen password cert "*.zip" true Kiosk 1.0.0
```

## Reference

[dockerhub image vipero07/docker-tizen-ci-cd](https://hub.docker.com/repository/docker/vipero07/docker-tizen-ci-cd)

[ghcr image ghcr.io/grubbrr/docker-tizen-ci-cd](https://ghcr.io/grubbrr/docker-tizen-ci-cd)

[Docker-tizen-studio-ide](https://github.com/ubergeek77/Docker-tizen-studio-ide)

[Tizen official sdk repository](http://download.tizen.org/sdk/tizenstudio/official/binary/)