FROM pulsepointinc/centos7-java8

ENV KM_VERSION=b0fb7f28079755a085c6496b57a3dbe9d7991858

RUN \
  yum install -y git rpm-build && \
  git clone https://github.com/yahoo/kafka-manager /tmp/kafka-manager && \
  cd /tmp/kafka-manager && \
  git checkout ${KM_VERSION} && \
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
