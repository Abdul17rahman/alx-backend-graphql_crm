#!/bin/bash

# Get the directory of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Move to project root
cd "$SCRIPT_DIR/../.."

# Save current working directory
CWD=$(pwd)

# Log file
LOG_FILE="/tmp/customer_cleanup_log.txt"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Check if we're in the right directory
if [ -d "$CWD/crm" ]; then
  DELETED_COUNT=$(python manage.py shell <<EOF
from datetime import timedelta
from django.utils import timezone
from crm.models import Customer

cutoff = timezone.now() - timedelta(days=365)
qs = Customer.objects.filter(order__isnull=True, created_at__lt=cutoff)
count = qs.count()
qs.delete()
print(count)
EOF
  )

  # Log the deletion
  echo "$TIMESTAMP - Deleted $DELETED_COUNT inactive customers" >> "$LOG_FILE"
else
  echo "$TIMESTAMP - ERROR: cwd not valid for running cleanup" >> "$LOG_FILE"
fi
