30 6 * * * $HOME/scripts/psc.pl >> $HOME/scripts/logs/psc.log 2>&1
00 09 1-7 * * $HOME/scripts/prod217.sh  >> $HOME/scripts/logs/prod217.log 2>&1
00 10 1-10 * * $HOME/scripts/prod224.sh >> $HOME/scripts/logs/prod224.log 2>&1
45 7 * * * $HOME/scripts/prod223.sh >> $HOME/scripts/logs/prod223.log 2>&1