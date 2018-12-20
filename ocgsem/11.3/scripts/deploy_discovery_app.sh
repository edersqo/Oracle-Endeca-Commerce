#!/bin/sh

# Script used to silently install Endeca Discover application.
 
/u01/app/oracle_atg/product/oracle_gs/endeca/ToolsAndFrameworks/11.3.0/deployment_template/bin/deploy.sh \
    --app /u01/app/oracle_atg/product/oracle_gs/endeca/ToolsAndFrameworks/11.3.0/reference/discover-data-cas/deploy.xml \
	--install-config /home/endeca/conf/cas_app_install_config.xml --no-prompt

/u01/app/oracle_atg/product/oracle_gs/endeca/apps/Discover/control/initialize_services.sh --force
/u01/app/oracle_atg/product/oracle_gs/endeca/apps/Discover/control/load_baseline_test_data.sh
/u01/app/oracle_atg/product/oracle_gs/endeca/apps/Discover/control/baseline_update.sh
/u01/app/oracle_atg/product/oracle_gs/endeca/apps/Discover/control/promote_content.sh