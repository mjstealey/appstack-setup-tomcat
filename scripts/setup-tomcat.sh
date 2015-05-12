#!/bin/bash

TOMCAT_VERSION='8.0.22'

# Install prerequisites
#yum install -y wget tar sudo

# Install java 8
cd /opt/
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u45-b14/jdk-8u45-linux-x64.tar.gz"
tar xzf jdk-8u45-linux-x64.tar.gz
mv /opt/jdk1.8.0_45/* /opt/java
cd /opt/java
alternatives --install /usr/bin/java java /opt/jdk1.8.0_45/bin/java 2
alternatives --install /usr/bin/jar jar /opt/java/bin/jar 2
alternatives --install /usr/bin/javac javac /opt/java/bin/javac 2
alternatives --set jar /opt/java/bin/jar
alternatives --set javac /opt/java/bin/javac

export JAVA_HOME=/opt/java
export JRE_HOME=/opt/java/jre
export PATH=$PATH:/opt/java/bin:/opt/java/jre/bin

# Install tomcat 8
cd /opt/
wget http://www.us.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz
tar xzf apache-tomcat-${TOMCAT_VERSION}.tar.gz
mv /opt/apache-tomcat-${TOMCAT_VERSION}/* /opt/tomcat

# Create tomcat service account
adduser -g 99 -c "Tomcat Service Account" -s /bin/bash -d /opt/tomcat tomcat
echo "export CATALINA_HOME=\"/opt/tomcat\"" >> ~/.bashrc
source ~/.bashrc
chown -R tomcat tomcat/

# Create tomcat web administrator
sed -i 's!</tomcat-users>!<role rolename="manager-gui"/>\
    <role rolename="manager-script"/>\
    <role rolename="manager-jmx"/>\
    <role rolename="manager-status"/>\
    <role rolename="admin-gui"/>\
    <role rolename="admin-script"/>\
    <user username="admin" password="admin" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-gui,admin-script"/>\
    </tomcat-users>!g' /opt/tomcat/conf/tomcat-users.xml

# su tomcat <<'EOF'
# /opt/tomcat/bin/startup.sh
# EOF

# keep server running
# /usr/bin/tail -f /dev/null