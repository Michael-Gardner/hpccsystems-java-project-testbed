FROM hpccsystems/platform:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt clean -y && \
    apt autoclean -y && \
    apt install -y -f && \
    apt autoremove -y && \
    apt-get update -y

RUN apt-get install -y \
    maven \
    git

COPY startup.sh /startup.sh

ENTRYPOINT ["/startup.sh"]