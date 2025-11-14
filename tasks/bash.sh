#!/usr/bin/env bash
docker run -p 8888:8888 --rm -it -v $(pwd):/host xeus-haskell bash
