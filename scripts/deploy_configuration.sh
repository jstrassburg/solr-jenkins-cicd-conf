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

DEPLOY_DIR=deploy
SOLR_INSTALL_DIR=/opt/solr

echo "Copying configsets to $server..."
scp -r -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/configsets vagrant@$server:$DEPLOY_DIR

echo "Copying collection configurations to $server..."
scp -r -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/collections vagrant@$server:$DEPLOY_DIR

echo "Copying libraries directory to $server..."
scp -r -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/lib vagrant@$server:$DEPLOY_DIR

echo "Copying solr.xml to $server..."
scp -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/solr.xml vagrant@$server:$DEPLOY_DIR

echo "Copying allcores.$environment.properties to $server..."
scp -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/configprops/allcores.$environment.properties vagrant@$server:$DEPLOY_DIR

echo "Copying solr.in.sh to $server..."
scp -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/solr.in.$environment.sh vagrant@$server:$DEPLOY_DIR

echo "Copying log4j.properties to $server..."
scp -i $SSHKEYFILE -o StrictHostKeyChecking=no home/solr_instance/log4j.properties vagrant@$server:$DEPLOY_DIR

ssh -t -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $SSHKEYFILE vagrant@$server << FINISH
    echo "Creating Solr home directory if it doesn't exist...'"
    sudo mkdir -p $SOLR_HOME

    echo "Creating configprops directory if it doesn't exist..."
    sudo mkdir -p $SOLR_HOME/configprops

    echo "Deploying configsets..."
    sudo cp -R $DEPLOY_DIR/configsets $SOLR_HOME
    rm -rf $DEPLOY_DIR/configsets

    echo "Deploying collections..."
    sudo cp -R $DEPLOY_DIR/collections $SOLR_HOME
    rm -rf $DEPLOY_DIR/collections

    echo "Deploying libs..."
    sudo cp -R $DEPLOY_DIR/lib $SOLR_HOME
    rm -rf $DEPLOY_DIR/lib

    echo "Deploying solr.xml..."
    sudo cp $DEPLOY_DIR/solr.xml $SOLR_HOME
    rm -f $DEPLOY_DIR/solr.xml

    echo "Deploying configprops/allcores.properties..."
    sudo cp $DEPLOY_DIR/allcores.$environment.properties $SOLR_HOME/configprops/allcores.properties
    rm -f $DEPLOY_DIR/allcores.$environment.properties

    echo "Deploying solr.in.sh..."
    sudo cp $DEPLOY_DIR/solr.in.$environment.sh /etc/default/solr.in.sh
    rm -f $DEPLOY_DIR/solr.in.$environemnt.sh

    echo "Deploying log4j.properties..."
    sudo cp $DEPLOY_DIR/log4j.properties $SOLR_HOME/../
    rm -f $DEPLOY_DIR/log4j.propertiesa

    echo "Creating $LOG_DIR if it doesn't exist and setting permissions..."
    sudo mkdir -p $LOG_DIR
    sudo chown -R "$SOLR_USER":"$SOLR_USER" $LOG_DIR

    echo "Changing ownership on root copied things..."
    sudo chown -R "$SOLR_USER":"$SOLR_USER" $SOLR_HOME
    sudo chmod -R a+r $SOLR_HOME
    
    echo "Restarting Solr service"
    sudo service $SOLR_SERVICE restart
FINISH