#!/bin/sh
# 'screen' this
to=${1:-init}
ssh ${to} /opt/bin/weave expose
ssh -q -L ${2}:localhost:${2} ${to}

