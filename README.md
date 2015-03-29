# snp-prototype-tomcat
Docker container used for publishing the snp-prototype project war within a tomcat instance

This is used to support the [Semantic Normalization Prototype](https://github.com/jlgrock/snp-prototype).  Documentation on how to use this can also be found there.  

Release Procedures:
  - sudo docker build -t jlgrock/snp-prototype-tomcat
  - sudo docker push jlgrock/snp-prototype-tomcat

Run Procedures:
see [Docker Hub](https://registry.hub.docker.com/u/jlgrock/snp-prototype-mongodb/)

Travis-CI Build Status
---------------------
![Build Status](https://travis-ci.org/Deloitte-VA/snp-prototype-mongodb.svg?branch=master)
