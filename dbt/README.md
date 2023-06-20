## Nytt dbt prosjekt

### Utvikling
Lag gjerne et virtuelt python enviroment inne i dbt mappa. (Pass på å legge den til .gitignore)

```python -m venv .dbtenv```

Aktiver (i Powershell):

``.\.dbtenv\Scripts\activate.ps1``

Installer pakker for utvikling med pip.
(Ta en titt i requirements.txt for pakker og versjoner)

``pip install -r requirements.txt``



### Oppsett
- Gi navn til prosjektet i dbt_project.yml
- Opprett en profil i profiles.yml og referer til profilen i dbt_project.yml


For å kjøre dbt prosjektet fra utviklerimage må dbt ha tilgang til secrets for:
- miljø
- komponentskjema
- personlig brukernavn
- personlig passord

Disse secretene settes opp med skriptet `setup_db_user.ps1`, som setter dem som miljøvariabler. Skriptet kjøres fra kommandolinjen og den må kjøres fra dbt folderen fordi skritet også setter pathen for profiles.yml filen.

Eksempel på kjøring:

 ```PS C:\datavarehus\dvh_arb_cv\dbt> ./setup_db_user.ps1```

### Schedulering

dbt_run.py er et skript for schedulere dbt prosjektet i Airflow. Denne filen må endres til å passe sammen med secrets håndteringen til teamet.

### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](https://community.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
