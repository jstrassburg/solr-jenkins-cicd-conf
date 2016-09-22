@echo off
@rem first install nssm from http://nssm.cc/download
@rem unzip the contents into somewhere in your PATH variable or add the exe location to the PATH, then run this script

echo Updating Solr NSSM service

set port=8985

IF "%GITLAB_HOME%"=="" SET GITLAB_HOME=\gitlab

net stop solr
nssm.exe remove solr confirm
nssm.exe install solr "%GITLAB_HOME%\lucene-solr\solr\bin\solr.cmd" start -f -p %port% -s "\"%GITLAB_HOME%\solr-dev\home\ecommerce"\" -a "\"-Djetty.base=%GITLAB_HOME%\solr-dev\jetty -Djetty.realm=%GITLAB_HOME%\solr-dev\home\ecommerce\jetty\realm.properties"\"

nssm.exe set solr AppDirectory %GITLAB_HOME%\lucene-solr\solr\bin
net start solr

if "%1" == "launchbrowser" (
	echo Waiting 10 seconds and launching a browser to your Solr instance...
	timeout 10
	start http://localhost:%port%/solr/
)
popd