ARG BASE_CONTAINER=codercom/code-server
ARG BASE_DIGEST=sha256:3be6337fb3064e9638375ede04026adb5fe12b81927f656a476785d701c41f6d
FROM $BASE_CONTAINER@$BASE_DIGEST

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    python3

COPY . /usr/local/.
RUN ln -s /home/coder/project/.cache /home/coder/.cache

USER coder
