
# run
# docker run -t -d -p 2222:22 -p 8006:8006 -p 8888:8888 -p 15000:15000 -p 15002:15002 -p 15010:15010 --name endeca11.3 ocgsem/endeca:11.3

FROM oraclelinux:7.2
LABEL maintainer "eder.quinones@gmail.com" description "Eder Quiñones"

# Install required OS packages.
RUN yum -y install unzip && \
    yum -y install tar && \
    yum -y install sudo && \
    yum -y install libaio && \
    yum -y install glibc.i686 && \
    yum -y install less && \
    yum -y install tree 

# Install GOSU
RUN curl -o /usr/local/bin/gosu -SL 'https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64' \
    && chmod +x /usr/local/bin/gosu

# Local Files.
ENV LOCAL_CONF conf
ENV LOCAL_SCRIPTS scripts
ENV LOCAL_PROP properties
ENV INSTALLERS software

# Oracle User Data Moint #1.
ENV ORACLE_USER_MOUNT_POINT=/u01/app/ 
RUN mkdir -p $ORACLE_USER_MOUNT_POINT

# Oracle Commerce Guided Search with Experience Manager installation Path.
ENV ENDECA_HOME=$ORACLE_USER_MOUNT_POINT/oracle_atg/product/oracle_gs
RUN mkdir -p $ENDECA_HOME/endeca
RUN mkdir -p $ENDECA_HOME/endeca/apps

###############################################################################
#
#
# Install Java Development Kit
#
#
###############################################################################

# Java 8, JDK installer,  (Version as suggested in Oracle Commerce Compatibility Matrix)
ENV JAVA_INSTALLER=software/jdk-8u*-linux-x64.tar

# Install Java 8u*, compatible with Oracle Commerce 11.3.
ADD $JAVA_INSTALLER /usr/java/

