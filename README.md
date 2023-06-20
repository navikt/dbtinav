## Formål
Overordnet beskrivelse av formål med løsningen

### Komponentbeskrivelse
Formål: 
Prinsipper:
Kilde(r):
Brukere:
Noe annet:

## Struktur på repo
Lenke til dokumentasjon på confluence

Vi har følgende mapper:
- db (medfølgende readme)
  - install (her ligger ddl filer per tabell/view. Også dcl-filer som gir grants)
  - patch (hvert script har jira-kode som prefiks og kort forklaring/tabellnavn). Når man endrer en tabell her må man også endre den i install-filen)
  - utils (kanskje, hvis man trenger det)
- etl - om det finnes kodebasert etl for komponenten, legger man det inn under mappen etl. Der er det en mappe per task/mapping. Bør også inneholde readmes.




## Overordnet design
### Dataflyt-diagram

![Dataflyt](dataflyt-generisk.drawio.png)
Hvis man lagrer diagrammet som .drawio.png blir det redigerbart i [drawio](https://github.com/jgraph/drawio-desktop/releases/tag/v20.3.0)

| # | DAG | task | kilde | mål | kommentar |
|---|-----|------|-------|-----|-----------|
|   |     |      |       |     |           |
|   |     |      |       |     |           |
|   |     |      |       |     |           |

## Databasebeskrivelse

En oversikt over de viktigste tabellene

| Tabell/Views      | Beskrivelse |
| ----------- | ----------- |
| tabell1      | besk       |
| tabell2    | besk        |

### Databasescript
Referanser til hvor databasescriptene befinner seg

## Drift
### Workflows og kjøretidspunkt
Inneholder informasjon om viktige punkter for kjøretider

## Tilgangsstyring
Er det noen spesielle rettigheter som kreves for denne komponenten?

## Overvåking og datakvalitet

### Datakvalitet
Det kjøres datakvalitetsmålinger for disse tabellene

### Overvåking
Følgende Sitescope-monitorer kjøres for denne komponenten.

## Sikkerhet og personvern
Inneholder detaljer rundt f.eks tilgang

Det er ikke utarbeidet PVK for denne komponenten.

Håndtering av kode 6 og 7: Under arbeid

## Backlog
Lenke til jira-oversikt?


