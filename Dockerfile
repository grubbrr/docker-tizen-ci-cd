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

RUN apt-get update && apt-get install -y --no-install-recommends \
	# acl \
	# bridge-utils \
	# cpio \
	# gettext \
	# libcanberra-gtk-module \
	# libcurl3-gnutls \
	# libsdl1.2debian \
	# libv4l-0 \
	# libxcb-render-util0 \
	# libxcb-randr0 \
	# libxcb-shape0 \
	# libxcb-icccm4 \
	# libxcb-image0 \
	# libxtst6 \
	# make \
	# openvpn \
	# pciutils \
	# python2.7 \
	# qemu-kvm \
	# rpm2cpio \
	# sudo \
	# zenity \
	# zip \
	# libncurses5 \
	# ca-certificates \
	# libpython2.7 \
	# unzip \
	# locales \
	gnome-keyring \
	dbus-x11 \
	# libsecret \
	# secret-tools \
	&& \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ARG T_USER=tizen

COPY --from=builder /home/${T_USER}/tizen-studio/ /home/${T_USER}/tizen-studio/
ENV PATH="/home/${T_USER}/tizen-studio/tools/ide/bin:{$PATH}"
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]