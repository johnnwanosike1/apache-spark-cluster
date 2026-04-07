#!/bin/bash
# =============================================================================
# Spark cluster entrypoint — Spark 3.5.8 + Gluten 1.6.0
# =============================================================================
set -e

ROLE="${SPARK_ROLE:-worker}"
GLUTEN_JAR="${SPARK_HOME}/jars/gluten.jar"
SPARK_CONF="${SPARK_HOME}/conf/spark-defaults.conf"

unset SPARK_SUBMIT_OPTS
unset SPARK_JAVA_OPTS

configure_gluten() {
    if [ "${GLUTEN_ENABLED:-false}" != "true" ]; then
        echo "[entrypoint] Vanilla Spark mode."
        return
    fi

    # Verify JAR exists AND is non-empty
    if [ ! -f "${GLUTEN_JAR}" ]; then
        echo "[entrypoint] ERROR: GLUTEN_ENABLED=true but JAR missing: ${GLUTEN_JAR}"
        echo "[entrypoint] Falling back to vanilla mode."
        return
    fi

    JAR_SIZE=$(stat -c%s "${GLUTEN_JAR}" 2>/dev/null || echo 0)
    if [ "${JAR_SIZE}" -lt 1000000 ]; then
        echo "[entrypoint] ERROR: Gluten JAR is too small (${JAR_SIZE} bytes) — download failed."
        echo "[entrypoint] Fix: rebuild image with: docker compose build --no-cache"
        echo "[entrypoint] Falling back to vanilla mode."
        return
    fi

    echo "[entrypoint] Gluten/Velox ENABLED — JAR: ${JAR_SIZE} bytes"

    cat >> "${SPARK_CONF}" << GLUTEN_CONF

# Gluten/Velox — written by entrypoint.sh (GLUTEN_ENABLED=true)
spark.plugins                                    org.apache.gluten.GlutenPlugin
spark.gluten.sql.columnar.backend.lib            velox
spark.shuffle.manager                            org.apache.spark.shuffle.sort.ColumnarShuffleManager
spark.memory.offHeap.enabled                     true
spark.memory.offHeap.size                        1g
spark.gluten.sql.columnar.forceShuffledHashJoin  true
GLUTEN_CONF

    echo "[entrypoint] Gluten config written."
}

mkdir -p "${SPARK_LOG_DIR:-/opt/spark/logs}"
echo "[entrypoint] Role=${ROLE} | SPARK_VERSION=${SPARK_VERSION} | GLUTEN_ENABLED=${GLUTEN_ENABLED:-false}"
configure_gluten

case "${ROLE}" in
    master)
        exec "${SPARK_HOME}/bin/spark-class" org.apache.spark.deploy.master.Master \
            --host spark-master --port 7077 --webui-port 8080
        ;;
    worker)
        exec "${SPARK_HOME}/bin/spark-class" org.apache.spark.deploy.worker.Worker \
            spark://spark-master:7077 \
            --cores "${SPARK_WORKER_CORES:-2}" \
            --memory "${SPARK_WORKER_MEMORY:-2g}" \
            --webui-port "${SPARK_WORKER_WEBUI_PORT:-8081}"
        ;;
    notebook)
        exec jupyter lab \
            --ip=0.0.0.0 --port=8888 --no-browser --allow-root \
            --ServerApp.token="${JUPYTER_TOKEN:-spark}" \
            --ServerApp.password="" \
            --notebook-dir=/workspace/notebooks
        ;;
    history)
        exec "${SPARK_HOME}/bin/spark-class" \
            org.apache.spark.deploy.history.HistoryServer
        ;;
    *)
        exec "$@"
        ;;
esac
