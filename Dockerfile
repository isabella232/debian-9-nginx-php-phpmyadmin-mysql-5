FROM 1and1internet/debian-9-nginx-php-phpmyadmin:latest
ARG DEBIAN_FRONTEND=noninteractive

COPY files/ /

RUN \
  groupadd mysql && \
  useradd -g mysql mysql && \
  apt-get update && \
  apt-get install -y gettext-base pwgen python wget lsb-release libnuma1 libmecab2 libatomic1 libaio1 && \
  cd /tmp && \
  wget https://downloads.mysql.com/archives/get/p/23/file/mysql-server_5.7.33-1debian9_amd64.deb-bundle.tar && \
  tar xvf mysql-server_5.7.33-1debian9_amd64.deb-bundle.tar && \
  dpkg -i mysql-community-server_5.7.33-1debian9_amd64.deb  \
    mysql-community-client_5.7.33-1debian9_amd64.deb\
    mysql-common_5.7.33-1debian9_amd64.deb \
    mysql-client_5.7.33-1debian9_amd64.deb && \
  rm -rf /var/lib/apt/lists/* /var/lib/mysql /etc/mysql* /tmp/*.deb /tmp/*.tar && \
  mkdir --mode=0777 /var/lib/mysql /etc/mysql && \
  chmod 0777 /docker-entrypoint-initdb.d && \
  chmod -R 0775 /etc/mysql && \
  chmod -R 0755 /hooks && \
  chmod -R 0777 /var/log/mysql /var/run/mysqld && \
  cd /opt/configurability/src/mysql_config_translator && \
  curl https://bootstrap.pypa.io/pip/2.7/get-pip.py -o /tmp/get-pip.py && \
  python /tmp/get-pip.py && \
  pip --no-cache install --upgrade pip && \
  pip --no-cache install --upgrade .

ENV DISABLE_PHPMYADMIN=0 \
    PMA_ARBITRARY=0 \
    PMA_HOST=localhost \
    MYSQL_GENERAL_LOG=0 \
    MYSQL_QUERY_CACHE_TYPE=1 \
    MYSQL_QUERY_CACHE_SIZE=16M \
    MYSQL_QUERY_CACHE_LIMIT=1M

EXPOSE 3306 8080
VOLUME /var/lib/mysql/
