FROM gibdfrcu/base:latest

MAINTAINER Ramiro Rivera <ramarivera@gmail.com>

ENV ZOOKEEPER_VERSION=3.4.6 \
	ZK_HOME=/opt/zookeeper-${ZOOKEEPER_VERSION}

COPY start-zk.sh /usr/bin

RUN wget -q http://mirror.vorboss.net/apache/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz && \
	wget -q https://www.apache.org/dist/zookeeper/KEYS && \
	wget -q https://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz.asc && \
	wget -q https://www.apache.org/dist/zookeeper/zookeeper-${ZOOKEEPER_VERSION}/zookeeper-${ZOOKEEPER_VERSION}.tar.gz.md5

RUN md5sum -c zookeeper-${ZOOKEEPER_VERSION}.tar.gz.md5 && \
	gpg --import KEYS && \
	gpg --verify zookeeper-${ZOOKEEPER_VERSION}.tar.gz.asc && \
	tar -xzf zookeeper-${ZOOKEEPER_VERSION}.tar.gz -C /opt && \
	mv /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo_sample.cfg /opt/zookeeper-${ZOOKEEPER_VERSION}/conf/zoo.cfg && \
	sed  -i "s|/tmp/zookeeper|$ZK_HOME/data|g" $ZK_HOME/conf/zoo.cfg; mkdir $ZK_HOME/data && \
	chmod +x /usr/bin/start-zk.sh

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper-${ZOOKEEPER_VERSION}

VOLUME ["/opt/zookeeper-${ZOOKEEPER_VERSION}/conf", "/opt/zookeeper-${ZOOKEEPER_VERSION}/data"]

CMD ["usr/bin/start-zk.sh"]
