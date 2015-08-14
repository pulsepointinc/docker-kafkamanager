FROM centos:7

RUN yum install -y java-1.8.0-openjdk-headless && \
  yum clean all

ENV KM_VERSION=07e2494b1976106e02dea45ec58f523b5c97048d

RUN \
  yum install -y git rpm-build java-1.8.0-openjdk-devel && \
  git clone https://github.com/yahoo/kafka-manager /tmp/kafka-manager && \
  cd /tmp/kafka-manager && \
  git checkout ${KM_VERSION} && \
  ./sbt rpm:packageBin && \
  yum install -y target/rpm/RPMS/noarch/*.rpm && \
  yum autoremove -y git rpm-build java-1.8.0-openjdk-devel && \
  yum clean all && \
  rm -rf /root/.sbt /root/.ivy2 /tmp/*

EXPOSE 9000

VOLUME ["/usr/share/kafka-manager/conf"]

CMD ["/usr/bin/kafka-manager"]
