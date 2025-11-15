#!/usr/bin/env bash
export PREFIX=$MAMBA_ROOT_PREFIX/envs/xeus-haskell-wasm-host
micromamba run -n xeus-haskell-wasm-build \
  jupyter lite build --XeusAddon.prefix=$PREFIX --XeusAddon.mounts=/work/microhs/src/MicroHsProject:/work/microhs/src/MicroHsProject
