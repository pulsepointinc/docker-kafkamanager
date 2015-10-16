# docker image for [kafka-manager](https://github.com/yahoo/kafka-manager)

Publish kafka-manager's default web port ( 9000 ) and set ZK_HOSTS env. Note this is not the ZK connection for your kafka cluster's brokers! It is used for kafka-manager's own metadata.

    docker run -d \
    -p 9000:9000 \
    -e "ZK_HOSTS=zk1:2181,zk2:2181,zk3:2181/chroot/kafka-manager" \
    pulsepointinc/kafka-manager
    
A modified configuration file with all optional features disabled has been added to the image. To use this version, or any custom version, set the config.file system property.

    docker run -d \
    -p 9000:9000 \
    -e "ZK_HOSTS=zk1:2181,zk2:2181,zk3:2181/chroot/kafka-manager" \
    pulsepointinc/kafka-manager \
    /usr/bin/kafka-manager \
    -Dconfig.file=/usr/share/kafka-manager/conf/application-features-disabled.conf 