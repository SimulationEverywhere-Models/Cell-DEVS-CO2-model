#!bin/bash
mkdir results
./cd++ -m"roomco2.ma" -l"results/roomco2.log" -t00:03:00:000
cp results/roomco2.log01 ./roomco2.1.log
rm -r results

