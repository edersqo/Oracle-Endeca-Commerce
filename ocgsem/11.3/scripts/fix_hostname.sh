
#!/bin/sh

# On the building of the images and the installation process, the host is resolving to the current Docker layer.
# To workaround the described behaviour above, We replace (just after the success installaion of CAS, ToolsAndFrameworks, and Platform Services) the
# resolved host name with localhost.

#
# TODO: Find a proper solution
#   - 1. Create a Network for these containers even before building the image.
#   - 2. Gather a better understaing of the installation process and docker layering. 
#

sed -i 's/host=[^$]\+/host=localhost/' /u01/app/oracle_atg/product/oracle_gs/endeca/CAS/workspace/conf/commandline.properties
sed -i 's/DSTOP.KEY=[^$]\+/DSTOP.KEY=localhost/' /u01/app/oracle_atg/product/oracle_gs/endeca/CAS/11.3.0/bin/cas-service-wrapper.conf 
sed -i 's/DSTOP.KEY=[^$]\+/DSTOP.KEY=localhost/' /u01/app/oracle_atg/product/oracle_gs/endeca/CAS/11.3.0/bin/cas-service.sh
sed -i 's/host=[^$]\+/host=localhost/' /u01/app/oracle_atg/product/oracle_gs/endeca/PlatformServices/workspace/conf/eaccmd.properties
sed -i 's/cas.server=[^$]\+/cas.server=localhost/' /u01/app/oracle_atg/product/oracle_gs/endeca/ToolsAndFrameworks/11.3.0/server/workspace/conf/casconsole.properties
