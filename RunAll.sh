#!/bin/bash

./VMreconcileWL.pl
./VMreconcileTARDIS.pl
./VMreconcileOrchard.pl
./VMreconcileRain.pl
./ovm_parse2.pl
./BaculaUpdate.pl
./PalUpdate.pl
./KspliceUpdate.pl
