#!/bin/groovy

def deleteFiles() {

}

def executeBashCommand(String cmd) { 
	// print the command before it is executed (just in case it fails for some reason)
	println "CMD: $cmd"

	def sout = new StringBuffer(), serr = new StringBuffer()
	// create a bash process, based off of the command array.  Process should return 
	// immediately but a new thread will be spawned off to execute the other command
	def proc = ["/bin/sh", "-c", cmd].execute()
	
	// this will consume the output of the process so that it prevents blocking, as well
	// as so we can print it out
	proc.consumeProcessOutput(sout, serr)

	// will wait for the process to execute for 5 minutes, otherwise it will kill
	// the spawned process
	proc.waitForOrKill(300000)

	// print out the appropriate information
	if (sout)
		println "out> $sout"
	if (serr)
		println "err> $serr"
	if (proc.exitValue() != 0)
		System.exit(1)
}

def renameFile(String file1, String file2) {
	def renameResult = new File(file1).renameTo(file2)
	if (renameResult == false) {
		println ("ERROR: there was a problem renaming $file1 to $file2")
		System.exit(1)
	}
}

def slurpXML() {
	def project = new XmlSlurper().parseText(new File('pom.xml').text)
	def snpVersion = project.version
	def solorGoodsVersion = project.properties.'solor.version'

	println()
	println "Processing for SNP Version: $snpVersion, solor-goods Version: $solorGoodsVersion"
	println()

	["snpVersion": snpVersion.toString(), "solorGoodsVersion": solorGoodsVersion.toString()]
}

def downloadFiles() {
	println "Downloading POM..."
	def url = "https://raw.githubusercontent.com/Deloitte-VA/snp-prototype/master/pom.xml" 
    def file = new File('pom.xml')
    def fileOS = file.newOutputStream()
    fileOS << new URL(url).openStream()
    fileOS.close()  
	def currentVersions = slurpXML()
	file.delete()

	println "Downloading War..."
	executeBashCommand("mvn org.apache.maven.plugins:maven-dependency-plugin:2.10:get -DgroupId=com.github.jlgrock.snp -DartifactId=web -Dversion=${currentVersions.snpVersion} -Dpackaging=war -Ddest=.")
	renameFile("web-${currentVersions.snpVersion}.war", "snpweb.war")

	//println "Downloading Lucene Index (this may take a while)..."
	//executeCommand("mvn org.apache.maven.plugins:maven-dependency-plugin:2.10:get -DgroupId=gov.vha.solor.modules -DartifactId=snomed -Dversion=${currentVersions.solorGoodsVersion} -Dclassifier=all.lucene -Dpackaging=zip -Ddest=.")
	//renameFile("snomed-${currentVersions.solorGoodsVersion}-all.lucene.zip", "lucene.zip")

	//println "Downloading Cradle Database File (this may take a while)..."
	//executeCommand("mvn org.apache.maven.plugins:maven-dependency-plugin:2.10:get -DgroupId=gov.vha.solor.modules -DartifactId=snomed -Dversion=${currentVersions.solorGoodsVersion} -Dclassifier=all.cradle -Dpackaging=zip -Ddest=.")
	//renameFile("snomed-${currentVersions.solorGoodsVersion}-all.cradle.zip", "cradle.zip")

	currentVersions.snpVersion
}

def buildAndReleaseDockerImage(String snpVersion) {
	String owner = "deloitteva"
	String imageName = "docker-snp"

	println()
	println "Check that the Docker image is running and who it is running as..."
	executeBashCommand("whoami")
	executeBashCommand("ps aux | grep docker")

	println "Building/Pushing docker images for latest and ${snpVersion}"
	executeBashCommand("docker build -t ${owner}/${imageName}:${snpVersion} .")
	executeBashCommand("docker tag -f ${owner}/${imageName}:${snpVersion} ${owner}/${imageName}:latest")
	if (!snpVersion.contains("-SNAPSHOT"))
		executeBashCommand("docker push ${owner}/${imageName}:${snpVersion}")

	executeBashCommand("docker push ${owner}/${imageName}:latest")
}

deleteFiles()
def version = downloadFiles()
buildAndReleaseDockerImage(version)
deleteFiles()
