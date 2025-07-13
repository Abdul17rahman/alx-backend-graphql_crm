#!/bin/bash

# Log file path
LOG_FILE="/tmp/customer_cleanup_log.txt"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Run Django management shell command
DELETED_COUNT=$(python manage.py shell <<EOF
from django.utils import timezone
from datetime import timedelta
from crm.models import Customer
cutoff = timezone.now() - timedelta(days=365)
qs = Customer.objects.filter(order__isnull=True, created_at__lt=cutoff)
count = qs.count()
qs.delete()
print(count)
EOF
)

# Append result to log
echo "$TIMESTAMP - Deleted $DELETED_COUNT inactive customers" >> "$LOG_FILE"
