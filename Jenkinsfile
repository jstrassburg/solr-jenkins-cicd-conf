node {
    stage "Deploy Solr Conf - Stage Env"
    checkout scm
    sh 'scripts/deploy_configuration.sh 10.0.0.11 STAGE /usr/local/solr/data /var/log/solr solr solr ~/stage_private_key'
    archive '**/*'

    stage "Test Stage Deploy"
    sh 'echo TODO - Test here'

    stage "Deploy Solr - Production Env"
    sh 'scripts/deploy_configuration.sh 10.0.0.12 PRODUCTION /usr/local/solr/data /var/log/solr solr solr ~/prod_private_key'
}
