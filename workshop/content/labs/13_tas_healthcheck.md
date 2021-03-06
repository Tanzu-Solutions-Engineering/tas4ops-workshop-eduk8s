## Goal

With TAS you are able to apply health checks to all of your applications.   This ensures that your applications behave as expected with little effort.  
In this lab we will understand how to implement health checks when deploying new applications and for existing applications.   

---


## Implement health checks for your applications.  

- An app health check is a monitoring process that continually checks the status of a running app.

- Developers can configure a health check for an app using the Cloud Foundry Command Line Interface (cf CLI) or by specifying the health-check-http-endpoint and health-check-type fields in an app manifest.

- App health checks function as part of the app lifecycle managed by Diego architecture. For more information, see Diego Components and Architecture here -> https://docs.pivotal.io/application-service/2-10/concepts/diego/diego-architecture.html



- First we will configure a health check for our test-app application that's already deployed.   

1.  Run cf apps to get a list of your running applications.   You should see your test-app application deployed.   
```execute-2
cf a
```

2. TAS supports configuring 3 different types of health checks.  Port, Process and HTTP.   
- First let's implement a HTTP Health Check for your test-app application.    
   
```execute-2
cf set-health-check test-app http --endpoint /
```
The output from the above command should look similiar to the following 
    
```
bash-5.0$ cf set-health-check test-app http --endpoint /
Updating health check type for app test-app in org system / space workshop as admin...
OK
TIP: An app restart is required for the change to take effect.
```
    
- Now to ensure our changes take place we must restart our application.
    
We must do this everytime we add a health check.   
      
```execute-2
cf restart test-app 
```

    
Our test application has multiple endpoints so we will want to make sure they are all monitored. 
Let's implement HTTP Health Check for the rest of our endpoints.   

Let's apply a health check for the /port endpoint
    
```execute-2
cf set-health-check test-app http --endpoint /port
```
    
- Now to ensure our changes take place we must restart our application.    

```execute-2
cf restart test-app 
```

Let's apply a health check for the /index endpoint

```execute-2
cf set-health-check test-app http --endpoint /index
```
- Now to ensure our changes take place we must restart our application.    

```execute-2
cf restart test-app 
```

Let's apply a health check for the /env endpoint

```execute-2
cf set-health-check test-app http --endpoint /env
```

- Now to ensure our changes take place we must restart our application.    

```execute-2
cf restart test-app 
```
      
2. Next let's configure the health check to monitor the port(s) our app is listening on. 

```execute-2
cf set-health-check test-app port
```

```
    bash-5.0$ cf set-health-check test-app port 
    Updating health check type for app test-app in org system / space workshop as admin...
    OK
    TIP: An app restart is required for the change to take effect.
```

- Now to ensure our changes take place we must restart our application.    

```execute-2
cf restart test-app 
```

3. Finally let's configure the health check to monitor our app's processes. 

```execute-2
cf set-health-check test-app process
```

```
    bash-5.0$ cf set-health-check test-app process
    Updating health check type for app test-app in org system / space workshop as admin...
    OK
    TIP: An app restart is required for the change to take effect.
```

- Now to ensure our changes take place we must restart our application.    . 
```execute-2
cf restart test-app 
```

<br/>

- Now let's try configuring a health check while we are creating a new instance of our test-app application.   

1.  Let's switch to our test-app repo. 

    ```execute-2
    cd /home/eduk8s/myApps/test-app
    ``` 
    
2.  Define an inital health check while pushing your applicaiton.   
    Let's set a HTTP health check with a timeout of 60 seconds.   
    
    ```execute-2
    cf push test-app-health -u http -t 60
    ```
    
3.  Success! Your new test app should be deployed with a default health check defined for it's "/" endpoint.

---

To learn more about configuring health checks please see the following: 
    
https://docs.pivotal.io/application-service/2-10/devguide/deploy-apps/healthchecks.html

