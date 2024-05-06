. /vagrant/config/install.env

if [ "${INSTALL_APEX}" = "false" ]; then
  exit 0
fi

echo "******************************************************************************"
echo "Unzip APEX software." `date`
echo "******************************************************************************"
cd ${SOFTWARE_DIR}
unzip -oq /vagrant/software/${APEX_SOFTWARE}
cd apex


echo "******************************************************************************"
echo "Install APEX." `date`
echo "******************************************************************************"
sqlplus sys/${SYS_PASSWORD}@//localhost:1521/${PDB_NAME} as sysdba <<EOF

alter system set db_create_file_dest='${DATA_DIR}';

create tablespace apex datafile size 100m autoextend on next 100m;
@apexins.sql APEX APEX TEMP /i/
BEGIN
    APEX_UTIL.set_security_group_id( 10 );

    APEX_UTIL.create_user(
        p_user_name       => 'ADMIN',
        p_email_address   => '${APEX_EMAIL}',
        p_web_password    => '${APEX_PASSWORD}',
        p_developer_privs => 'ADMIN' );

    APEX_UTIL.set_security_group_id( null );
    COMMIT;
END;
/
@apex_rest_config.sql "${APEX_PASSWORD}" "${APEX_PASSWORD}"
alter user APEX_PUBLIC_USER identified by "${APEX_PASSWORD}" account unlock;
alter user APEX_REST_PUBLIC_USER identified by "${APEX_PASSWORD}" account unlock;
exit;
EOF
