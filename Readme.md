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

## Before beginning

You can use Visual Studio Code to test you cds
file. [Installing VSCode](https://cap.cloud.sap/docs/get-started/jumpstart#_6-install-visual-studio-code)

## Prerequisites

* JDK - Sapmachine 17.0.8
* Node v20.6.0
* Npm v9.8.1
* [Sap BTP trial account](https://account.hanatrial.ondemand.com/trial/#/home/trial)
* [SAP HANA instance](https://developers.sap.com/tutorials/hana-cloud-mission-trial-2.html)

## Adding entities and relations

According [Reuse a CAP Java Service](https://developers.sap.com/tutorials/cp-cap-java-service-reuse.html)
add entities (to-One and to-Many Associations) and filling they.
According [documentation](https://cap.cloud.sap/docs/cds/cdl#managed-associations)
add Many-to-Many Association.

# FLOW

<details><summary> Description </summary> 

1. Modify scheme.cds file by adding several additional entities:

```
   entity Authors : cuid {
    firstname : String(111);
    lastname  : String(111);
    books     : Association to many Books on books.author = $self;
    }

  entity Books : cuid {
    name    : String(111) @mandatory;
    stock   : Integer;
    price   : Decimal(9,2);
    currency : Currency;
    author  : Association to Authors;
    stores  : Association to many BooksStores on stores.book = $self;
  }

  entity Stores : cuid, managed{
    name : String(111) @mandatory;
    books: Association to many BooksStores on books.store = $self;
  }
```

2. Add custom entity to managed many-to-many Association:

```
 entity BooksStores : managed{
    key book  : Association to Books @mandatory @assert.target;
    key store : Association to Stores @mandatory @assert.target;
  }
```

3. Change db to sqlLite:
    * Add [dependency](https://mvnrepository.com/artifact/org.xerial/sqlite-jdbc)
    * Change properties application.yml, url is a rout to file in you project which wil be generated
      later:
     ```
    datasource:
      url: "jdbc:sqlite:D:\\Projects\\bookstore\\db.sqlite"
       driver-class-name: org.sqlite.JDBC
       hikari:
          maximum-pool-size: 1
    sql:
      init:
        mode: always

   cds:
     odata-v4.endpoint.path: "/api"
     data-source:
     auto-config.enabled: true
      ```
    * Generate file with necessary data:
      ```
      cds add data  
      ```
    * Fill out the generated document. You can use [website](https://www.mockaroo.com) to generate data;
    * Set uo database by running and generate db.sqlite file:
      ```
      cds deploy --to sqlite
      ```
    * Run the app:
      ```
      mvn clean spring-boot:run 
      ```
4. Send some custom request by POSTman:

```
http://localhost:8080/api/BooksService/Book(0bc4b452-ca1a-431a-b6c1-80819cf0bfa1)?$expand=author($select=ID,firstname)
```

```
http://localhost:8080/api/BooksService/Author(60edb0b6-7bc3-41e3-8321-a9fdd3f6ba63)?$expand=books($select=ID,name,stock)
```

</details>

## Adding custom events (Unbound function)

[Bound vs Unbound ](https://cap.cloud.sap/docs/guides/providing-services#bound-vs-unbound)

Difference:

* Bound

<details><summary> Description </summary> 

* Bound Actions: Bound actions are associated with a specific entity and can be invoked on that
  entity. For example, you can define a bound action "cancelOrder" for the "Order" entity, which
  will cancel an order.
* Bound Functions: Bound functions are also associated with a specific entity and can be used to
  retrieve information about that entity. For example, you can define a bound function "
  getTotalPrice" for the "Order" entity to retrieve the total price of an order.

</details>

* Unbound

<details><summary> Description </summary> 

* Unbound Actions: Unbound actions are not tied to a specific entity and can be invoked
  independently of any entity. For example, you can define an unbound action "sendNotification" that
  sends a notification.
* Unbound Functions: Unbound functions are also not tied to a specific entity and can be used
  independently. For example, you can define an unbound function "calculateTax" to calculate tax
  based on input data.

</details>

According [Extend application with Custom Code](https://developers.sap.com/tutorials/cp-cap-java-custom-logic.html)
add custom events.

### FLOW

<details><summary> Description </summary> 

1. Add custom events to "bookstore-service.cds". There
   is [function](https://cap.cloud.sap/docs/guides/providing-services#calling-actions-or-functions)
   in this case.
![function](images/function.png)

2. Add services. PersistenceService from "com.sap.cds.services.persistence" package is using as
   connection between application and database. It's possible to create queries to database by CQL
   requests:

```
service.run(Select.from(cds.gen.bookstore.Books_.class)
        .where(book -> book.author_ID().eq(authorId))).listOf(Books.class);
```

3. Create BookServiceHandler.class. There are methods for handling
   events. [EventHandler phases](https://cap.cloud.sap/docs/java/provisioning-api).

   **NOTE**: for each event, its own context is created through the cds-plugin;

   **NOTE**: Also for mapping you can use [model mapper](https://modelmapper.org/)

```
@On(event = GetAllBooksByAuthorContext.CDS_NAME)
  public void onGetAllBooks(GetAllBooksByAuthorContext context) {
    List<Books> allBooks = bookService.getAllBooks();
    Collection<BookDto> books = bookService.getBooksForAuthor(allBooks, context.getId()).stream()
        .map(this::mapToBookDto).collect(Collectors.toList());
    context.setResult(books);
    context.setCompleted();
  }
```

4. It's possible to test application by:

```
http://localhost:port/api/BookCase/getAllBooksByAuthor(id='author id value')
```

</details>

## Adding custom Event (bound action)

To understand difference between
read [Adding custom events (Unbound function)](#adding-custom-events-unbound-function):

### FLOW

<details><summary> Description </summary> 

1. Add [virtual field](https://cap.cloud.sap/docs/cds/cdl#virtual-elements) to Book entity in
   scheme.cds:

```
   virtual totalProfit  : Decimal(9,2);
```

2. Add field with [default value](https://cap.cloud.sap/docs/cds/cdl#default-values):

```
   top : Boolean default false;
```

3. Add custom events to "bookstore-service.cds". There
   is [action](https://cap.cloud.sap/docs/guides/providing-services#calling-actions-or-functions)
   which bound to entity Author. Add new methods at service layer (service package), also add update entity method.

```
 @readonly
   entity Author as projection on db.Authors
     actions{
       action totalProfitForEachBook (extra: Integer) returns array of Book;
   };
```

4. Add new methode for ServiceHandler to handle action event. This method calculates value of
   virtual field and change value of "top" field if it is necessary.

```
@On(event = TotalProfitForEachBookContext.CDS_NAME)
  public void onTotalProfitForEachBook(TotalProfitForEachBookContext context) {
    Author authorByQuery = authorService.getAuthorByQuery(context.getCqn());
    List<Book> bookForAuthor = bookService.getBookForAuthor(bookService.getAllBook(),
        authorByQuery.getId());
    bookForAuthor.forEach(books -> books.setTotalProfit(books.getPrice()
        .multiply(valueOf(books.getStock()))
        .multiply(valueOf(context.getExtra()))));
    for (Book book : bookForAuthor) {
      Boolean flag = checkTopFlag(book);
      if (flag) {
        book.setTop(flag);
        bookService.save(book);
      }
    }
    context.setResult(bookForAuthor);
    context.setCompleted();
  }
```

5. It's possible to test application by:

![Postman image](/images/postmanImage.png)
![PostmanAuth](images/postmanAuth.png)

</details>

## CAP Multitenancy support

To enable multitenancy on the SAP BTP, we need to deploy tenant aware approuter, mtx-sidecar module and configure below
three services:

* XSUAA
* (Service Manager)[https://help.sap.com/docs/service-manager/sap-service-manager/sap-service-manager]
* (SaaS Provisioning service (
  saas-registry))[https://help.sap.com/docs/btp/sap-business-technology-platform/register-multitenant-application-to-sap-saas-provisioning-service]

[Services description and flow of multitenancy configuration is provided here](https://blogs.sap.com/2021/05/19/multitenant-application-using-cloud-application-programming-model-cap/)

<details><summary> Description </summary>

1. Add xsuaa and approuter by running a command below. Command will creat "app" directory (approuter config) and
   xs-security.json file for xsuaa. Also xsuaa section will be added to .cdsrc.json file.

```
cds add approuter
```

2. Add multitenancy support by running a command below. This command add mtx.sidecar directory (nodejs module) and
   .cdsrc.json file. Also, xs-security.json will be updated by new scope "mtcallback".

```
cds add multitenancy
```

3. Then we need to add mta.yml by running a command below:

```
cds add mta
```

4. In the generated mta.yaml we need to modify several modules:
    * [OPTIONAL] Change service names;
    * Extract xsuaa module configuration to xs-security.json:

```
   # mta.yml
   # Module description should be like this:
     - name: bookstore-xsuaa
    type: org.cloudfoundry.managed-service
    parameters:
      service: xsuaa
      service-plan: application
      path: ./xs-security.json
    requires:
      - name: app-api
```

```
   # xs-security.json:
   # add this line to the begining:
   "xsappname": "bookstore-app",
   "tenant-mode": "shared",
   #add this section to the end:
     "oauth2-configuration": {
    "token-validity": 86400,
    "refresh-token-validity": 2592000,
    "redirect-uris": [
      "https://*.cfapps.us10-001.hana.ondemand.com/**"
    ]
   }
```

5. In MTX module delete dependency for approuter in requires section:

```
   #this part should be deleted:
    - name: approuter-api
      properties:
      SUBSCRIPTION_URL: ~{app-protocol}://\${tenant_subdomain}-~{app-uri}
```

6. In Approuter module add domain in provides section:

```
    provides:
      - name: app-api
        properties:
          url: ${default-url}
    # Add      
        domain: ${domain}
```

</details>

## Deploy

There are two approaches to create SAP HANA DB instance:

* The first approach is creating db instance in subaccount space. **NOTE**: this instance can be used only by
  application which
  located in current space.
* The second approach is creating db instance in subaccount.  ** NOTE**: this instance can be used by all application
  form different subaccounts of global account.

<details><summary> Description </summary>

### [Creating SAP HANA instance in subaccount space](https://developers.sap.com/tutorials/btp-app-hana-cloud-setup.html)

<details><summary> Description </summary>

1. Go to subaccount, click on 'SAPCES' on the left sidebar:
   ![2](images/hana_cloud_empty.png)
2. Choose SAP HANA Cloud, SAP HANA Database:
   ![3](images/hana_cloud_create_1.png)
   ![4](images/hana_cloud_create_2b.png)
   ![5](images/hana_cloud_create_4.png)
   ![6](images/hana_cloud_created.png)

</details>

### Creating SAP HANA instance in subaccount area

You can do this steps only if you finished steps form [Prerequisites](#prerequisites) 

<details><summary> Description </summary>

1. Go to subaccount:
   ![7](images/sub.png)
2. Choose Instances and Subscriptions:
   ![8](images/subacc.png)
3.  Click on SAP HANA CLOUD then chose:
   ![9](images/hana_cloud_create_1.png)
   ![5](images/subacc3.png)
4. Add mapping, click on 'next step' and then click on create .
   
   **NOTE**: You can get account guid by running: 
```
cf space <space_name> --guid
```
![6](images/subacc4.png)

</details>

### Adding roles

 To get access to SaaS-Registry-Dashboard you need to assign following role:
```
Subscription Management Dashboard Administrator
```
```
Subscription Management Dashboard Viewer
```
<details><summary> Description </summary>

To get access you wil need to set up a role collection:

1. Go to the Security;
2. Go to Role Collection;
3. Add a new Role Collection by clicking + button, call it whatever you want and hit create;
4. Scroll down and click edit that new role collection and hit edit;
5. Add two roles Subscription Management Dashboard Administrator and Subscription Management Dashboard Viewer;
6. In Users tab add your email address;

</details>

</details>

## Helpful links:

* [CAP tutorial in 15 part](https://bnheise.medium.com/custom-actions-in-cap-java-2-fd84b6b3720a)
* [cloud-cap-sample-java](https://github.com/SAP-samples/cloud-cap-samples-java/tree/mtx-classic-1.x)
* [Addition info in Readme.md](https://github.com/Ragimzade/cap-odata-training-project)

