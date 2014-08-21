#!/bin/bash
urxvt -pe "-digital-clock,-searchable-scrollback,-selection-popup,-option-popup" +sb -name "Ausführen" -title "Ausführen" -geometry 80x1+500+10 --keysym.0xFF0D " & exit\n" -e bash --init-file $HOME/.fvwm/run-bash-init
