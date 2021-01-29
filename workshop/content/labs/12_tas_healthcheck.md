## Goal

With TAS you are able to apply health checks to all of your applications.   This ensures that you applications behaves as expected with little effort.  
In this lab we will understand how to implement health checks when deploying new applications and for existing applications.   

---


## Implement health checks for your applications.  

- An app health check is a monitoring process that continually checks the status of a running app.

- Developers can configure a health check for an app using the Cloud Foundry Command Line Interface (cf CLI) or by specifying the health-check-http-endpoint and health-check-type fields in an app manifest.

- App health checks function as part of the app lifecycle managed by Diego architecture. For more information, see Diego Components and Architecture here -> https://docs.pivotal.io/application-service/2-10/concepts/diego/diego-architecture.html



- First we will configure a health check for our test-app application that's already deployed.   

1.  Run cf apps to get a list of your running applications.   You should see your test-app application deployed.   
    ```
    cf a
    ```
2. TAS supports configuring 3 different types of health checks.  Port, Process and HTTP.   
- First let's implement a HTTP Health Check for your test-app application.    
   
    ```
    cf set-health-check test-app-<team name> http --endpoint /
    ```
    The output from the above command should look similiar to the following 
    
    ```
        bash-5.0$ cf set-health-check test-app http --endpoint /
        Updating health check type for app test-app in org system / space workshop as admin...
        OK
        TIP: An app restart is required for the change to take effect.

    ```
    Our test application has multiple endpoints so we will want to make sure they are all monitored. 
    Let's implement HTTP Health Check for the rest of our endpoints.    
    ```
    cf set-health-check test-app-<team name> http --endpoint /port
    ```
    
    ```
    cf set-health-check test-app-<team name> http --endpoint /index
    ```
    
    ```
    cf set-health-check test-app-<team name> http --endpoint /env
    ```
      
      
- Next let's configure the health check to monitor the port(s) our app is listening on. 
    ```
    cf set-health-check test-app-<team name> port
    ```
    
    ```
        bash-5.0$ cf set-health-check test-app port 
        Updating health check type for app test-app in org system / space workshop as admin...
        OK
        TIP: An app restart is required for the change to take effect.
    ```
    
    
- Finally let's configure the health check to monitor our app's processes. 
    ```
    cf set-health-check test-app-<team name> process
    ```
    
    ```
        bash-5.0$ cf set-health-check test-app process
        Updating health check type for app test-app in org system / space workshop as admin...
        OK
        TIP: An app restart is required for the change to take effect.
    ```
