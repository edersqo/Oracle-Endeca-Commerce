#!/bin/sh

# Starts Guided Search Endeca Services

sh /u01/app/oracle_atg/product/oracle_gs/endeca/PlatformServices/11.3.0/tools/server/bin/startup.sh
sh /u01/app/oracle_atg/product/oracle_gs/endeca/ToolsAndFrameworks/11.3.0/server/bin/startup.sh
sh /u01/app/oracle_atg/product/oracle_gs/endeca/CAS/11.3.0/bin/cas-service.sh
 