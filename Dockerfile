FROM ubuntu:kinetic AS builder

ARG UID=1000
ARG GID=1000
ARG T_USER=tizen

RUN groupadd -g ${GID} -o ${T_USER} && \
	useradd -m -d /home/${T_USER} -u ${UID} -g ${GID} -o -s /bin/bash ${T_USER} && \
	mkdir -p /run/user/$UID && \
	chown ${UID}:${GID} /run/user/${UID}

ARG T_VERSION=4.6
ARG T_BINARY=web-cli_Tizen_Studio_${T_VERSION}_ubuntu-64.bin
    
ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/Installer/tizen-studio_${T_VERSION}/${T_BINARY} /home/${T_USER}/${T_BINARY}

RUN chmod +x /home/${T_USER}/${T_BINARY}

USER ${T_USER}

RUN /home/${T_USER}/${T_BINARY} --accept-license /home/${T_USER}/tizen-studio && \
    rm /home/${T_USER}/${T_BINARY}

# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/COMMON-MANDATORY_2.8.6_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/COMMON-MANDATORY_2.8.6_ubuntu-64.zip
# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/sdb_4.2.9_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/sdb_4.2.9_ubuntu-64.zip
# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/sdk-info_2.5.0_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/sdk-info_2.5.0_ubuntu-64.zip
# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/package-manager-cli_0.5.6_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/package-manager-cli_0.5.6_ubuntu-64.zip
# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/sdk-utils-core_0.2.3_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/sdk-utils-core_0.2.3_ubuntu-64.zip
# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/sdk-utils_0.2.3_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/sdk-utils_0.2.3_ubuntu-64.zip
# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/device-manager-product_1.2.9_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/device-manager-product_1.2.9_ubuntu-64.zip

# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/BASELINE-COMMON_2.8.6_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/BASELINE-COMMON_2.8.6_ubuntu-64.zip
# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/COMMON-CLI_2.8.6_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/COMMON-CLI_2.8.6_ubuntu-64.zip

# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/Certificate-Manager_2.8.6_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/Certificate-Manager_2.8.6_ubuntu-64.zip
# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/certificate-manager-product_1.3.0_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/certificate-manager-product_1.3.0_ubuntu-64.zip
# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/certificate-generator_0.1.3_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/certificate-generator_0.1.3_ubuntu-64.zip
# ADD --chown=${UID}:${GID} http://download.tizen.org/sdk/tizenstudio/official/binary/certificate-encryptor_1.0.7_ubuntu-64.zip /home/${T_USER}/tizen-studio/.info/.downloads/certificate-encryptor_1.0.7_ubuntu-64.zip

USER root


FROM ubuntu:kinetic AS install

ARG UID=1000
ARG GID=1000
ARG T_USER=tizen

RUN groupadd -g ${GID} -o ${T_USER} && \
	useradd -m -d /home/${T_USER} -u ${UID} -g ${GID} -o -s /bin/bash ${T_USER} && \
	mkdir -p /run/user/$UID && \
	chown ${UID}:${GID} /run/user/${UID}
#   apt-get update && apt-get install -y --no-install-recommends \
#         zip \
#         gettext \
#         rpm2cpio \
#         make \
#         cpio \
#         libncurses5 \
#         python2.7 \
#         libpython2.7 && \
#     apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --chown=${UID}:${GID} --from=builder /home/${T_USER}/tizen-studio/ /home/${T_USER}/tizen-studio/

# ARG T_PACKAGES=Certificate-Manager,NativeCLI,WebCLI,NativeToolchain,TV-SAMSUNG-Public-WebAppDevelopment,cert-add-on,TV-SAMSUNG-Extension-Tools,TV-SAMSUNG-Extension-Resources
# ARG T_PACKAGES=Certificate-Manager

USER ${T_USER}

# RUN /home/${T_USER}/tizen-studio/package-manager/package-manager-cli.bin \
#     install --accept-license --no-java-check ${T_PACKAGES} && \
#     rm -rf /home/${T_USER}/tizen-studio/.info/.downloads/

RUN /home/${T_USER}/tizen-studio/tools/ide/bin/tizen.sh \
    certificate -a devcert -f devcert -p nonsense

USER root


# FROM ubuntu:kinetic as final

# ARG UID=1000
# ARG GID=1000
# ARG T_USER=tizen

# COPY --chown=${UID}:${GID} --from=install /home/${T_USER}/tizen-studio/ /home/${T_USER}/tizen-studio/
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]