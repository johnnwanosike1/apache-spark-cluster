#!/bin/bash
# =============================================================================
# Spark cluster entrypoint
# Roles: master | worker | notebook | history
#
# Gluten/Velox toggle:
#   Set GLUTEN_ENABLED=true  in docker-compose to enable native acceleration.
#   If the Gluten JAR is absent the script falls back to vanilla automatically.
# =============================================================================
set -e

ROLE=${SPARK_ROLE:-worker}
GLUTEN_JAR=${SPARK_HOME}/jars/gluten.jar

# ---------------------------------------------------------------------------
# Gluten configuration — injected only when JAR is present
# ---------------------------------------------------------------------------
configure_gluten() {
    if [ "${GLUTEN_ENABLED:-false}" = "true" ]; then
        if [ -f "${GLUTEN_JAR}" ]; then
            echo "[entrypoint] Gluten/Velox mode ENABLED (JAR: ${GLUTEN_JAR})"
            export SPARK_SUBMIT_OPTS="${SPARK_SUBMIT_OPTS} \
                --conf spark.plugins=org.apache.gluten.GlutenPlugin \
                --conf spark.gluten.sql.columnar.backend.lib=velox \
                --conf spark.shuffle.manager=org.apache.spark.shuffle.sort.ColumnarShuffleManager \
                --conf spark.sql.execution.arrow.pyspark.enabled=true \
                --conf spark.memory.offHeap.enabled=true \
                --conf spark.memory.offHeap.size=1g \
                --conf spark.gluten.sql.columnar.forceShuffledHashJoin=true \
                --conf spark.executor.extraClassPath=${GLUTEN_JAR} \
                --conf spark.driver.extraClassPath=${GLUTEN_JAR}"
            # NOTE: Gluten 1.4.x targets Spark 3.5 / Scala 2.12.
            # Spark 4.x (Scala 2.13) support is expected in Gluten 1.5.
            # The above config may cause fallback to JVM operators on Spark 4.x —
            # this is expected and safe. Check the plan for 'Velox' prefix operators.
            echo "[entrypoint] NOTE: Gluten 1.4.x targets Spark 3.5. On Spark 4.x some"
            echo "[entrypoint]       operators may fall back to JVM. Check plan for 'Velox' prefix."
        else
            echo "[entrypoint] WARN: GLUTEN_ENABLED=true but JAR not found at ${GLUTEN_JAR}"
            echo "[entrypoint]       Falling back to vanilla Spark mode."
        fi
    else
        echo "[entrypoint] Vanilla Spark mode"
    fi
}

mkdir -p "${SPARK_LOG_DIR:-/opt/spark/logs}"
configure_gluten

# ---------------------------------------------------------------------------
# Role dispatch
# ---------------------------------------------------------------------------
case "${ROLE}" in

    master)
        echo "[entrypoint] Starting Spark master (port 7077, UI 8080)..."
        exec ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.master.Master \
            --host spark-master \
            --port 7077 \
            --webui-port 8080
        ;;

    worker)
        echo "[entrypoint] Starting Spark worker → spark://spark-master:7077"
        exec ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.worker.Worker \
            spark://spark-master:7077 \
            --cores "${SPARK_WORKER_CORES:-2}" \
            --memory "${SPARK_WORKER_MEMORY:-2g}" \
            --webui-port "${SPARK_WORKER_WEBUI_PORT:-8081}"
        ;;

    notebook)
        echo "[entrypoint] Starting JupyterLab (port 8888)..."
        exec jupyter lab \
            --ip=0.0.0.0 \
            --port=8888 \
            --no-browser \
            --allow-root \
            --ServerApp.token="${JUPYTER_TOKEN:-spark}" \
            --ServerApp.password="" \
            --notebook-dir=/workspace/notebooks
        ;;

    history)
        echo "[entrypoint] Starting Spark History Server (port 18080)..."
        exec ${SPARK_HOME}/bin/spark-class \
            org.apache.spark.deploy.history.HistoryServer
        ;;

    *)
        echo "[entrypoint] Unknown role '${ROLE}'. Executing: $@"
        exec "$@"
        ;;
esac
