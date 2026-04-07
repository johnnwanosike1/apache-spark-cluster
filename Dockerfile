# =============================================================================
# Apache Spark 3.5.8 + Gluten 1.6.0 (Velox backend)
# Scala 2.12 | Java 17 | Ubuntu 22.04
# =============================================================================

FROM spark:3.5.8-scala2.12-java17-python3-ubuntu

ARG GLUTEN_VERSION=1.6.0

ENV SPARK_VERSION=3.5.8
ENV GLUTEN_VERSION=${GLUTEN_VERSION}
ENV SPARK_LOG_DIR=/opt/spark/logs
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

USER root

# ---------------------------------------------------------------------------
# System tools
# ---------------------------------------------------------------------------
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------------------------
# Python packages
# ---------------------------------------------------------------------------
RUN pip3 install --no-cache-dir \
    pyspark==3.5.8 \
    jupyterlab \
    pandas \
    pyarrow \
    numpy \
    matplotlib \
    seaborn \
    delta-spark==3.3.1

# ---------------------------------------------------------------------------
# Iceberg + Delta JARs (Maven Central)
# ---------------------------------------------------------------------------
RUN curl -fsSL \
    "https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-3.5_2.12/1.5.2/iceberg-spark-runtime-3.5_2.12-1.5.2.jar" \
    -o "${SPARK_HOME}/jars/iceberg-spark-runtime-3.5_2.12-1.5.2.jar" \
 && curl -fsSL \
    "https://repo1.maven.org/maven2/io/delta/delta-spark_2.12/3.3.1/delta-spark_2.12-3.3.1.jar" \
    -o "${SPARK_HOME}/jars/delta-spark_2.12-3.3.1.jar" \
 && curl -fsSL \
    "https://repo1.maven.org/maven2/io/delta/delta-storage/3.3.1/delta-storage-3.3.1.jar" \
    -o "${SPARK_HOME}/jars/delta-storage-3.3.1.jar"

# ---------------------------------------------------------------------------
# Gluten/Velox JAR — official Apache binary release
# Source: https://dlcdn.apache.org/gluten/1.6.0/
# Tarball (~98 MB) contains the prebuilt gluten-velox-bundle JAR inside.
# ---------------------------------------------------------------------------
#RUN curl -fL \
#   "https://dlcdn.apache.org/gluten/${GLUTEN_VERSION}/apache-gluten-${GLUTEN_VERSION}-bin-spark-3.5.tar.gz" \
#    -o /tmp/gluten.tar.gz \
# && tar -xzf /tmp/gluten.tar.gz -C /tmp \                                     
# && find /tmp/apache-gluten-* -name "gluten-velox-bundle-spark3.5_2.12-linux_amd64-1.6.0.jar" | head -1 \
#    | xargs -I{} cp {} "${SPARK_HOME}/jars/gluten.jar" \
# && rm -rf /tmp/gluten.tar.gz /tmp/apache-gluten-* \
# && echo "Gluten JAR: $(du -sh ${SPARK_HOME}/jars/gluten.jar)"

RUN set -eux; \
    curl -fL "https://dlcdn.apache.org/gluten/${GLUTEN_VERSION}/apache-gluten-${GLUTEN_VERSION}-bin-spark-3.5.tar.gz" -o /tmp/gluten.tar.gz; \
    tar -xzf /tmp/gluten.tar.gz -C /tmp; \
    find /tmp -type f | grep 'gluten-velox-bundle' || true; \
    GLUTEN_JAR="$(find /tmp -type f -name 'gluten-velox-bundle-spark3.5_2.12-linux_amd64-1.6.0.jar' | head -1)"; \
    echo "FOUND=$GLUTEN_JAR"; \
    test -n "$GLUTEN_JAR"; \
    cp "$GLUTEN_JAR" "${SPARK_HOME}/jars/gluten.jar"; \
    ls -lah "${SPARK_HOME}/jars/gluten.jar"; \
    rm -rf /tmp/gluten.tar.gz

# ---------------------------------------------------------------------------
# Workspace + log directories
# ---------------------------------------------------------------------------
RUN mkdir -p /workspace/data /workspace/notebooks "${SPARK_LOG_DIR}"

# ---------------------------------------------------------------------------
# Config + entrypoint
# ---------------------------------------------------------------------------
COPY conf/spark-defaults.conf "${SPARK_HOME}/conf/spark-defaults.conf"
COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r//' /entrypoint.sh && chmod +x /entrypoint.sh

WORKDIR /workspace
EXPOSE 8080 7077 4040 8888 18080 8081
ENTRYPOINT ["/entrypoint.sh"]
