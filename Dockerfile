FROM hpccsystems/platform:latest

COPY startup.sh /startup.sh

ENTRYPOINT ["/startup.sh"]