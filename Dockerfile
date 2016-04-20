FROM pulsepointinc/centos7-java8

ENV KM_VERSION=6e196ea7a332471bead747535f9676f0a2bad008

RUN \
  yum install -y git rpm-build && \
  git clone https://github.com/yahoo/kafka-manager /tmp/kafka-manager && \
  cd /tmp/kafka-manager && \
  git checkout ${KM_VERSION} && \
  echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
  ./sbt rpm:packageBin && \
  yum install -y target/rpm/RPMS/noarch/*.rpm && \
  yum autoremove -y git rpm-build && \
  yum clean all && \
  rm -rf /root/.sbt /root/.ivy2 /tmp/*

RUN \
  sed -e 's/^application.features=.*$/application.features=[]/' \
    /usr/share/kafka-manager/conf/application.conf > \
    /usr/share/kafka-manager/conf/application-features-disabled.conf

EXPOSE 9000

VOLUME ["/usr/share/kafka-manager/conf"]

CMD ["/usr/bin/kafka-manager"]
