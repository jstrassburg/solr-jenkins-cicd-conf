node {
    stage "Deploy Solr Conf - Stage Env"
    sh 'scripts/deploy_configuration.sh STAGE 10.0.0.11 /usr/local/solr/data /var/log/solr solr solr ~/stage_private_key'

    stage "Test Stage Deploy"
    sh 'echo TODO - Test here'

    stage "Deploy Solr - Production Env"
    sh 'scripts/deploy_configuration.sh PRODUCTION 10.0.0.12 /usr/local/solr/data /var/log/solr solr solr ~/prod_private_key'
}