# Add Java alternatives.
RUN export JAVA_HOME=$(ls -1 -d /usr/java/*) && \
    alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 200001 && \
    alternatives --install /usr/bin/javaws javaws $JAVA_HOME/bin/javaws 200001 && \
    alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 200001 && \
    alternatives --install /usr/bin/jar jar $JAVA_HOME/bin/jar 200001

###############################################################################
#
#
# Endeca User Creation
#
#
###############################################################################

# Create endeca user.
ENV USER_HOME_DIR /home/endeca
RUN useradd -m -d $USER_HOME_DIR endeca -G root -p westitora

# Add proper priviledges to the Endeca installation folder.
RUN chown -R endeca:endeca $ENDECA_HOME/endeca
RUN chmod -R 755 $ENDECA_HOME/endeca

# Add proper permissions to the Oracle's user mount point #1.
RUN chmod -R 755 $ORACLE_USER_MOUNT_POINT
RUN chown -R endeca:endeca $ORACLE_USER_MOUNT_POINT

# Folder used to copy temporarily the Oracle Commerce Guided Search with Experiene Manager installers.
ENV TMP_FOLDER /tmp
ENV TMP_FOLDER_ENDECA_INSTALL $TMP_FOLDER/endeca
ENV TMP_FOLDER_PACKAGE_INSTALL $TMP_FOLDER_ENDECA_INSTALL/packages

# Endeca User Config, Properties, and Script location.
ENV SCRIPT_DIR $USER_HOME_DIR/bin
ENV CONF_DIR $USER_HOME_DIR/conf
ENV PROP_DIR $USER_HOME_DIR/properties

###############################################################################
#
#
# Copy installers from local directory to the OS temporary folder
#
#
###############################################################################

# Local copy of Platform and Service 11.3
ADD $INSTALLERS/V861203-01.zip $TMP_FOLDER_ENDECA_INSTALL/V861203-01.zip

# Local copy of  MDEX 11.3
ADD $INSTALLERS/V861206-01.zip $TMP_FOLDER_ENDECA_INSTALL/V861206-01.zip

# Local copy of Tools And Frameworks with Experience Mangeer 11.3
ADD $INSTALLERS/V861200-01.zip $TMP_FOLDER_ENDECA_INSTALL/V861200-01.zip

# Local copy of Content Adquisition System 11.3
ADD $INSTALLERS/V861198-01.zip $TMP_FOLDER_ENDECA_INSTALL/V861198-01.zip

# Change the ownership of the installers to the endeca user
RUN chown -R endeca:endeca $TMP_FOLDER_ENDECA_INSTALL/

###############################################################################
#
#
# Unzip the content inside the following zip files:
#     * V861206-01.zip - MDEX
#     * V861203-01.zip - Platform And Services
#     * V861200-01.zip - Tools And Frameworks
#     * V861198-01.zip - Content Adquisition System
#
#
###############################################################################

# Using the endeca usar, perform the following operations:
#   - Unzip the installers
#   - Change access permissions to write to the bin files gathered thru unzipping the installers
#
USER endeca

RUN unzip -o $TMP_FOLDER_ENDECA_INSTALL/V861203-01.zip -d $TMP_FOLDER_PACKAGE_INSTALL/ && \
    unzip -o $TMP_FOLDER_ENDECA_INSTALL/V861206-01.zip -d $TMP_FOLDER_PACKAGE_INSTALL/ && \
    unzip -o $TMP_FOLDER_ENDECA_INSTALL/V861200-01.zip -d $TMP_FOLDER_PACKAGE_INSTALL/ && \
    unzip -o $TMP_FOLDER_ENDECA_INSTALL/V861198-01.zip -d $TMP_FOLDER_PACKAGE_INSTALL/ 

RUN chmod +x $TMP_FOLDER_PACKAGE_INSTALL/*.bin

###############################################################################
#
#
# Install MDEX Engine
#   Documents:
#     - MDEX Engine Installation Guide [1]
#
#
#  MDEX Engine Installation Guide. (n.d.). Retrieved June 22, 2018, from https://docs.oracle.com/cd/E70266_01/mdex.11.3/EndecaMDEXinstall/html/index.html
#
#
###############################################################################

USER endeca

# MDEX silent install script
ENV MDEX_SILENT_PATH $TMP_FOLDER_ENDECA_INSTALL/
ENV MDEX_SILENT_INSTALL_FILE $MDEX_SILENT_PATH/mdex_silent_install.properties

# MDEX install directory.
ENV USER_INSTALL_DIR $ENDECA_HOME
ENV ENDECA_MDEX_INSTALL_DIR $ENDECA_HOME/endeca/MDEX/11.3.0

# Compose MDEX silent install script (As per Oracle Documentation)
RUN echo USER_INSTALL_DIR=$USER_INSTALL_DIR > $MDEX_SILENT_INSTALL_FILE
RUN sh $TMP_FOLDER_PACKAGE_INSTALL/OCmdex*-Linux64*.bin -i silent -f $MDEX_SILENT_INSTALL_FILE -r mdex_response.properties

# Copy MDEX Engine environment variables into .bashrc (In order to be loaded whenever bash is started interactively)
RUN cat $ENDECA_MDEX_INSTALL_DIR/mdex_setup_sh.ini >> $USER_HOME_DIR/.bashrc

# Pre-load variables mentioned above. 
RUN source $USER_HOME_DIR/.bashrc

# Add ENDECA_MDEX_ROOT into the PATH environment variable.
ENV ENDECA_MDEX_ROOT $ENDECA_MDEX_INSTALL_DIR
ENV PATH $ENDECA_MDEX_ROOT/bin:$PATH

###############################################################################
#
#
# Install Platform and Services
#
#  Documents:
#    - Guided Search Platform Services Installation Guide [1]
#
# 1. Guided Search Platform Services Installation Guide. (n.d.). Retrieved June 22, 2018, from https://docs.oracle.com/cd/E70265_01/mdex.11-3/Endecacasplatinstall/html
#
###############################################################################

USER endeca

# Properties and values required for the PlatformServices installation.
ENV USER_INSTALL_DIR=$ENDECA_HOME/
ENV EAC_SERVICE_PORT 8888
ENV EAC_SERVICE_SHUTDOWN_PORT 8090
ENV MDEX_ROOT $ENDECA_MDEX_INSTALL_DIR

# PlatformService install script
ENV PS_SILENT_PATH $TMP_FOLDER_ENDECA_INSTALL/
ENV PS_SILENT_INSTALL_FILE $PS_SILENT_PATH/platformservices_silent_install.properties

# Compose the PlatformService silent install script (As per Oracle Documentation) 
RUN echo USER_INSTALL_DIR=$USER_INSTALL_DIR/ >> $PS_SILENT_INSTALL_FILE && \
    echo ENDECA_USER_NAME=endeca >> $PS_SILENT_INSTALL_FILE && \ 
    echo ETOOLS_HTTP_PORT=$EAC_SERVICE_PORT >> $PS_SILENT_INSTALL_FILE && \
    echo ETOOLS_SERVER_PORT=$EAC_SERVICE_SHUTDOWN_PORT >> $PS_SILENT_INSTALL_FILE && \
    echo EAC_MDEX_ROOT=$ENDECA_MDEX_INSTALL_DIR >> $PS_SILENT_INSTALL_FILE

# Run the install script in silent mode with the previously generated silent script properties.
RUN $TMP_FOLDER_PACKAGE_INSTALL/OCplatformservices*-Linux64.bin -i silent -f $PS_SILENT_INSTALL_FILE -r platformservices_response.properties

# PlatformServices enviroment variables.
ENV VERSION 11.3.0
ENV BUILD_VERSION 11.3.0.1394436
ENV ARCH_OS x86_64pc-linux
ENV PRODUCT IAP
ENV ENDECA_CONF $ENDECA_HOME/endeca/PlatformServices/workspace/
ENV ENDECA_REFERENCE_DIR $ENDECA_HOME/endeca/PlatformServices/reference/
ENV ENDECA_ROOT $ENDECA_HOME/endeca/PlatformServices/11.3.0/
ENV PERL5LIB $ENDECA_HOME/endeca/PlatformServices/11.3.0/perl:/$ENDECA_HOME/endeca/PlatformServices/11.3.0/perl/lib/5.8.3/
ENV UNIXUTILS $ENDECA_HOME/endeca/PlatformServices/11.3.0/utilities/

# Copy PlatformService environment variables into .bashrc (In order to be loaded whenever bash is started interactively)
RUN cat $ENDECA_HOME/endeca/PlatformServices/workspace/setup/installer_sh.ini >> $USER_HOME_DIR/.bashrc

# Pre-load variables mentioned above.
RUN source $USER_HOME_DIR/.bashrc

# Workaround, binaries are copied as read/write only.
# TODO: Why silent install is leaving binaries as read and write.
USER root
RUN chmod -R 755 $ENDECA_HOME/endeca/PlatformServices/

# Workaround, while installing Tools And Frameworks, apparently while trying to resolve hostname the build
# script is getting image-layer id instead of localhost. You might need to configure a DNS / Network and link 
# before building the image.
RUN sed -i 's/host=[^$]\+/host=localhost/' /u01/app/oracle_atg/product/oracle_gs/endeca/PlatformServices/workspace/conf/eaccmd.properties

###############################################################################
#
#
# Install Tools And Frameworks
#
#  Documents:
#    - Guided Search Tools and Framework Installation Guide [1]
#  
# 1. Guided Search Platform Services Installation Guide. (n.d.). Retrieved June 22, 2018, from https://docs.oracle.com/cd/E70265_01/mdex.11-3/Endecacasplatinstall/html/
#
###############################################################################

USER endeca

# Workbench port.
ENV WORKBENCH_PORT 8006

# Tools and Frameworks directory paths.
ENV ENDECA_TOOLS_ROOT $ENDECA_HOME/endeca/ToolsAndFrameworks/11.3.0/
ENV ENDECA_TOOLS_CONF $ENDECA_TOOLS_ROOT/server/workspace/

# Tools and Frameworks silent install script location.
ENV TF_SILENT_SH_PATH $TMP_FOLDER_PACKAGE_INSTALL/cd/Disk1/install/silent_install.sh
ENV TF_SILENT_RSP_PATH $TMP_FOLDER_PACKAGE_INSTALL/cd/Disk1/install/silent_response.rsp

#
# silent_install.sh
#
# Usage: silent_install.sh <FULL_PATH_TO_RESPONSE_FILE> <ORACLE_HOME_NAME> <ORACLE_HOME_LOCATION> [<ORACLE_INVENTORY_CONF_FILE>]
#   FULL_PATH_TO_RESPONSE_FILE - The full path to response file which will be consumed by the silent installer
#   ORACLE_HOME_NAME - A string value which represents your ORACLE_HOME
#   ORACLE_HOME_LOCATION - The location where you would like to install the product
#   ORACLE_INVENTORY_CONF_FILE (optional) - Full path to file "oraInst.loc". Create this file with a single line as follows(without quotes): "inventory_loc=<FULL_PATH_TO_FOLDER_USED_AS_INVENTORY>"
#

# Perform replace operation inside silent install script. 
RUN sed -i 's/dba/root/g' $TF_SILENT_RSP_PATH

# Run the install script in silent mode, using the OOTB silent install script.
RUN $TF_SILENT_SH_PATH $TF_SILENT_RSP_PATH ToolsAndFrameworks $ENDECA_HOME/endeca/ToolsAndFrameworks

# Set ToolsAndFrameworks environemnt varialbes.
RUN echo ENDECA_TOOLS_ROOT=$ENDECA_TOOLS_ROOT >> $USER_HOME_DIR/.bashrc
RUN echo ENDECA_TOOLS_CONF=$ENDECA_TOOLS_CONF >> $USER_HOME_DIR/.bashrc

# Update current context
RUN source $USER_HOME_DIR/.bashrc

# As requested by the Tools and Frameworks installer, the orainstRoot script must be executed.
USER root
RUN $ORACLE_USER_MOUNT_POINT/oraInventory/orainstRoot.sh

#
# TODO:
# Perform the configuration in order to use JRE and JDK already contained in the ToolsAndFramworks package.
# As of now, the Dockerfile is installing the JDK located at the software folder. 
#

# Set JDK
#ENV JAVA_HOME $ENDECA_TOOLS_ROOT/server/jdk1.8.0_121/
#RUN echo JAVA_HOME=$JAVA_HOME >> $USER_HOME_DIR/.bashrc

# Add Java alternatives 
#RUN export JAVA_HOME=$JAVA_HOME && \
#    alternatives --install /usr/bin/java java $JAVA_HOME/bin/java 200000 && \
#    alternatives --install /usr/bin/javaws javaws $JAVA_HOME/bin/javaws 200000 && \
#    alternatives --install /usr/bin/javac javac $JAVA_HOME/bin/javac 200000 && \
#    alternatives --install /usr/bin/jar jar $JAVA_HOME/bin/jar 200000

###############################################################################
#
#
# Install Content Adquisition System
#  Documents:
#    - Content Adquisition System Installation Guide [1]
#
# 1. Content Acquisition System Installation Guide. (n.d.). Retrieved June 22, 2018, from https://docs.oracle.com/cd/E70265_01/cas.11-3/Endecacasinstall/html/index.html
#
###############################################################################

USER endeca 

# Environment variables used to install and create response file for CAS installation.
ENV USER_INSTALL_DIR $ENDECA_HOME
ENV CAS_RSP_PATH $TMP_FOLDER_ENDECA_INSTALL/cas_silent_install.properties

# CAS related environment variables 
ENV CAS_PORT 8500
ENV CAS_SHUTDOWN_PORT 8506
ENV CAS_HOST localhost

# Build Content Adquisition System response file.
RUN echo USER_INSTALL_DIR=$USER_INSTALL_DIR/ >> $CAS_RSP_PATH && \
    echo CASPORT=$CAS_PORT >> $CAS_RSP_PATH && \
    echo CASHOST=$CAS_HOST >> $CAS_RSP_PATH && \
    echo CASSHUTDOWNPORT=$CAS_SHUTDOWN_PORT >> $CAS_RSP_PATH && \
    echo ENDECA_TOOLS_ROOT=$ENDECA_TOOLS_ROOT >> $CAS_RSP_PATH && \
    echo ENDECA_TOOLS_CONF=$ENDECA_TOOLS_CONF >> $CAS_RSP_PATH

# Run CAS installer.
RUN $TMP_FOLDER_PACKAGE_INSTALL/OCcas11.3.0-Linux64.bin -i silent -f $CAS_RSP_PATH  -r cas_response.properties

# Set environment variables for CAS. 
RUN echo CAS_ROOT=$ENDECA_HOME/endeca/CAS/11.3.0 >> $USER_HOME_DIR/.bashrc
RUN echo CAS_WORKSPACE=$ENDECA_HOME/endeca/CAS/workspace >> $USER_HOME_DIR/.bashrc

# Update the current context. 
RUN source $USER_HOME_DIR/.bashrc

# Add Stop Port to CAS service. 
RUN sed -i 's/-DSTOP.PORT=/-DSTOP.PORT=8506/g' $ENDECA_HOME/endeca/CAS/11.3.0/bin/cas-service.sh

# Workaround, while installing CAS, PlatformServices, or Tools And Frameworks. Apparently while trying to resolve hostname the build
# script is getting image-layer id instead of the resolving host. You might need to configure a DNS / Network and link the image / container to those networks
# before building the image.
RUN sed -i 's/host=[^$]\+/host=localhost/' /u01/app/oracle_atg/product/oracle_gs/endeca/CAS/workspace/conf/commandline.properties
RUN sed -i 's/DSTOP.KEY=[^$]\+/DSTOP.KEY=localhost/' /u01/app/oracle_atg/product/oracle_gs/endeca/CAS/11.3.0/bin/cas-service-wrapper.conf 
RUN sed -i 's/DSTOP.KEY=[^$]\+/DSTOP.KEY=localhost"/' /u01/app/oracle_atg/product/oracle_gs/endeca/CAS/11.3.0/bin/cas-service.sh
RUN sed -i 's/cas.server=[^$]\+/cas.server=localhost/' /u01/app/oracle_atg/product/oracle_gs/endeca/ToolsAndFrameworks/11.3.0/server/workspace/conf/casconsole.properties

###############################################################################
#
#
# Copy local files (script, configurations, and properties) into the container.
#
#
###############################################################################

USER root 

# Create Script, Conf, and Properties directories.
RUN mkdir -p $SCRIPT_DIR
RUN mkdir -p $CONF_DIR
RUN mkdir -p $PROP_DIR

# Copy Script and Config files into Endeca user.
COPY $LOCAL_SCRIPTS/*.sh $SCRIPT_DIR/
COPY $LOCAL_CONF/*.* $CONF_DIR/
COPY $LOCAL_PROP/*.* $PROP_DIR/

# Change access permissions to the script files.
RUN chmod -R 755 $SCRIPT_DIR && \
    chmod +x $SCRIPT_DIR/*.sh

RUN chown -R endeca:endeca $SCRIPT_DIR/*.sh

# Change access permissions to the configuration files.
RUN chmod -R 755 $CONF_DIR && \
    chmod +x $CONF_DIR/*.*

RUN chown -R endeca:endeca $CONF_DIR/*.*

# Change access permissions to the properties files.
RUN chmod -R 755 $PROP_DIR && \
    chmod +x $PROP_DIR/*.*

RUN chown -R endeca:endeca $PROP_DIR/*.*

###############################################################################
#
#
# Setup Services
#
#
###############################################################################

USER root

# Endeca Tools And Framworks Service
RUN cp $SCRIPT_DIR/endeca_tools.sh /etc/init.d/endeca_tools
RUN chkconfig --add endeca_tools

# Endeca Platform And Services Service
RUN cp $SCRIPT_DIR/endeca_platform.sh /etc/init.d/endeca_platform
RUN chkconfig --add endeca_platform

# Endeca Content Adquisition System Service
RUN cp $SCRIPT_DIR/endeca_cas.sh /etc/init.d/endeca_cas
RUN chkconfig --add endeca_cas

###############################################################################
#
#
# Endeca Environment Variables for root.
#   TODO: Enable endeca user as sudoer.
#
#
###############################################################################

USER root

# MDEX Engine environment variables.
RUN cat $ENDECA_MDEX_INSTALL_DIR/mdex_setup_sh.ini >> /root/.bashrc

# PlatformService environment variables.
RUN cat $ENDECA_HOME/endeca/PlatformServices/workspace/setup/installer_sh.ini >> /root/.bashrc

# ToolsAndFrameworks environemnt varialbes.
RUN echo ENDECA_TOOLS_ROOT=$ENDECA_TOOLS_ROOT >> /root/.bashrc
RUN echo ENDECA_TOOLS_CONF=$ENDECA_TOOLS_CONF >> /root/.bashrc

# CAS environment variables. 
RUN echo CAS_ROOT=$ENDECA_HOME/endeca/CAS/11.3.0 >> /root/.bashrc
RUN echo CAS_WORKSPACE=$ENDECA_HOME/endeca/CAS/workspace >> /root/.bashrc

###############################################################################
#
#
# Update Workbench credentials in the credential store.
#
#
###############################################################################

USER endeca
RUN cd $ENDECA_TOOLS_ROOT/credential_store/bin/ && \
    cat $CONF_DIR/ifcr.txt | ./manage_credentials.sh add --key ifcr

###############################################################################
#
#
# Expose application ports (CAS, PS, T&F)
#
#
###############################################################################

EXPOSE 22 $CAS_PORT $EAC_SERVICE_PORT $WORKBENCH_PORT

###############################################################################
#
#
# Entry Point 
#
#
###############################################################################

USER root

COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod 755 /usr/local/bin/docker-entrypoint.sh
RUN ln -s usr/local/bin/docker-entrypoint.sh /

ENTRYPOINT ["docker-entrypoint.sh"]

