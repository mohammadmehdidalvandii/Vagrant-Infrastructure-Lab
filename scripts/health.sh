#!/bin/bash

URL="http://127.0.0.1:8080"

echo "===================================="
echo "       APPLICATION HEALTH CHECK"
echo "===================================="

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

echo "Application URL: $URL"
echo "HTTP Status: $HTTP_STATUS"

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "Health Status: HEALTHY"
    exit 0
else
    echo "Health Status: UNHEALTHY"
    exit 1
fi
