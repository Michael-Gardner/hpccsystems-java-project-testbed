FROM hpccsystems/platform:latest

COPY startup.sh /startup.sh
COPY generatedata.sh /generatedata.sh
COPY generatebenchmarkdata.sh /generatebenchmarkdata.sh

ENTRYPOINT ["/startup.sh"]
