## Goal

Cloud Foundry's API can be invoked right from the CF CLI.  
This can be extremely useful when needing to do quick troubleshooting tasks or in automating various complicated steps.  

---


## Cloud Foundry's API via CF CLI 

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


For more detail on TAS / Cloud Foundry APIs 

Please see the following:
https://docs.pivotal.io/application-service/2-10/cf-cli/cf7-help.html

https://v3-apidocs.cloudfoundry.org/version/3.94.0/index.html#list-apps
