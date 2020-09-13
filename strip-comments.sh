#! /usr/bin/env bash

sed -e 's/ .*//g' -e '/#.*/d' packages.txt > out.txt