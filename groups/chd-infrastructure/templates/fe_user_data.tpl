#!/bin/bash
# Redirect the user-data output to the console logs
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

GET_PARAM_COMMAND="/usr/local/bin/aws ssm get-parameter --with-decryption --region ${REGION} --output text --query Parameter.Value --name"

#Create key:value variable
$${GET_PARAM_COMMAND} '${CHD_FRONTEND_INPUTS_PATH}' > inputs.json
#Set DATABASE environment variable
echo "export DATABASE=ORACLE" >> /home/chd/.bash_profile
#Update Nagios registration script with relevant template
cp /usr/local/bin/nagios-host-add.sh /usr/local/bin/nagios-host-add.j2
REPLACE=CHD_FRONTEND_${HERITAGE_ENVIRONMENT} /usr/local/bin/j2 /usr/local/bin/nagios-host-add.j2 > /usr/local/bin/nagios-host-add.sh
#Create the TNSNames.ora file for Oracle
/usr/local/bin/j2 -f json /usr/lib/oracle/11.2/client64/lib/tnsnames.j2 inputs.json > /usr/lib/oracle/11.2/client64/lib/tnsnames.ora
#Remove unnecessary files
rm /etc/httpd/conf.d/welcome.conf
rm /etc/httpd/conf.d/ssl.conf
rm /etc/httpd/conf.d/perl.conf
#Create and populate httpd config
/usr/local/bin/j2 -f json /etc/httpd/conf/httpd.conf.j2 inputs.json > /etc/httpd/conf/httpd.conf
#Create and populate the perl config
/usr/local/bin/j2 -f json /etc/httpd/conf.d/chd_perl.conf.j2 inputs.json > /etc/httpd/conf.d/chd_perl.conf
#Run Ansible playbook for Frontend deployment using provided inputs
$${GET_PARAM_COMMAND} '${ANSIBLE_INPUTS_PATH}' > /root/ansible_inputs.json
echo "Deploying ${APP_VERSION}"
/usr/local/bin/ansible-playbook /root/frontend_deployment.yml -e '@/root/ansible_inputs.json'
#Create htdocs symlink
ln -s ${ONLINE_MOUNT_PATH} /home/chd/htdocs/chd3/static/online
# Update hostname and reboot
INSTANCEID=$(curl http://169.254.169.254/latest/meta-data/instance-id)
sed -i "s/HOSTNAME=.*/HOSTNAME=$INSTANCEID/" /etc/sysconfig/network
sed -i "s/\b127.0.0.1\b/127.0.0.1 $INSTANCEID/" /etc/hosts
# Reboot to take effect
reboot
