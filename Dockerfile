FROM pulsepointinc/centos7-java8

ENV KM_RELEASE=1.3.0.4

RUN \
  yum install -y git rpm-build && \
  git clone -b "${KM_RELEASE}" https://github.com/yahoo/kafka-manager /tmp/kafka-manager && \
  cd /tmp/kafka-manager && \
  echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
  ./sbt rpm:packageBin && \
  yum install -y target/rpm/RPMS/noarch/*.rpm && \
  yum autoremove -y git rpm-build && \
  yum clean all && \
  rm -rf /root/.sbt /root/.ivy2 /tmp/*

COPY start.sh /start.sh

EXPOSE 9000

CMD ["/start.sh"]
