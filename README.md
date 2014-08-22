notebook-setup
==============

## Struktur ##

-   `config`: Konfigurationsdateien
    - `common`: für alle Rechner
    - `$hostname`: spezifisch für Rechner mit `hostname = $hostname`
-   `perl5`: Perl5 Module (müssen aktuell eigenständig installiert werden)
-   `*`: Alle anderen Verzeichnisse haben keine spezielle Bedeutung und werden einfach kopiert.

## Benutzung ##

Einfach das Skript `bootstrap.pl` aufrufen,

    bootstrap.pl --source-directory=<DIR>

wobei `<DIR>` die Arbeitskopie des notebook-setup Repositories sein muss.

### Optionen ###

- `--dry-run`: Listet nur alle Operationen auf ohne sie tatsächlich durchzuführen
- `--force`: Nur damit werden lokal geänderte Dateien mit dem Repositoryinhalt überschrieben

### Beschreibung ###

- Konfigurationsdateien werden passend für den aktuellen Hostnamen kopiert (relativ zu `$HOME`)
- Perl5 Module werden aktuell noch nicht behandelt
- Alle anderen Dateien werden einfach nach `$HOME` kopiert
