#!/bin/bash
set -e

# Delete files
deletefiles() {
	rm -rf snpweb.war;
	rm -rf lucene.zip;
	rm -rf cradle.zip;	
}

deletefiles

echo "Enter SNP Prototype Version:"
read SNP_VERSION

echo "Enter Solor Goods Version:"
read SOLOR_GOODS_VERSION

echo "Copying War from ~/.m2 ..."
cp /Users/jlgrock/.m2/repository/com/github/jlgrock/snp/web/0.2-SNAPSHOT/web-0.2-SNAPSHOT.war ./snpweb.war

echo "Downloading Lucene Index from ~/.m2..."
cp /Users/jlgrock/.m2/repository/gov/vha/solor/snomed/1.2/snomed-1.2-all.lucene.zip ./lucene.zip

echo "Downloading Cradle Database File from ~/.m2..."
cp /Users/jlgrock/.m2/repository/gov/vha/solor/snomed/1.2/snomed-1.2-all.cradle.zip ./cradle.zip

docker build -t jlgrock/snp-prototype-tomcat .

deletefiles

