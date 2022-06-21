#!/bin/bash

set -e

SCRIPT_NAME=backup-redis
ARCHIVE_NAME=redisdump_$(date +%Y%m%d_%H%M%S).gz
OPLOG_FLAG=""

if [ -n "$RedisOplog" ]; then
	OPLOG_FLAG="--oplog"
fi

echo "[$SCRIPT_NAME] Dumping all RedisDB databases to compressed archive..."
S3_ENDPOINT_OPT=""
if [ ! -z "$S3_ENDPOINT_URL" ]; then
  S3_ENDPOINT_OPT="--endpoint-url $S3_ENDPOINT_URL"
fi

echo "[$SCRIPT_NAME] Uploading compressed archive to S3 bucket..."
aws ${S3_ENDPOINT_OPT} s3 cp "/data/dump.rdb" "$BUCKET_URI/redisdump_$(date +%Y%m%d_%H%M%S).rdb"

echo "[$SCRIPT_NAME] Cleaning up compressed archive..."
rm "$COPY_NAME"
rm "$ARCHIVE_NAME" || true

echo "[$SCRIPT_NAME] Backup complete!"
