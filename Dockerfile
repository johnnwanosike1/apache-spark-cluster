# =============================================================================
# Apache Spark 4.1.1 — with optional Gluten/Velox acceleration
#
# Gluten compatibility note:
#   Gluten 1.4.x (latest stable) supports Spark 3.2–3.5 only.
#   Spark 4.x support is planned for Gluten 1.5 (not yet released as of Apr 2026).
#   When GLUTEN_ENABLED=true and a compatible JAR is absent, the entrypoint
#   falls back to vanilla Spark automatically — no crash, just a warning.
#
# Build args:
#   SPARK_VERSION   default: 4.1.1
#   GLUTEN_VERSION  default: 1.4.0  (used only if JAR naming matches spark version)
# =============================================================================

FROM ubuntu:22.04

ARG SPARK_VERSION=4.1.1
ARG GLUTEN_VERSION=1.4.0

ENV DEBIAN_FRONTEND=noninteractive
ENV SPARK_VERSION=${SPARK_VERSION}
ENV GLUTEN_VERSION=${GLUTEN_VERSION}
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV SPARK_HOME=/opt/spark
ENV SPARK_LOG_DIR=/opt/spark/logs
ENV PATH="${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${JAVA_HOME}/bin:${PATH}"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# ---------------------------------------------------------------------------
# System dependencies
# ---------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends \
    openjdk-21-jdk-headless \
    python3 \
    python3-pip \
    python3-dev \
    wget \
    curl \
    procps \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# Python packages
# ---------------------------------------------------------------------------
RUN pip3 install --no-cache-dir \
    pyspark==${SPARK_VERSION} \
    jupyterlab \
    pandas \
    pyarrow \
    numpy \
    matplotlib \
    seaborn \
    delta-spark==4.1.0

# ---------------------------------------------------------------------------
# Download Apache Spark 4.1.1 (Scala 2.13, Hadoop 3, Java 21)
# ---------------------------------------------------------------------------
RUN wget -q \
    "https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz" \
    -O /tmp/spark.tgz \
    && tar -xzf /tmp/spark.tgz -C /opt \
    && mv /opt/spark-${SPARK_VERSION}-bin-hadoop3 ${SPARK_HOME} \
    && rm /tmp/spark.tgz

# ---------------------------------------------------------------------------
# Iceberg + Delta JARs (pre-downloaded — no spark.jars.packages at runtime)
# ---------------------------------------------------------------------------
RUN wget -q \
    "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-4.0_2.13/1.10.1/iceberg-spark-runtime-4.0_2.13-1.10.1.jar" \
    -O ${SPARK_HOME}/jars/iceberg-spark-runtime-4.0_2.13-1.10.1.jar

RUN wget -q \
    "https://repo1.maven.org/maven2/io/delta/delta-spark_4.1_2.13/4.1.0/delta-spark_4.1_2.13-4.1.0.jar" \
    -O ${SPARK_HOME}/jars/delta-spark_4.1_2.13-4.1.0.jar \
    && wget -q \
    "https://repo1.maven.org/maven2/io/delta/delta-storage/4.1.0/delta-storage-4.1.0.jar" \
    -O ${SPARK_HOME}/jars/delta-storage-4.1.0.jar

# ---------------------------------------------------------------------------
# Gluten/Velox JAR — attempted download, graceful fallback if unavailable
#
# Gluten 1.4.0 targets Spark 3.5 / Scala 2.12.
# When Gluten 1.5 with Spark 4.x support is released, update:
#   GLUTEN_VERSION=1.5.x  and the JAR name to *spark4.1_2.13*
# ---------------------------------------------------------------------------
RUN wget -q \
    "https://github.com/apache/incubator-gluten/releases/download/v${GLUTEN_VERSION}/gluten-velox-bundle-spark3.5_2.12-ubuntu_22.04-${GLUTEN_VERSION}.jar" \
    -O ${SPARK_HOME}/jars/gluten.jar \
    && echo "Gluten JAR downloaded: ${SPARK_HOME}/jars/gluten.jar" \
    || echo "WARN: Gluten JAR download failed — cluster will run in vanilla mode only"

# ---------------------------------------------------------------------------
# Workspace directories
# ---------------------------------------------------------------------------
RUN mkdir -p /workspace/data /workspace/notebooks ${SPARK_LOG_DIR}

# ---------------------------------------------------------------------------
# Config + entrypoint
# ---------------------------------------------------------------------------
COPY conf/spark-defaults.conf ${SPARK_HOME}/conf/spark-defaults.conf
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /workspace

# Master UI, cluster port, Spark App UI, Jupyter, History Server
EXPOSE 8080 7077 4040 8888 18080 8081

ENTRYPOINT ["/entrypoint.sh"]
