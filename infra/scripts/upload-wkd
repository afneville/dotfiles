#!/usr/bin/env bash
set -euo pipefail

BUCKET="openpgpkey.afneville.com"
PREFIX=".well-known/openpgpkey/afneville.com"

UIDS=(
    "alex@afneville.com"
    "accounts@afneville.com"
    "engineer@afneville.com"
    "contact@afneville.com"
)

KEY_FILE=$(mktemp)
trap 'rm -f "$KEY_FILE"' EXIT

gpg --export "${UIDS[0]}" > "$KEY_FILE"

for uid in "${UIDS[@]}"; do
    hash=$(gpg-wks-client --print-wkd-hash "$uid" | awk '{print $1}')
    aws s3 cp "$KEY_FILE" "s3://${BUCKET}/${PREFIX}/hu/${hash}" \
        --content-type application/octet-stream
done

echo -n | aws s3 cp - "s3://${BUCKET}/${PREFIX}/policy" --content-type text/plain
