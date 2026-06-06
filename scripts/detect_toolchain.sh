#!/bin/sh
set -eu

# detect_toolchain.sh
# Detect toolchain SDK include directory (containing hi_type.h) and cross-gcc path.
# Writes TOOLCHAIN_SDK_INCLUDE and TOOLCHAIN_GCC to:
#  - $GITHUB_ENV (if present in Actions) so make can pick it up
#  - ./toolchain_env file for local inspection

echo "detect_toolchain: starting" >&2
TOOLCHAIN_SDK_INCLUDE=""
TOOLCHAIN_GCC=""

# Check common explicit locations first
candidates="../per-package/*/host/sdk/include/hi_type.h output/per-package/*/host/sdk/include/hi_type.h ../host/sdk/include/hi_type.h output/host/sdk/include/hi_type.h output/staging/usr/include/hi_type.h"
for p in $candidates; do
  for f in $p; do
    [ -e "$f" ] || continue
    if [ -f "$f" ]; then
      TOOLCHAIN_SDK_INCLUDE=$(dirname "$f")
      break 2
    fi
  done
done

# Try a find fallback if not found
if [ -z "$TOOLCHAIN_SDK_INCLUDE" ]; then
  f=$(find output -maxdepth 6 -type f -name 'hi_type.h' -print -quit 2>/dev/null || true)
  if [ -n "$f" ]; then
    TOOLCHAIN_SDK_INCLUDE=$(dirname "$f")
  fi
fi

# Locate cross gcc
for g in output/per-package/*/host/bin/*-gcc output/host/*/bin/*-gcc output/host/*/host/bin/*-gcc; do
  if [ -x "$g" ]; then
    TOOLCHAIN_GCC=$(readlink -f "$g")
    break
  fi
done
if [ -z "$TOOLCHAIN_GCC" ]; then
  g=$(find output -type f -name '*-gcc' -executable -print -quit 2>/dev/null || true)
  if [ -n "$g" ]; then
    TOOLCHAIN_GCC=$(readlink -f "$g")
  fi
fi

# Write results
rm -f toolchain_env
if [ -n "$TOOLCHAIN_SDK_INCLUDE" ]; then
  echo "TOOLCHAIN_SDK_INCLUDE=$TOOLCHAIN_SDK_INCLUDE" >> toolchain_env
  echo "Found TOOLCHAIN_SDK_INCLUDE=$TOOLCHAIN_SDK_INCLUDE" >&2
  if [ "${GITHUB_ENV:-}" != "" ]; then
    echo "TOOLCHAIN_SDK_INCLUDE=$TOOLCHAIN_SDK_INCLUDE" >> "$GITHUB_ENV"
  fi
else
  echo "TOOLCHAIN_SDK_INCLUDE not found" >&2
fi

if [ -n "$TOOLCHAIN_GCC" ]; then
  echo "TOOLCHAIN_GCC=$TOOLCHAIN_GCC" >> toolchain_env
  echo "Found TOOLCHAIN_GCC=$TOOLCHAIN_GCC" >&2
  if [ "${GITHUB_ENV:-}" != "" ]; then
    echo "TOOLCHAIN_GCC=$TOOLCHAIN_GCC" >> "$GITHUB_ENV"
  fi
else
  echo "TOOLCHAIN_GCC not found" >&2
fi

echo "detect_toolchain: done" >&2
