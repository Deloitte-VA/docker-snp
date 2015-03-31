FROM debian:wheezy
MAINTAINER Justin Grant <jlgrock@gmail.com> "http://www.justinleegrant.com"

# Update apt-get and install add-apt-repository
RUN apt-get update -qqy && \
	apt-get install -qqy \
  software-properties-common \
  python-software-properties \
  libgtk-3-dev \
  wget \
  curl \
  zip \
  unzip \
  nano


# Install Java.
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  sed -i 's/wheezy/trusty/g' /etc/apt/sources.list.d/webupd8team-java-wheezy.list && \
  apt-get update -qqy && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer


# see https://www.apache.org/dist/tomcat/tomcat-8/KEYS
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys \
  05AB33110949707C93A279E3D3EFE6B686867BA6 \
  07E48665A34DCAFAE522E5E6266191C37C037D42 \
  47309207D818FFD8DCD3F83F1931D684307A10A5 \
  541FBE7D8F78B25E055DDEE13C370389288584E7 \
  61B832AC2F1C5A90F0F9B00A1C506407564C17A3 \
  79F7026C690BAA50B92CD8B66A3AD3F4F22C4FED \
  9BA44C2621385CB966EBA586F72C284D731FABEE \
  A27677289986DB50844682F8ACB77FC2E86E29AC \
  A9C5DF4D22E99998D9875A5110C01C5A2F6059E7 \
  DCFD35E0BF8CA7344752DE8B6FB21E8933C60243 \
  F3A04C595DB5B6A5F1ECA43E3B7BBB100D811BBE \
  F7DA48BB64BCB84ECBA7EE6935CD23C10D498E23

# Define versions
ENV TOMCAT_MAJOR 8
ENV TOMCAT_VERSION 8.0.20
ENV WAR_VERSION 0.1
ENV SOLOR_GOODS_VERSION 1.2

# Define commonly used JAVA_HOME variable
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV TOMCAT_TGZ_URL https://www.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz
WORKDIR $CATALINA_HOME

# Define working directory.
RUN mkdir -p "$CATALINA_HOME"

# install tomcat
RUN curl -SL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
  && curl -SL "$TOMCAT_TGZ_URL.asc" -o tomcat.tar.gz.asc \
  && gpg --verify tomcat.tar.gz.asc \
  && tar -xvf tomcat.tar.gz --strip-components=1 \
  && rm bin/*.bat \
  && rm tomcat.tar.gz*

ADD application.properties $CATALINA_HOME/lib/config.properties
ADD log4j.properties $CATALINA_HOME/lib/log4j.properties
ADD tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml

# Used for releases (comment out for development)
RUN mkdir -p /data/uploads /data/object-chronicles /data/search
ADD snpweb.war $CATALINA_HOME/webapps/snpweb.war
# ADD lucene.zip /data/lucene.zip
# ADD cradle.zip /data/cradle.zip
# RUN unzip /data/cradle.zip -d /data/ && unzip /data/lucene.zip -d /data/

ADD docker-entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8080
CMD ["catalina.sh", "run"]
