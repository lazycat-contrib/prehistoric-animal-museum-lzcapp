#!/usr/bin/env bash
set -euo pipefail

project_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
upstream_dir="$(mktemp -d)"
source_dir="${UPSTREAM_SOURCE_DIR:-}"

cleanup() {
  rm -rf "${upstream_dir}"
}
trap cleanup EXIT

if [[ -z "${source_dir}" ]]; then
  upstream_sha="$(
    git ls-remote https://github.com/s010s/prehistoric-animal-museum.git \
      refs/heads/main | awk '{print $1}'
  )"
  test -n "${upstream_sha}"

  source_dir="${upstream_dir}/source"
  mkdir -p "${source_dir}"
  curl --fail --location --retry 3 --retry-all-errors \
    "https://codeload.github.com/s010s/prehistoric-animal-museum/tar.gz/${upstream_sha}" \
    | tar -xz --strip-components=1 -C "${source_dir}"
else
  source_dir="$(cd "${source_dir}" && pwd)"
  upstream_sha="$(git -C "${source_dir}" rev-parse HEAD)"
fi

test -f "${source_dir}/package-lock.json"
cd "${source_dir}"
printf 'Building upstream commit %s\n' "${upstream_sha}"
# npm currently runs sharp's install hook before its optional platform package
# is reified. The project ships prebuilt platform packages in its lockfile, so
# skipping lifecycle hooks avoids an unnecessary and failing source build.
npm ci --ignore-scripts --include=optional
npm run build

rm -rf "${project_root}/dist"
cp -a dist "${project_root}/dist"

node --input-type=module - "${project_root}/icon.png" <<'NODE'
import sharp from 'sharp'

const output = process.argv[2]
await sharp('public/favicon.svg').resize(512, 512).png().toFile(output)
NODE
