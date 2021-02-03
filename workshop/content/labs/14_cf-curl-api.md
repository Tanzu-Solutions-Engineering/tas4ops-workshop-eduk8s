## Goal

Cloud Foundry's API can be invoked right from the CF CLI.  
This can be extremely useful when needing to do quick troubleshooting tasks or in automating various complicated steps.  

---


## Cloud Foundry's API via CF CLI 

Many users will think of interactions with Cloud Foundry in terms of a single operation like cf push in order to upload an application to the platform, have it compiled, and schedule it to be run. Performing a push operation actually requires a client to orchestrate several requests to the API to accomplish the entire operation. 


Cloud Foundry's API can be invoked via the CF CLI.  This is a very easy way to execute Cloud foundry API calls without the need to understand OAUTH and Token Authentication.  




Let's try a few API Calls to see what's available.  


1.  First let's try listing details of all of our apps within our Foundation.  

    ```execute-2
    cf curl "/v2/apps" -X GET -H "Content-Type: application/x-www-form-urlencoded"
    ```
    
    This will give you a very long list of every application deployed to our foundation.   


2. Next, let's query for a specific application name.     
   (Let's search for our test app) 
   
    ```execute-2
    cf curl "/v2/apps" -X GET -H "Content-Type: application/x-www-form-urlencoded" -d 'q=name:test-app'
    ```
    
3. Let's list all of the audit events which happened in our environment.    
   
   ```execute-2
   cf curl /v3/audit_events -X GET -H "Content-Type: application/x-www-form-urlencoded"
   ```
   
   
4. Let's get even more specific, let's find the summary for a specific application 
   In order to do this, we will need to grab the guid of one of our apps.   
    (Save this guid for the next command) 
    
   ```execute-2
   cf app spring-music --guid
   ```
   
   Example Output: 
   ```
   [~/myApps/test-app] $ cf app spring-music --guid
   6a914796-3905-4871-9557-bdbb0b9c3143
   ```
   
   Let's query our app using it's guid.  
   
   ```copy-and-edit
   cf curl /v2/apps/<GUID>/summary

   ```
   
   
   You could also do the above steps in the same command.  
   
   ```execute-2
   cf curl /v2/apps/$(cf app spring-music --guid)/summary
   ```

5.  Next let's try listing our foundation's tasks.  

    ```execute-2
    cf curl "/v3/tasks" -X GET -H "Content-Type: application/x-www-form-urlencoded"    
    ```

6.  Now let's try listing our tasks for our spring-music app.

    Since this API requires knowing the GUID of our spring-music app we will use a CF CLI command to get the GUID.   

    ```execute-2
    cf curl "/v3/apps/$(cf app spring-music --guid)/tasks" -X GET -H "Content-Type: application/x-www-form-urlencoded"    
    ```
    
    Let's now get the tasks for our test-app.   
    
    ```execute-2
    cf curl "/v3/apps/$(cf app test-app --guid)/tasks" -X GET -H "Content-Type: application/x-www-form-urlencoded"
    ```

7.  Let's try a simple workflow with our APIs.  

    First let's push a new app called "v3-tasks-sample"

    Change to your test-app directory 
    ```execute-2
    cd /home/eduk8s/myApps/test-app
    ```
    
    Let's push our app. 
    ```execute-2
    cf push v3-tasks-sample
    ```
    
    Now let's view our newly deployed app.  
    ```execute-2
    cf app v3-tasks-sample
    ```
    
    
    Let's now construct a task creation to echo "I love TAS"
    
    (Just a simple example of what could be done) 
    
    ```execute-2
    cf curl /v3/apps/$(cf app v3-tasks-sample --guid)/tasks -X POST -d '{"command":"echo foo; sleep 5; echo I love TAS;"}'
    ```
 
    
    Let's view our logs, we should see log messages from our tasks.   
    
    ```execute-2
    cf logs v3-tasks-sample --recent 
    ```
    
    
    Since there may be a number of rolling logs, let's grep for our expected output.   
    
    ```execute-2
    cf logs v3-tasks-sample --recent |grep "I love TAS"
    ```
    
    
    
    
    

  


For more detail on TAS / Cloud Foundry APIs 

Please see the following:
https://docs.pivotal.io/application-service/2-10/cf-cli/cf7-help.html

https://v3-apidocs.cloudfoundry.org/version/3.94.0/index.html#list-apps
