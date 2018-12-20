#!/bin/sh
# style chkconfig
###
# chkconfig: 2345 95 85
# description: Script to start and stop Endeca Workbench
###

SCRIPT_USER=endeca
SERVICE_NAME=endeca_tools
SCRIPT_PATH=/u01/app/oracle_atg/product/oracle_gs/endeca/ToolsAndFrameworks/11.3.0/server/bin
START_SCRIPT_NAME=startup.sh
STOP_SCRIPT_NAME=shutdown.sh

case "$1" in
    start)
        
        if [ `ps -ef | grep "java" | grep "ToolsAndFrameworks" | grep -v grep | awk '{print $2}' | wc -l` = 0 ]; then
            echo "Starting Endeca Workbench"
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$START_SCRIPT_NAME"
        else
            echo "ENDECA WORKBENCH IS ALREADY RUNNING"
        fi
    
        ;;

    stop)

        if [ `ps -ef | grep "java" | grep "ToolsAndFrameworks" | grep -v grep | awk '{print $2}' | wc -l` = 0 ]; then
            echo "ENDECA WORKBENCH IS NOT RUNNING"
        else
            echo "Stopping Endeca Workbench"
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$STOP_SCRIPT_NAME"
        fi
        
        ;;

    restart)
    
        if [ `ps -ef | grep "java" | grep "ToolsAndFrameworks" | grep -v grep | awk '{print $2}' | wc -l` = 0 ]; then
            echo "ENDECA WORKBENCH IS NOT RUNNING"
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$START_SCRIPT_NAME"
        else
            echo "Restarting Endeca Workbench"
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$STOP_SCRIPT_NAME"
            /bin/sleep 10
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$START_SCRIPT_NAME"
        fi
    
        ;;
    
    *)
        echo "Usage: /sbin/service $SERVICE_NAME {start|stop|restart}"
        exit 1
    
        ;;
    esac

exit 0