# snp-prototype-tomcat
Docker container used for publishing the snp-prototype project war within a tomcat instance

This is used to support the [Semantic Normalization Prototype](https://github.com/jlgrock/snp-prototype).  Documentation on how to use this can also be found there.  

Development Procedures:
  - Comment out the section marked "Used for releases" and uncomment the section marked "Used for development", updating the file that you wish to upload in the [Dockerfile](https://github.com/Deloitte-VA/snp-prototype-tomcat/blob/master/Dockerfile).
  - `sudo docker build -t jlgrock/snp-prototype-tomcat`
  - DO NOT CHECK THIS CODE IN

Release Procedures:
  - Make sure that the release for [Semantic Normalization Prototype](https://github.com/jlgrock/snp-prototype) to Sonatype OSS has been completed.
  - Update the version in the [Dockerfile](https://github.com/Deloitte-VA/snp-prototype-tomcat/blob/master/Dockerfile)
  - `sudo docker build -t jlgrock/snp-prototype-tomcat`
  - `sudo docker push jlgrock/snp-prototype-tomcat:[VERSION]` (replacing [VERSION] with the actual version number)
  - Check in your changes and update Docker hub instructions, if necessary.

Run Procedures:
  - see [Docker Hub](https://registry.hub.docker.com/u/jlgrock/snp-prototype-tomcat/)

Travis-CI Build Status
---------------------
![Build Status](https://travis-ci.org/Deloitte-VA/snp-prototype-mongodb.svg?branch=master)
