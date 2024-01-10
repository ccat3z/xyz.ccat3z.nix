#! /usr/bin/env sh

set -ex

cd "$(dirname "$0")"
for f in keys.yaml $(find . -type f -name '*.enc'); do
  sops updatekeys -y "$f"
done
