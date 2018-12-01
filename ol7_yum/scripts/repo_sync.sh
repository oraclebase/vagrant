#!/bin/bash

LOG_FILE=/u01/repo/logs/repo_sync_$(date +%Y.%m.%d).log

# Remove old logs
find /u01/repo/logs/repo_sync* -mtime +5 -delete; >> $LOG_FILE 2>&1

echo "******************************************************************************"
echo "Sync repositories." `date`
echo "******************************************************************************"
/usr/bin/reposync --newest-only --repoid=ol7_UEKR4 -p /u01/repo/OracleLinux >> $LOG_FILE 2>&1
/usr/bin/reposync --newest-only --repoid=ol7_UEKR5 -p /u01/repo/OracleLinux >> $LOG_FILE 2>&1
/usr/bin/reposync --newest-only --repoid=ol7_latest -p /u01/repo/OracleLinux >> $LOG_FILE 2>&1
#/usr/bin/reposync --newest-only --repoid=ol7_optional_latest -p /u01/repo/OracleLinux >> $LOG_FILE 2>&1
#/usr/bin/reposync --newest-only --repoid=ol7_addons -p /u01/repo/OracleLinux >> $LOG_FILE 2>&1
#/usr/bin/reposync --newest-only --repoid=ol7_preview -p /u01/repo/OracleLinux >> $LOG_FILE 2>&1
#/usr/bin/reposync --newest-only --repoid=ol7_developer -p /u01/repo/OracleLinux >> $LOG_FILE 2>&1
#/usr/bin/reposync --newest-only --repoid=ol7_developer_EPEL -p /u01/repo/OracleLinux >> $LOG_FILE 2>&1

echo "******************************************************************************"
echo "Recreate repositories." `date`
echo "******************************************************************************"
/usr/bin/createrepo /u01/repo/OracleLinux/ol7_UEKR4/getPackage/
/usr/bin/createrepo /u01/repo/OracleLinux/ol7_UEKR5/getPackage/
/usr/bin/createrepo /u01/repo/OracleLinux/ol7_latest/getPackage/
#/usr/bin/createrepo /u01/repo/OracleLinux/ol7_optional_latest/getPackage/
#/usr/bin/createrepo /u01/repo/OracleLinux/ol7_addons/getPackage/
#/usr/bin/createrepo /u01/repo/OracleLinux/ol7_preview/getPackage/
#/usr/bin/createrepo /u01/repo/OracleLinux/ol7_developer/getPackage/
#/usr/bin/createrepo /u01/repo/OracleLinux/ol7_developer_EPEL/getPackage/
