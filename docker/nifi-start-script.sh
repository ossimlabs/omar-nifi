export HOSTNAME=${HOSTNAME}.nifi
mkdir -p /opt/nifi/nifi-current/conf/special/
cp /data/nifi-conf/conf/flow.xml.gz /opt/nifi/nifi-current/conf/special/flow.xml.gz
sed -i 's:flow.xml.gz:special/flow.xml.gz:g' /opt/nifi/nifi-current/conf/nifi.properties
/opt/nifi/scripts/start.sh
