echo "******************************************************************************"
echo "Enable chronyd service." `date`
echo "******************************************************************************"
systemctl enable chronyd
systemctl restart chronyd
chronyc -a 'burst 4/4'
chronyc -a makestep
