#!/bin/bash
# The example: bash ssl_one_way.sh kafka-0.tigergraph.com ~/SSL_one_way tiger123
# The example password: tiger123
# The example server host name: kafka-0.tigergraph.com
# The certificate generation path: ~/SSL_one_way

if [ $# -eq 3 ]; then
  server_hostname=$1
  generate_root=$2
  pass=$3
else
  echo "Error in parameter. Please check."
  echo "e.g. bash ssl_one_way.sh server_hostname generate_root password"
  exit 1
fi

env_prepare(){
  # install java
  if ! which java > /dev/null 2>&1; then
    echo "start install openjdk."
    sudo yum update -y > /dev/null 2>&1
    sudo yum install -y java-1.8.0-openjdk > /dev/null 2>&1
    echo "install openjdk-1.8.0 successfully."
  else
    java_version=$(java -version 2>&1 | sed '1!d' | sed -e 's/"//g' | awk '{print $3}'| cut -d_ -f1)
    if [[ $java_version != "1.8.0" ]];then
      echo "start upgrade java."
      rpm -qa | grep java | sudo xargs rpm -e --nodeps
      sudo yum update -y > /dev/null 2>&1
      sudo yum install -y java-1.8.0-openjdk > /dev/null 2>&1
      echo "install openjdk-1.8.0 successfully."
    else
      echo "The java version is openjdk-1.8.0 now."
    fi
  fi

  # install openssl
  if ! openssl version > /dev/null 2>&1;then
    sudo yum -y install openssl > /dev/null 2>&1
  fi
}

ssl_oneway_ca_generate(){
  if [ ! -d ${generate_root} ]; then
    mkdir -p ${generate_root}
  fi

  cd $generate_root
  echo "start create certificates..."
  sudo keytool -keystore server.keystore.jks -alias ${server_hostname} -validity 365 -genkey -keyalg RSA -dname "cn=${server_hostname}" -storepass ${pass} -keypass ${pass}
  sudo openssl req -nodes -new -x509 -keyout ca-root.key -out ca-root.crt -days 365 -subj "/C=US/ST=CA/L=Palo Alto/O=Confluent/CN=Confluent"
  echo ${pass} | sudo keytool -keystore server.keystore.jks -alias ${server_hostname} -certreq -file ${server_hostname}_server.csr
  sudo openssl x509 -req -CA ca-root.crt -CAkey ca-root.key -in ${server_hostname}_server.csr -out ${server_hostname}_server.crt -days 365 -CAcreateserial
  echo ${pass} | sudo keytool -keystore server.keystore.jks -alias CARoot -import -noprompt -file ca-root.crt
  echo ${pass} | sudo keytool -keystore server.keystore.jks -alias ${server_hostname} -import -file ${server_hostname}_server.crt
  echo -e "${pass}\n${pass}\ny" | sudo keytool -keystore server.truststore.jks -alias CARoot -import -file ca-root.crt

  if [ $? != 0 ]; then
    echo "failed to generate certificates."
    exit 1
  else
    echo "certificates generated successfully."
  fi
}

env_prepare
ssl_oneway_ca_generate ${server_hostname} ${generate_root} ${pass}