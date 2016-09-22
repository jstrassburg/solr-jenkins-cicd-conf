solr-jenkins-cicd-conf
----------------------
Using Jenkins to build a CI/CD pipeline for Apache Solr. This is the Solr configuration repo.

Prepared for the [Lucene Solr Revolution 2016 Conference](http://lucenerevolution.org/)

Getting up and running
----------------------
For deploying using Jenkins, use the instructions in the other repository [https://github.com/jstrassburg/solr-jenkins-cicd](https://github.com/jstrassburg/solr-jenkins-cicd)

For developing solr locally use:

    scripts/start_solr.sh
    scripts/stop_solr.sh

* You must compile solr in the lucene-solr repo to run Solr locally
* Optionally you can export a GITHUB_HOME directory on which to find the compiled lucene-solr repo
** This will default to `pwd`/.. 
