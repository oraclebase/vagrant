#!/bin/bash

LOG_FILE=/u01/repo/logs/repo_sync_$(date +%Y.%m.%d).log

# Remove old logs
find /u01/repo/logs/repo_sync* -mtime +5 -delete; >> $LOG_FILE 2>&1

echo "******************************************************************************"
echo "Sync repositories." `date`
echo "******************************************************************************"
/usr/bin/reposync --newest-only --repoid=ol8_UEKR6 -p /u01/repo/OracleLinux >> $LOG_FILE 2>&1
/usr/bin/reposync --newest-only --repoid=ol8_baseos_latest -p /u01/repo/OracleLinux >> $LOG_FILE 2>&1

echo "******************************************************************************"
echo "Recreate repositories." `date`
echo "******************************************************************************"
/usr/bin/createrepo /u01/repo/OracleLinux/ol8_UEKR6/getPackage/
/usr/bin/createrepo /u01/repo/OracleLinux/ol8_baseos_latest/getPackage/
