FROM ubuntu:18.04@sha256:c32bd2e76e7688eeb1bb39754fff7cdfc571626fc1abfded4f82a90de79f8d10

# https://github.com/microsoft/vscode-dev-containers/blob/a0e66d00f1108963186f06bce5fbf805e7201503/containers/bazel/.devcontainer/Dockerfile#L1

# Default to bash shell (other shells available at /usr/bin/fish and /usr/bin/zsh)
ENV SHELL=/bin/bash

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# See https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG DOCKER_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/ca56f6e76b9d431cf1c97084c2437bf9fbf4fa5e/script-library/docker-debian.sh"

# Configure apt and install packages
RUN apt-get update \
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verifty git, process tools, lsb-release (common in install instructions for CLIs) installed
    && apt-get -y install \
    binutils \
    cpp \
    g++ \
    gcc \
    git \
    iproute2 \
    lsb-release \
    make \
    procps \
    python3.7 \
    python3.7-distutil \
    python3.7-venv \
    sudo \
    unzip \
    # 
    # Python
    ln -s python3 /usr/bin/python \
    #
    # Setup user
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Use Docker script from script library to set things up
    && curl -sSL $DOCKER_SCRIPT_SOURCE -o /tmp/docker-setup.sh \
    && /bin/bash /tmp/docker-setup.sh "${ENABLE_NONROOT_DOCKER}" "${SOURCE_SOCKET}" "${TARGET_SOCKET}" "${USERNAME}" \
    && rm /tmp/docker-setup.sh \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to 
# the Docker socket if "overrideCommand": false is set in devcontainer.json. 
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD [ "sleep", "infinity" ]
USER $USERNAME