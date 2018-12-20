#!/bin/sh
# style chkconfig
###
# chkconfig: 2345 95 85
# description: Script to start and stop Endeca Content Acquisition System
###

SCRIPT_USER=endeca
SERVICE_NAME=endeca_cas
SCRIPT_PATH=/u01/app/oracle_atg/product/oracle_gs/endeca/CAS/11.3.0/bin
START_SCRIPT_NAME=cas-service.sh
STOP_SCRIPT_NAME=cas-service-shutdown.sh

case "$1" in
    start)

        if [ `ps -ef | grep "java" | grep "endeca.cas.root" | grep -v grep | awk '{print $2}' | wc -l` = 0 ]; then
            echo "Starting Endeca CAS"
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$START_SCRIPT_NAME &"
        else
            echo "ENDECA CAS IS ALREADY RUNNING"
        fi
        
        ;;

    stop)

        if [ `ps -ef | grep "java" | grep "endeca.cas.root" | grep -v grep | awk '{print $2}' | wc -l` = 0 ]; then
            echo "ENDECA CAS IS NOT RUNNING"
        else
            echo "Stopping Endeca CAS"
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$STOP_SCRIPT_NAME &"
        fi
        
        ;;

    restart)

        if [ `ps -ef | grep "java" | grep "endeca.cas.root" | grep -v grep | awk '{print $2}' | wc -l` = 0 ]; then
            echo "ENDECA CAS IS NOT RUNNING"
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$START_SCRIPT_NAME &"
        else
            echo "Restarting Endeca CAS"
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$STOP_SCRIPT_NAME &"
            /bin/sleep 10
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$START_SCRIPT_NAME &"
        fi
        
        ;;

    *)
        echo "Usage: /sbin/service $SERVICE_NAME {start|stop|restart}"
        exit 1
    
        ;;
    
    esac
exit 0