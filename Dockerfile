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
COPY generatedata.sh /generatedata.sh
COPY generatebenchmarkdata.sh /generatebenchmarkdata.sh

ENTRYPOINT ["/startup.sh"]
