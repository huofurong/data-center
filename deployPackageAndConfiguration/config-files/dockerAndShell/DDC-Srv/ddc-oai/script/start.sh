#!/bin/bash
java -Xms1G -Xmx2G -jar /bsn/ddc-oai/ROOT.jar \
--nacos.config.namespace=ddc_hashrate_system \
--nacos.config.server-addr=0.0.0.0:8848 \
--logging.logpath=/bsn/ddclogs