FROM apache/nifi:1.8.0
USER root
RUN usermod -u 1001 nifi
RUN find / -user 1000 -not -wholename '/proc/*' -exec chown -h 1001 {} \;
USER nifi
