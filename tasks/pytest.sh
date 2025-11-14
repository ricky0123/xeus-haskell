#!/usr/bin/env bash
docker run --rm -i -v $(pwd):/host xeus-haskell pytest
