#!/bin/bash

#for elasticsearch
sudo sysctl -w vm.max_map_count=524288

sh ./stopall.sh

#connect as www
sh ./connect.sh
