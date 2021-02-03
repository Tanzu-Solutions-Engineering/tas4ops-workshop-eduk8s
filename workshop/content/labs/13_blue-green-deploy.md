## Goal

Blue-green deployment is a technique that reduces downtime and risk by running two identical production environments called Blue and Green.  
For this lab we will investigate how to update your applications without any downtime.   

---


## Implement a rolling update of your application with zero downtime.
   - Let's try implementing this as a manual step first.   

When using this method, only one of the environments are live, with the live environment serving all production traffic. 
For this example, Blue is currently live and Green is idle.

As you prepare a new version of your software, deployment and the final stage of testing takes place in the environment that is not live: in this example, Green. 
Once you have deployed and fully tested the software in Green, you switch the router so all incoming requests now go to Green instead of Blue. Green is now live, and Blue is idle.
This technique can eliminate downtime due to app deployment. 

In addition, blue-green deployment reduces risk: 
if something unexpected happens with your new version on Green, you can immediately roll back to the last version by switching back to Blue.
     

1.  First let's navigate back to our test-app's git repo.

    ```execute-2
    cd /home/eduk8s/myApps/test-app
    ```
    
2. Let's first push our test-app and name it as Blue.   
   
    ```execute-2
    cf push Blue 
    ```
    
    We could have also specified the sub domain name of the route.  
    
    ```copy-and-edit
    cf push Blue -n my-route-subdomain
    ```
    
    Now run cf apps to see your newly deployed blue app and its route. 
    
    ```execute-2
    cf apps
    ```
    
    Now try viewing your app from your web browser to ensure its working as expected.  
    
3. Let's now push our updated test-app.  
   (Lets assume we made all the necessary changes to our app) 
   
   ```execute-2
   cf push Green
   ```
   
   We could have also specified the sub domain name of the route.  
    
   ```copy-and-edit
   cf push Green -n my-route-subdomain-tmp
   ```
   
   Try running cf apps again to see the new app and its route.  
   
   ```execute-2
   cf apps
   ```
   
4. Now that both apps are up and running, switch the router so all incoming requests go to both the Green app and the Blue app. 
   Do this by mapping the original URL route to the Green app using the cf map-route command.
   
   ```copy-and-edit
   cf map-route Green cfapps.haas-{{ LAB_SLOT_ID }}.pez.pivotal.io -n <subdomain of live route>
   ```
   
   Example Output: 
   ```
         [~/myApps/test-app] $ cf map-route Green cfapps.haas-236.pez.pivotal.io -n blue-tired-gnu-gl
      Creating route blue-tired-gnu-gl.cfapps.haas-236.pez.pivotal.io for org workshop / space test as admin...
      OK
      Route blue-tired-gnu-gl.cfapps.haas-236.pez.pivotal.io already exists
      Adding route blue-tired-gnu-gl.cfapps.haas-236.pez.pivotal.io to app Green in org workshop / space test as admin...
      OK
   ```
   
    Now let's run cf apps to see if your Green app was mapped to the new subdomain.    
    
    ```execute-2
    cf apps
    ```

5. The last step in this process will unmap our old app from the route.
   (This will ensure all new requests to my test-app will resolve to our new version with zero downtime) 

    ```copy-and-edit
    cf unmap-route Blue cfapps.haas-{{ LAB_SLOT_ID }}.pez.pivotal.io -n <subdomain of Live route>
    ```

   Example Output
   
    ```
    [~/myApps/test-app] $ cf unmap-route Blue cfapps.haas-236.pez.pivotal.io -n blue-tired-gnu-gl
    Removing route blue-tired-gnu-gl.cfapps.haas-236.pez.pivotal.io from app Blue in org workshop / space test as admin...
    OK
    ```
    
    Now let's run cf apps to see if your Blue app was un-mapped from the old subdomain.    
    
    ```execute-2
    cf apps
    ```
  
  
- Rolling updates are possible without manual intervention.   


1.  First let's navigate back to our test-app's git repo.

    ```execute-2
    cd /home/eduk8s/myApps/test-app
    ```
    
2.  Let's scale our test-app to ensure it's made highly available.    

     ```execute-2
     cf scale test-app -i 3
     ```

3.  Let's assume we have new updates to release for our test-app however we want to use something a bit more out of the box and automated.  

    For this workshop we are using CF CLI v6 which requires the following command to initiate a rolling app deployment. 
    
     ```execute-2
     cf v3-zdt-push test-app
     ```
     
    CF CLI v7 would use the following command: 
    
     ```copy-and-edit
     cf push APP-NAME --strategy rolling
     ```
     
4.  Let's view our app and check the timestamps which should show different start times for your app.     
    
     ```execute-2
     cf app test-app
     ```    
  
     
    

## This process could also be automated via CF Plugins.  

Cloud Foundry community members have written a plugin to automate the blue-green deployment process:

BlueGreenDeploy: cf-blue-green-deploy is a plugin, written in Go, for the Cloud Foundry Command Line Interface (cf CLI) that automates a few steps involved in zero-downtime deploys.

https://plugins.cloudfoundry.org/#blue-green-deploy
