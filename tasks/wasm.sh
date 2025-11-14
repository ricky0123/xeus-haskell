#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(pwd)"

docker run --rm -i \
  -v "${ROOT_DIR}:/host" \
  --workdir /host \
  --entrypoint bash \
  xeus-haskell \
  -lc '
    set -euo pipefail

    SRC_DIR=/tmp/xeus-haskell-src
    BUILD_DIR=/tmp/xeus-haskell-wasm-build

    rm -rf "${SRC_DIR}"
    rm -rf "${BUILD_DIR}"
    mkdir -p "${SRC_DIR}"
    mkdir -p "${BUILD_DIR}"

    cp -a /host/. "${SRC_DIR}"

    export EMPACK_PREFIX="${MAMBA_ROOT_PREFIX}/envs/xeus-haskell-wasm-build"
    export PREFIX="${MAMBA_ROOT_PREFIX}/envs/xeus-haskell-wasm-host"
    export CMAKE_PREFIX_PATH="${PREFIX}"
    export CMAKE_SYSTEM_PREFIX_PATH="${PREFIX}"
    unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS

    JOBS=$(nproc)

    micromamba run -n xeus-haskell-wasm-build bash -lc "set -euo pipefail; unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS; \
      emcmake cmake \
        -S \"${SRC_DIR}\" \
        -B \"${BUILD_DIR}\" \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_PREFIX_PATH=\"${PREFIX}\" \
        -DCMAKE_INSTALL_PREFIX=\"${PREFIX}\" \
        -DCMAKE_FIND_ROOT_PATH_MODE_PACKAGE=ON"

    micromamba run -n xeus-haskell-wasm-build bash -lc "set -euo pipefail; unset CFLAGS CXXFLAGS CPPFLAGS LDFLAGS; \
      cmake --build \"${BUILD_DIR}\" -j\"${JOBS}\""
  '
