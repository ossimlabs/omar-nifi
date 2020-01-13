FROM apache/nifi:1.9.2
USER root
RUN usermod -u 1001 nifi
RUN find / -xdev -user 1000 -exec chown -h 1001 {} \;
USER nifi
