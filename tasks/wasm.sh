#!/usr/bin/env bash
SRC_DIR=/tmp/xeus-haskell-src
BUILD_DIR=/work
CONTAINER_SCRIPT=$(cat <<EOS
set -euo pipefail

cp -a /host/. "$SRC_DIR"

micromamba run -n xeus-haskell-wasm-build bash -lc '
  set -euo pipefail
  unset CFLAGS CXXFLAGS LDFLAGS

  emcmake cmake \
    -S "$SRC_DIR" \
    -B "$BUILD_DIR" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="\$MAMBA_ROOT_PREFIX/envs/xeus-haskell-wasm-host" \
    -DCMAKE_PREFIX_PATH="\$MAMBA_ROOT_PREFIX/envs/xeus-haskell-wasm-host" \
    -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ON

  cmake --build "$BUILD_DIR"
  cmake --install "$BUILD_DIR"
  bash
'
EOS
)

docker run --rm -it \
  -p 8888:8888 \
  -v "$(pwd):/host" \
  --workdir /host \
  --entrypoint bash \
  xeus-haskell \
  -lc "$CONTAINER_SCRIPT"

