
# Entirely removes Discover Endeca Application

sh /u01/app/oracle_atg/product/oracle_gs/endeca/PlatformServices/11.3.0/bin/eaccmd.sh remove-app --app Discover
sh /u01/app/oracle_atg/product/oracle_gs/endeca/apps/Discover/control/runcommand.sh --remove-app
sh /u01/app/oracle_atg/product/oracle_gs/endeca/CAS/11.3.0/bin/component-manager-cmd.sh delete-component -n Discover-data
sh /u01/app/oracle_atg/product/oracle_gs/endeca/CAS/11.3.0/bin/component-manager-cmd.sh delete-component -n Discover-dimvals
sh /u01/app/oracle_atg/product/oracle_gs/endeca/CAS/11.3.0/bin/component-manager-cmd.sh delete-component -n Discover-dimension-value-id-manager
sh /u01/app/oracle_atg/product/oracle_gs/endeca/CAS/11.3.0/bin/cas-cmd.sh deleteCrawl -id Discover-last-mile-crawl
sh /u01/app/oracle_atg/product/oracle_gs/endeca/apps/Discover/control/runcommand.sh LockManager releaseLock update_lock
rm -r /u01/app/oracle_atg/product/oracle_gs/endeca/apps/Discover/