# Usage from Jenkins:
# deploy_configuration.sh server_to_deploy_to environment solr_home log_dir solr_username service_name private_key_file
# Where environemnt is one of: STAGE, PRODUCTION
# deploy_configuration.sh 10.0.0.11 STAGE /usr/local/solr/data /var/log/solr solr solr ~/.ssh/my_key

server="$1"
environment="$2"
SOLR_HOME="$3"
LOG_DIR="$4"
SOLR_USER="$5"
SOLR_SERVICE="$6"
SSHKEYFILE="$7"

DEPLOY_DIR=/tmp/deploy
SOLR_INSTALL_DIR=/opt/solr

echo "Copying configsets to $server..."
scp -r -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/configsets root@$server:$SOLR_HOME

echo "Copying collection configurations to $server..."
scp -r -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/collections root@$server:$SOLR_HOME

echo "Copying libraries directory to $server..."
scp -r -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/lib root@$server:$SOLR_HOME

echo "Copying solr.xml to $server..."
scp -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/solr.xml root@$server:$SOLR_HOME

echo "Creating configprops directory if it doesn't exist..."
ssh -t -i $SSHKEYFILE -o StrictHostKeyChecking=no root@$server mkdir -p $SOLR_HOME/configprops

echo "Copying allcores.$environment.properties to $server..."
scp -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/configprops/allcores.$environment.properties root@$server:$SOLR_HOME/configprops

echo "Copying solr.in.sh to $server..."
scp -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/solr.in.$environment.sh root@$server:/etc/default

echo "Copying log4j.properties to $server..."
scp -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/log4j.properties root@$server:$SOLR_HOME/..

ssh -t -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $SSHKEYFILE root@$server << FINISH
    echo "Creating $LOG_DIR if it doesn't exist and setting permissions..."
    mkdir -p $LOG_DIR
    chown -R "$SOLR_USER":"$SOLR_USER" $LOG_DIR

    echo "Renaming environment allcores.properties..."
    mv $SOLR_HOME/configprops/allcores.$environment.properties $SOLR_HOME/configprops/allcores.properties
    
    echo "Renaming environment solr.in.sh..."
    mv /etc/default/solr.in.$environment.sh /etc/default/solr.in.sh

    echo "Changing ownership on root copied things..."
    chown -R "$SOLR_USER":"$SOLR_USER" $SOLR_HOME
    chmod -R a+r $SOLR_HOME
    
    echo "Restarting Solr service"
    service $SOLR_SERVICE restart
FINISH