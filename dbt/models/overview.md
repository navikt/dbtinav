
{% docs __overview__ %}


<!--- Fyll inn innhold fra https://github.com/navikt/dvh_template/blob/amd_template/README.md --->



---

# dbt docs - brukerguide 

### Navigasjon
Du kan bruke navigasjonsfanene `Project` og `Database` på venstre side av vinduet for å utforske modellene i komponenten.

#### Prosjektfane
`Prosjekt`-fanen speiler katalogstrukturen til dbt-prosjektet ditt. I denne fanen kan du se alle
modeller definert i dbt-prosjektet ditt, samt modeller importert fra dbt-pakker.

#### Database-fanen
Fanen `Database` viser også modellene dine, men i et format som ser mer ut som en databaseutforsker. Denne utsikten
viser relasjoner (tabeller og visninger) gruppert i databaseskjemaer. Merk at `ephemeral` modeller _ikke_ vises
i dette grensesnittet, da de ikke finnes i databasen.

### Grafutforskning
Du kan klikke på det blå ikonet nederst til høyre på siden for å se lineage til modellene dine.

På modellsidene vil du se de nærmeste foreldrene og barna til modellen du utforsker. Ved å klikke på `Expand`.
knappen øverst til høyre i denne avstamningsruten, vil du kunne se alle modellene som brukes til å bygge,
eller er bygget fra, modellen du utforsker.

Når den er utvidet, vil du kunne bruke `--select` og `--exclude` modellvalgsyntaks for å filtrere
modeller i grafen. For mer informasjon om modellvalg, sjekk ut [dbt docs](https://docs.getdbt.com/docs/model-selection-syntax).

Merk at du også kan høyreklikke på modeller for å filtrere og utforske grafen interaktivt.


### Mer info

- [Hva er dbt](https://docs.getdbt.com/docs/introduction)


---

{% enddocs %}