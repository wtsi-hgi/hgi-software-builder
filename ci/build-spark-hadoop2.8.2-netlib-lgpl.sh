#!/bin/bash

set -euf -o pipefail

if [[ ! ${!SPARK_VERSION[@]} ]]; then
  >&2 echo "SPARK_VERSION must be set"
  exit 1
fi

if [[ ! ${!BUILD_ARTIFACT[@]} ]]; then
  >&2 echo "BUILD_ARTIFACT must be set"
  exit 1
fi

spark_source_url_template="https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=spark/spark-{{ SPARK_VERSION }}/spark-{{ SPARK_VERSION }}.tgz"
echo "Generating source url for version ${SPARK_VERSION} from template ${spark_source_url_template}"
spark_source_url=$(j2 <(echo "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=spark/spark-{{ SPARK_VERSION }}/spark-{{ SPARK_VERSION }}.tgz"))

spark_tgz=$(basename "${spark_source_url}")
echo "Downloading spark source from ${spark_source_url} to ${spark_tgz}"
curl -L "${spark_source_url}" > "${spark_tgz}"

spark_srcdir=$(basename ${spark_tgz} .tgz)
echo "Expanding ${spark_tgz} into ${spark_srcdir} using tbd"
tbd "${spark_tgz}"

echo "Changing to ${spark_srcdir}"
cd "${spark_srcdir}"

echo "Building spark"
export R_HOME=/usr/lib/R
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export AMPLAB_JENKINS=1 # silence curl/wget progress output
export MAVEN_OPTS="-Dorg.slf4j.simpleLogger.log.org.apache.maven.cl‌​i.transfer.Slf4jMave‌​nTransferListener=wa‌​rn"
./dev/make-distribution.sh \
    --name hadoop2.8.2-netlib-lgpl \
    --tgz \
    -B \
    -Phadoop-2.7 \
    -Psparkr \
    -Phive \
    -Phive-thriftserver \
    -Pyarn \
    -Pmesos \
    -DzincPort=3036 \
    -Pnetlib-lgpl \
    -Dhadoop.version=2.8.2

echo "copying spark-${SPARK_VERSION}-bin-hadoop2.8.2-netlib-lgpl.tgz to ${BUILD_ARTIFACT}"
cp "spark-${SPARK_VERSION}-bin-hadoop2.8.2-netlib-lgpl.tgz" "${CI_PROJECT_DIR}/${BUILD_ARTIFACT}"
