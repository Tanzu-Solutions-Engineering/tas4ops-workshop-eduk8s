## Goal

Let's assume your application is having trouble communicating with another applicaiton instance.   
Let's see what steps we can take to get to a resolution.   

---

## Let's determine if a route is accessible from one app to another app or service.   

If no other apps are available for testing you can deploy a test app to test connectivity to our spring-music app

0. First change out of the current app's directory 

    ```execute-2
    cd ..
    ```

1. Next, let's clone our test-app repo. 
    ```execute-2
    git clone https://github.com/jrobinsonvm/test-app.git
    ```
    
2. Now let's deploy our test app.  Change directories to the test-app 
    ```execute-2
    cd test-app 
    ```
    
3. Change the name of your app to your team name. (Edit the manifest.yml file) 
  
    ```execute-2
    vi manifest.yml
    ```
    
4. Run "cf push" to deploy the app
    ```execute-2
    cf push
    ```
    
5. Run cf apps to view your newly deployed app.   
    ```execute-2
    cf apps
    ```
    
6. Let's get the GUID of our spring-music app.  Save this for later 

    ```execute-2
    cf app spring-music --guid
    ```
    
    Example Output: 

    ```
        bash-5.0$ cf app spring-music-fixme --guid
        8dac8193-ee26-44ec-81d8-de9753649be5
    ```
    
7. Let's get the index number of the instance of spring-music app we would like to debug. Also take note of the route assigned to the app.  Save this detail for later

   But before we do this, let's scale our app so that we can see multiple instances of it.
   
   Let's scale spring music up to 3 instances  
   
    ```execute-2
    cf scale spring-music -i 3
    ```
    
   Let's watch as our spring-music app is scaled from 1 to 3 instances.   
   
   ```execute-2
   watch -n 0.5 cf app spring-music
   ```
  
   Same command without watch enabled  
    
    ```execute-2
    cf app spring-music 
    ```
    
Example Output: 
   
        bash-5.0$ cf app spring-music-fixme
        Showing health and status for app spring-music-fixme in org system / space workshop as admin...

        name:              spring-music-fixme
        requested state:   started
        routes:            spring-music-fixme-active-roan-bn.cfapps.haas-236.pez.pivotal.io
        last uploaded:     Fri 29 Jan 03:02:41 UTC 2021
        stack:             cflinuxfs3
        buildpacks:        client-certificate-mapper=1.11.0_RELEASE container-security-provider=1.16.0_RELEASE java-buildpack=v4.26-offline-https://github.com/cloudfoundry/java-buildpack.git#e06e00b
                           java-main java-opts java-security jvmkill-agent=1.16.0_RELEASE open-jdk...

        type:           web
        instances:      15/35
        memory usage:   1024M
              state      since                  cpu     memory         disk           details
        #0    running    2021-01-29T03:03:04Z   0.4%    243.7M of 1G   183.9M of 1G   
        #1    running    2021-01-29T03:04:11Z   0.5%    226M of 1G     183.9M of 1G   
        #2    running    2021-01-29T03:04:11Z   0.3%    221.9M of 1G   183.9M of 1G   

8. In the command below replace the variables with your spring-music app's route, guid and instance index number. 
   
   (Save this command for later) 
    ```copy-and-edit
    curl <app.vmware.com>  -H "X-Cf-App-Instance":"YOUR-APP-GUID:YOUR-INSTANCE-INDEX"
    ```
    
9. Let's ssh into our test app 
    ```copy-and-edit
    cf ssh test-app
    ```
    
10. Now run the curl command we created earlier to send a request to the app.   
    You should see the html content of your web app endpoint now.   
    This proves that other apps within the same network should be able to successfully reach your spring-music app.   
    
    ```copy-and-edit
    curl <app.vmware.com>  -H "X-Cf-App-Instance":"YOUR-APP-GUID:YOUR-INSTANCE-INDEX"
    ```
    
  Example Output:
   
        vcap@4e04b087-7456-49f2-56e7-f6f0:~$ curl spring-music-fixme-active-roan-bn.cfapps.haas-236.pez.pivotal.io  -H "X-Cf-App-Instance":"8dac8193-ee26-44ec-81d8-de9753649be5:0"
        <!DOCTYPE html>
        <html xmlns="http://www.w3.org/1999/xhtml" class="en" ng-app="SpringMusic">
        <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="description" content="Spring Music">
        <meta name="title" content="Spring Music">
        <link rel="shortcut icon" href="favicon.ico">
        <title>Spring Music</title>

        <link rel="stylesheet" type="text/css" href="webjars/bootstrap/3.1.1/css/bootstrap.css">
        <link rel="stylesheet" type="text/css" href="css/app.css">
        <link rel="stylesheet" type="text/css" href="css/multi-columns-row.css">
        </head>
        </body>
        </html>


For additional details on troubleshooting your application's connectivity please see the url below.  
https://docs.pivotal.io/application-service/2-10/adminguide/troubleshooting-router-error-responses.html
