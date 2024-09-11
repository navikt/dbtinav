import subprocess
import requests
import os
import time
import json
import sys
import logging
from pathlib import Path
import shlex


SECRET_NAME = "dbtinav_dbt"
DBT_PROSJEKT = "dbtinav"
DBT_BASE_COMMAND = ["dbt", "--no-use-colors", "--log-format", "json"]


def get_dbt_log(log_path) -> str:
    with open(log_path) as log:
        return log.read()


def set_secrets_as_envs():
    from google.cloud import secretmanager

    TEAM_GCP_PROJECT = os.environ["TEAM_GCP_PROJECT"]
    secrets = secretmanager.SecretManagerServiceClient()
    resource_name = f"projects/{TEAM_GCP_PROJECT}/secrets/{SECRET_NAME}/versions/latest"
    secret = secrets.access_secret_version(name=resource_name)
    secret_str = secret.payload.data.decode("UTF-8")
    secrets = json.loads(secret_str)
    os.environ.update(secrets)


def publish_docs():
    # Connection informasjon fo å pushe dbt docs
    dbt_docs_url = f'{os.environ["DBT_DOCS_URL"]}{DBT_PROSJEKT}'
    files = [
        "target/manifest.json",
        "target/catalog.json",
        "target/index.html",
    ]
    multipart_form_data = {}
    for file_path in files:
        file_name = os.path.basename(file_path)
        with open(file_path, "rb") as file:
            file_contents = file.read()
            multipart_form_data[file_name] = (file_name, file_contents)

    res = requests.put(dbt_docs_url, files=multipart_form_data)
    res.raise_for_status()


if __name__ == "__main__":
    set_secrets_as_envs()  # get secrets from gcp
    logger = logging.getLogger(__name__)
    log_path = Path(__file__).parent / "logs/dbt.log"

    stream_handler = logging.StreamHandler(sys.stdout)
    os.environ["TZ"] = "Europe/Oslo"
    time.tzset()

    schema = os.environ["DB_SCHEMA"]
    os.environ["DBT_ENV_SECRET_USER"] = f"{os.environ['DB_USER']}[{schema}]"
    os.environ["DBT_DB_SCHEMA"] = schema
    os.environ["DBT_DB_DSN"] = os.environ["DB_DSN"]
    os.environ["DBT_ENV_SECRET_PASS"] = os.environ["DB_PASSWORD"]
    logger.info("DBT miljøvariabler er lastet inn")

    # default dbt kommando er build
    command = shlex.split(os.getenv("DBT_COMMAND", "build"))
    dbt_models = os.getenv("DBT_MODELS", None)
    if dbt_models:
        command = command + ["--select", dbt_models]

    log_level = os.getenv("LOG_LEVEL", "INFO")
    logger.setLevel(log_level)
    logger.addHandler(stream_handler)

    try:
        subprocess.run(
            DBT_BASE_COMMAND + ["deps"],
            check=True,
            capture_output=True,
        )
        output = subprocess.run(
            (DBT_BASE_COMMAND + command),
            check=True,
            capture_output=True,
        )
        if "docs" in command:
            publish_docs()
        logger.info(output.stdout.decode("utf-8"))
        logger.debug(get_dbt_log(log_path))
    except subprocess.CalledProcessError as err:
        raise Exception(logger.error(get_dbt_log(log_path)), err.stdout.decode("utf-8"))
