#!/bin/bash

if ["$GITHUB_HOME" == ""]; then
    export GITHUB_HOME="`pwd`/.."
fi

$GITHUB_HOME/lucene-solr/solr/bin/solr stop -all
