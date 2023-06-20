import subprocess
import os
import time
import json
import sys
from google.cloud import secretmanager

if __name__ == "__main__":
    team_gcp_project = os.environ["TEAM_GCP_PROJECT"]
    secret_name = <INSERT SECRET-NAME>
    os.environ["TZ"] = "Europe/Oslo"
    time.tzset()
    secrets = secretmanager.SecretManagerServiceClient()
    secret = secrets.access_secret_version(
        name=f'projects/{team_gcp_project}/secrets/{secret_name}/versions/latest')
    dbt_secrets = json.loads(secret.payload.data.decode('UTF-8'))
    os.environ["DBT_DB_SCHEMA"] = dbt_secrets['SCHEMA']
    os.environ["DBT_ENV_SECRET_USER"] = dbt_secrets['SERVICE_USER']
    os.environ["DBT_ENV_SECRET_PASS"] = dbt_secrets['PASSWORD']

    try:
        subprocess.run(
            ["dbt", "deps", "--profiles-dir", sys.path[0], "--project-dir", sys.path[0]],
            check=True, capture_output=True
        )
        subprocess.run(
            ["dbt", "run", "--profiles-dir", sys.path[0], "--project-dir", sys.path[0]], 
            check=True, capture_output=True
        )
    except subprocess.CalledProcessError as err:
        raise Exception(err.stdout.decode("utf-8"))

