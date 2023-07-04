## dbt pakke for NAV

Dette repoet inneholder et dbt prosjekt som kan brukes som en pakke i prosjektene.

Pakken kan importes i prosjektet ditt gjennom filen ```packages.yml``` slik:

    packages:
      - package: dbt-labs/dbt_utils
        version: 1.1.1
      - git: "https://github.com/navikt/dbtinav.git" # git URL
        revision: 0.0.3

Her refererer revision til en bestemt tag i dette repoet.


Foreløpig er det implementert en macro for å importere kildertabeller fra Oracle med tabell og kolonnebeskrivelser.

Makroen heter `generate_source_yaml` og kan brukes slik i en sql fil i `analyses` mappen i prosjektet ditt:

    {{ dbtinav.generate_source_yaml(schema_name = 'dt_kodeverk', generate_columns='true', include_descriptions='true', table_names = ['dim_alder', 'dim_geografi']) }}

- ``schema_name`` er navnet på komponentskjemaet tabellen ligger
- `generate_columns` settes til true hvis du ønkser å importere kolonner og ikke bare selve tabellen.
- `include_descriptions` settes til true dersom du ønsker å importere kommentarer på tabell og kolonne i tillegg til navn.
- `table_names` er en liste med tabeller du ønkser å importere.
