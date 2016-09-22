#!/bin/bash

if ["$GITHUB_HOME" == ""]; then
    export GITHUB_HOME="`pwd`/.."
fi

$GITHUB_HOME/lucene-solr/solr/bin/solr start -s "$GITHUB_HOME/solr-jenkins-cicd-conf/home/solr_instance" 
