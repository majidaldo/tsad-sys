#!/bin/sh
# 'screen' this
to=${1:-init}
ssh ${to} /opt/bin/weave expose
ssh -q -D 1080 ${to}

