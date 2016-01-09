just copy from docker/computer except

in Dockerfile:
use cuda base:
from registry:5000/cuda
theano setup for gpu:
[global]\ndevice=gpu ...etc


in run.sh:
docker names:
`hostname`-gpu-app- etc.
and run cmd
registry:5000/computer-gpu