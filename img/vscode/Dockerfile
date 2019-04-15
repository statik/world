ARG BASE_CONTAINER=codercom/code-server
ARG BASE_DIGEST=sha256:3be6337fb3064e9638375ede04026adb5fe12b81927f656a476785d701c41f6d
FROM $BASE_CONTAINER@$BASE_DIGEST

COPY . /usr/local/.

USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    build-essential \
    python3

# python3 -> python? python2?

USER coder
