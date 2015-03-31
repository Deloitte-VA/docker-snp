#!/bin/bash
set -e

# Delete files
deletefiles() {
	rm -rf snpweb.war;
	rm -rf lucene.zip;
	rm -rf cradle.zip;	
}

deletefiles

echo "Enter Artifactory Username: "
read ARTIFACTORY_USERNAME
echo "Enter Artifactory Password: "
read -s ARTIFACTORY_PASSWORD

echo "Enter SNP Prototype Version:"
read SNP_VERSION

echo "Enter Solor Goods Version:"
read SOLOR_GOODS_VERSION

# ENV WAR_URL http://search.maven.org/remotecontent?filepath=com/github/jlgrock/snp/web/$SNP_VERSION/web-$SNP_VERSION.war
WAR_URL="https://oss.sonatype.org/content/groups/staging/com/github/jlgrock/snp/web/$SNP_VERSION/web-$SNP_VERSION.war"
var=$(curl -IsL -o /dev/null -w "%{http_code}" "$WAR_URL")
if [[ "$var"  == "200" ]]; then
	echo "Downloading War from $WAR_URL..."
	curl -SL "$WAR_URL" -o snpweb.war	
else
	echo "HTTP ERROR[$var]. Unable to download War with version=$SNP_VERSION from url=$WAR_URL"
	exit 1
fi

LUCENE_URL="http://dev.informatics.com/artifactory/ext-release-local/gov/vha/solor/snomed/${SOLOR_GOODS_VERSION}/snomed-${SOLOR_GOODS_VERSION}-all.lucene.zip"
var=$(curl -IsL -o /dev/null -w "%{http_code}" -u $ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD "$LUCENE_URL")
if [[ "$var"  == "200" ]]; then
	echo "Downloading Lucene Index from $LUCENE_URL..."
	curl -SL "$LUCENE_URL" -u "$ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD" -o lucene.zip
else
	echo "HTTP ERROR[$var]. Unable to download Lucene Index with version=$SOLOR_GOODS_VERSION from url=$LUCENE_URL"
	exit 1
fi

CRADLE_URL="http://dev.informatics.com/artifactory/ext-release-local/gov/vha/solor/snomed/${SOLOR_GOODS_VERSION}/snomed-${SOLOR_GOODS_VERSION}-all.cradle.zip"
var=$(curl -IsL -o /dev/null -w "%{http_code}" -u $ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD "$CRADLE_URL")
if [[ "$var"  == "200" ]]; then
	echo "Downloading Cradle Database File from $CRADLE_URL..."
	curl -SL "$LUCENE_URL" -u "$ARTIFACTORY_USERNAME:$ARTIFACTORY_PASSWORD" -o cradle.zip
else
	echo "HTTP ERROR[$var]. Unable to download Cradle Database with version=$SOLOR_GOODS_VERSION from url=$CRADLE_URL"
	exit 1
fi

docker build -t jlgrock/snp-prototype-tomcat .
docker push jlgrock/snp-prototype-tomcat:$SNP_VERSION

deletefiles

