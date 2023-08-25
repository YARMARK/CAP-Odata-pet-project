# CAP-OData-project

## Description

This is a test project about implementing Java backend microservices on SAP BTP Cloud
Foundry Platform using CAP Framework.

## [Quick start](https://cap.cloud.sap/docs/java/getting-started)

<details><summary> Description </summary> 

* Install CAP's cds-dk:
```
npm add -g @sap/cds-dk
```
* Create a project with "cds-services-archetype":

```
mvn archetype:generate -DarchetypeArtifactId="cds-services-archetype" -DarchetypeGroupId="com.sap.cds" -DarchetypeVersion="RELEASE" -DinteractiveMode=true
```
or
```
cds init <PROJECT-ROOT> --add java
```

* Use mvn-cds-plugin to add sample CDS model:
```
mvn com.sap.cds:cds-maven-plugin:addSample
```
* Use command: 
```
mvn clean install -DskipTests
```
* Mark "java" folder in "get" directory as "source" to add all imports in handler:
![Root folder](images/sourceFolder.png)

* Run command to add cloudfoundry dependency in pom.xml:
```
mvn com.sap.cds:cds-maven-plugin:addTargetPlatform -DtargetPlatform=cloudfoundry
```
* To test application locally run:
```
cd <PROJECT-ROOT>
```
```
mvn spring-boot:run
```
</details>

