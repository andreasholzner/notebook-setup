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

    bootstrap.pl


### Optionen ###

- `--dry-run`: Listet nur alle Operationen auf ohne sie tatsächlich durchzuführen.
- `--force`: Nur damit werden lokal geänderte Dateien mit dem Repositoryinhalt überschrieben.
- `--filter <FILTER_STRING>`: Nur Dateien, die <FILTER_STRING> enthalten, werden verarbeitet.
- `--show-diffs`: Zeigt alle Unterschiede zwischen den Dateien an, die kopiert werden würden.

### Beschreibung ###

- Konfigurationsdateien werden passend für den aktuellen Hostnamen kopiert (relativ zu `$HOME`)
- Perl5 Module werden aktuell noch nicht behandelt
- Alle anderen Dateien werden einfach nach `$HOME` kopiert


## Perl5 ##

Alle Verzeichnisse unter `perl5` enthalten Perl5-Pakete, die mit `Dist::Zilla` gebaut werden.

### Paketstruktur ###

-   `dist.ini`: Dist::Zilla Konfiguration für das Paket
-   `lib`: Enthält die Perlmodule

    Wird automatisch erzeugt, wenn das Paket erzeugt wird.

        dzil new My::Packet

-   `t`: Enthält die Tests
-   `bin`: Enthält ausführbare Dateien

### Bauen ###

Alle folgenden Befehle werden innerhalb des betroffenen Pakets ausgeführt.

- Tests ausführen

        dzil test

- Paket bauen (erzeugt ein `My-Packet-$VERSION.tar.gz`)

        dzil build

- aufräumen

        dzil clean

### Installieren ###

Ein so gebautes Paket lässt sich einfach mit `cpanm` installieren

    cpanm My-Packet-$VERSION.tag.gz

und mit

    cpanm --uninstall My::Packet

wieder deinstallieren.
