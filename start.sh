#!/bin/bash

APPLICATION_CONF=${APPLICATION_CONF:-/usr/share/kafka-manager/conf/application.conf}
echo "Using application conf ${APPLICATION_CONF}" >&2

# You can optionally enable/disable the following functionality by modifying the default list in application.conf :
# application.features=["KMClusterManagerFeature","KMTopicManagerFeature","KMPreferredReplicaElectionFeature","KMReassignPartitionsFeature"]
# * KMClusterManagerFeature - allows adding, updating, deleting cluster from Kafka Manager
# * KMTopicManagerFeature - allows adding, updating, deleting topic from a Kafka cluster
# * KMPreferredReplicaElectionFeature - allows running of preferred replica election for a Kafka cluster
# * KMReassignPartitionsFeature - allows generating partition assignments and reassigning partitions
APPLICATION_FEATURES=${APPLICATION_FEATURES-'"KMClusterManagerFeature","KMTopicManagerFeature","KMPreferredReplicaElectionFeature","KMReassignPartitionsFeature"'}
echo "Setting application features to [${APPLICATION_FEATURES}]" >&2
sed -i "" -e "s/^application.features=.*$/application.features=[${APPLICATION_FEATURES}]/" ${APPLICATION_CONF}

# kafka-manager.broker-view-thread-pool-size=< 3 * number_of_brokers>
[ -z "${THREAD_POOL_SIZE}" ] || {
  echo "Setting thread pool size to ${THREAD_POOL_SIZE}" >&2
  echo "kafka-manager.broker-view-thread-pool-size=${THREAD_POOL_SIZE}" >> ${APPLICATION_CONF}
}

# kafka-manager.broker-view-max-queue-size=< 3 * total # of partitions across all topics>
[ -z "${MAX_QUEUE_SIZE}" ] || {
  echo "Setting max queue size to ${MAX_QUEUE_SIZE}" >&2
  echo "kafka-manager.broker-view-max-queue-size=${MAX_QUEUE_SIZE}" >> ${APPLICATION_CONF}
}

# kafka-manager.broker-view-update-seconds=< kafka-manager.broker-view-max-queue-size / (10 * number_of_brokers) >
[ -z "${UPDATE_SECONDS}" ] || {
  echo "Setting update seconds to ${UPDATE_SECONDS}" >&2
  echo "kafka-manager.broker-view-update-seconds=${UPDATE_SECONDS}" >> ${APPLICATION_CONF}
}

exec /usr/bin/kafka-manager -Dconfig.file=${APPLICATION_CONF}
