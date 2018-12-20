
#!/bin/sh
# style chkconfig
###
# chkconfig: 2345 95 85
# description: Script to start and stop Endeca Platform Services
###

SCRIPT_USER=endeca
SERVICE_NAME=endeca_platform
SCRIPT_PATH=/u01/app/oracle_atg/product/oracle_gs/endeca/PlatformServices/11.3.0/tools/server/bin
START_SCRIPT_NAME=startup.sh
STOP_SCRIPT_NAME=shutdown.sh

case "$1" in
    start)
    
        if [ `ps -ef | grep "java" | grep "PlatformServices" | grep -v grep | awk '{print $2}' | wc -l` = 0 ]; then
            echo "Starting Endeca Platform Services" 
            
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$START_SCRIPT_NAME"
        else
            echo "ENDECA PLATFORM SERVICES IS ALREADY RUNNING"
        fi
        
    ;;

    stop)
    
        if [ `ps -ef | grep "java" | grep "PlatformServices" | grep -v grep | awk '{print $2}' | wc -l` = 0 ]; then
            echo "ENDECA PLATFORM SERVICES IS NOT RUNNING"
        else
            echo "Stopping Endeca Platform Services" 
            
            /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$STOP_SCRIPT_NAME"
        fi
    
    ;;

    restart)
 
    if [ `ps -ef | grep "java" | grep "PlatformServices" | grep -v grep | awk' {print $2}' | wc -l` = 0 ]; then
        echo "ENDECA PLATFORM SERVICES IS NOT RUNNING" 
        
        /bin/su - $SCRIPT_USER -c "$SCRIPT_PATH/$START_SCRIPT_NAME"
    else
        echo "Restarting Endeca Platform Services" 
        
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