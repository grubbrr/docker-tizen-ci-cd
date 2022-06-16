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

USER root


FROM ubuntu:kinetic AS install

ARG T_USER=tizen

COPY --from=builder /home/${T_USER}/tizen-studio/ /home/${T_USER}/tizen-studio/
ENV PATH="/home/${T_USER}/tizen-studio/tools/ide/bin:{$PATH}"
COPY --chmod=777 entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]