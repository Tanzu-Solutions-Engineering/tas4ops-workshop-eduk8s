## Goal

Pivotal Healthwatch is a service for monitoring and alerting on the current health, performance, and capacity of your TAS environment.  

In this lab we will look at some key performance indicators which helps drive decisions around capacity and scaling.  

We will also role play a scenario where our diego cells are experiencing unusual high utilization of its resources.  
We must determine what is causing this issue.   

---


## Key Capacity Scaling Indicators  

- VMware provides these indicators to operators as general guidance for capacity scaling. Each indicator is based on platform metrics from different components. This guidance is applicable to most TAS for VMs deployments. VMware recommends that operators fine-tune the suggested alert thresholds by observing historical trends for their deployments.

### Diego Cell Capacity Scaling Indicators

There are three key capacity scaling indicators VMware recommends for a Diego Cell:

- Diego Cell memory capacity is a measure of the percentage of remaining memory capacity. 

- Diego Cell disk capacity is a measure of the percentage of remaining disk capacity. 

- Diego Cell container capacity is a measure of the percentage of remaining container capacity. 



  For more detail on key capacity scaling indicator please see the following doc.  
  https://docs.pivotal.io/application-service/2-10/overview/monitoring/key-cap-scaling.html#cell-container
  
 
  
---

  ### Let's take a look at what's inside of Healthwatch  

  Please refer to login instructions which were sent prior to the lab.  

  We will use your UAA Credentials to log into Healthwatch.  

  You can obtain your UAA Credentials from Ops Manager.  

  [Click here to launch the Ops Manager user interface](https://opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }})

  Login with credentials: `admin` / `<the same password provided by your instructor>`


  From the Ops Mgr web UI > TAS Tile > Credentials tab

  ([link](https://opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}/api/v0/deployed/products/{{ LAB_CF_DEPLOYID }}/credentials/.uaa.admin_credentials)), please save the password for use in the next step.    


  To access Healthwatch's UI navigate to  ([link](https://healthwatch.run.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }})   and log in.  

  <br/>

---

  Once logged into Healthwatch.  Take a quick glance at the main dashboard.   


  The dashboard shows a set of panels that surface warning (orange) and critical (red) alerts for different parts of the system. 
  Behind the scenes, the healthwatch-alerts app watches metrics to evaluate the health of the platform, and each metric belongs to a category covered by 
  one of the display panels. When a metric reaches a configured alert threshold, an alert fires. The dashboard indicates the alert by changing the color of its 
  category panel to orange or red, depending on the alert severity. Additionally, the alert displays in the Alert Stream panel on the right side of the dashboard.


  Now let's identify any bad actors or problem applications.   

  At times you will want to investigate why a diego cell's resources are being consumed or over allocated.   

  Our assumption here is that a "heavy" application or a combination of applications are causing significant load and affecting one or more of our diego cells.   
  To investigate further let's walk through health watch to identify the affected diego cell.   


1.  From the dashboard view, navigate to your left panel and select the 2nd tab called Foundation and select All Jobs.

    Dashboard --> Foundation --> All Jobs. 
    
    Direct link here: 
    
    ```copy-and-edit
    https://healthwatch.run.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}/jobHealth/details
    ```
    
2. Now toggle the option to "Only Show Errors" off.   (Default view will only show errors) 

   We want to view all jobs regardless of state. 
   
   You will be presented with a number of jobs which represent our two deployments (healthwatch and TAS/PAS)
   

3. Now select the job for diego_cell.  
   
   This view will give you a glance at how your diego cells are preforming.   
   
   Notice that we have 3 diego cells which show up under Metric Summary and Instance ID.   
   
   From this view we can gather high level statistics on how our diego cells are preforming. 
   
   
      
4. Take a glance at all of the graphs from this view.  
 
   From this view we can gather high level statistics about how our diego cells are preforming. 
     
   
   #### CPU
   
   The CPU utilization which is shown is a percentage of the total available memory across all cells/Diego VMs.  
        
   Investigate the cause of the spike. If the cause is a normal workload increase, then scale up the affected jobs.


   #### Memory 
   
   The Memory utilization shown is the total remaining available memory across all cells.  
   
   Responses to memory usage can vary depending on the type of workload or job that is causing the spike.  


   #### System Disk 
   
   The System Disk utilization is the amount of space available across the system partition of our diego cells.  

   Investigate what is filling the jobs system partition. This partition should not typically fill because BOSH deploys jobs to use ephemeral and persistent disks.


   #### Persistent Disk 
   
   The Persistent disk utilization is the amount of space available across the persistent partition of our diego cells.  
   
   Use bosh to view jobs on affected deployments. Determine cause of the data consumption, and, if appropriate, increase disk space or scale out affected jobs.
   
   
   #### Ephemeral Disk 
   
   The ephemeral disk utilization is the amount of space availabel across the ephemeral partition of our diego cells.   

   Use bosh to view jobs on affected deployments. Determine cause of the data consumption, and, if appropriate, increase disk space or scale out affected jobs.

   ---
      

5. Notice that we have 3 diego cells which are listed under Metric Summary.

   Their names can be seen under the category for Instance ID.   
     
   Let's copy the Instance ID of the diego cell which shows the highest load on CPU and save this for later.   
      
   
      

6. Let's prepare to SSH into this diego cell so that we can continue our investigation.       

   If you lost connectivity to the jumpbox from our prior labs you will need to SSH again to our Jumphost.   
   Please use the instructions which were provided prior to the lab starting.   

   ```execute
   ssh -o "StrictHostKeyChecking no" ubuntu@ubuntu-{{ LAB_SLOT_ID }}.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}
   ```

   Once inside the jumphost we will need to SSH to our Ops Manager.  

   ```execute
   ssh -o "StrictHostKeyChecking no" ubuntu@opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}
   ```


   Once inside of Ops Manager we will need to authenticate.


   From the Ops Mgr web UI > Bosh Tile > Credentials tab ([link](https://opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}/api/v0/deployed/director/credentials/bosh_commandline_credentials)), copy the contents of "Bosh Command line Credentials" and then define the alias issue the following command:  

   ```copy-and-edit
   alias bosh="<command-from-ops-mgr-panel>"
   ```

   Now that we have setup our environment with our BOSH Credentials we can now SSH to our diego cell.

   To ssh to our diego cells or any bosh deployed VM we will need to know it's corresponding deployment ID.   

   The deployment ID can be seen from our previous healthwatch tab which shows the Diego Cell Job.       The Deployment ID is shown in the top left corner of the page.   

   It will begin with the letters "cf-" following its guid.   

   Example: 

   ```
   Foundation / All Jobs / cf-a9f06a06db4ae96934f2
   ```
   
   You can also obtain the deployment ID by running the following command.   

   ```execute
   bosh vms
   ```
   
   The deployment ID can be seen above the Instance/VM details.   
   
   
   
      
7. SSH to our diego cell using it's instance name and deployment ID.  

   ```copy-and-edit
   bosh ssh -d <cf-*******>  <diego_cell/*********>
   ```
      
8. Now inside of the diego cell, let's use cfdot to output some useful information.   

   Let's export some values to a variable that we can use later.   
   
   ```execute
   CELL_IP=$(ip route  get 1 | awk '{print $NF;exit}')
   ```
   
   Now run the following command to gather all of the applications running on our diego cell.  
   
   ```execute
   cfdot actual-lrp-groups | grep "\"$CELL_IP\"" | jq
   ```


9. The last command outputs a lot of information, which can be overwhelming if you're looking for something specific.
   Let's use jq to ouput only the information we need.  ( ie. Our Application GUIDs ) 
   
   The following command will list the application guid's running in the diego cell.   
   
   ```copy-and-edit
   cfdot cell-state <diego's InstanceID> | jq -r '. | "\ndiego_cell:", .cell_id, "\n", "App-Guids:", .LRPs[].process_guid[0:36]'
   ```
   
   We can use this detail to lookup the names of these applications using our CF CLI.    

   
10. Let's select the first guid from the list to determine it's application name.

    Run the following command to identify application names while only providing its guid.  
      
   ```copy-and-edit
   cf curl /v2/apps/<guid>/stats | grep name | uniq
   ```
   
11. Using the above step can be very time consuming. 
    Let's create a super simple script to automate this step. 
   
    First, let's copy the list of GUIDs from our prior cfdot command.   
    We will copy and paste the guids only to a new temporary file.   
   
    Create file named "tmpfile" using nano
   
    ```execute-2
    nano tmpfile
    ```
   
    Now paste the list of guids to your file. 
   
    To save and exit your file press and hold "ctrl+x" then type "y" to save.   
   
    Your file should look like the following when complete.   
   
    Example: 
    ```
    [~/myApps/broken-spring-music] $ cat tmpfile 
    fac3c1a7-1f1c-43fb-bccb-6dd1250e5658
    0586bd28-beea-436f-aa3f-ae3c6c2358bf
    a8af73e5-0a86-42c1-822d-d38ca12e9fe2
    0586bd28-beea-436f-aa3f-ae3c6c2358bf
    3d827b3b-c47a-46d1-a0e0-34d5edbd024f
    56f7ac14-78d9-4113-86fb-0d0b6c95d769
    a1d67487-c25e-4538-b8b4-a4dc8ae73042
    9e4200eb-ce25-4e21-a5f2-993ce0dd7207
    e51e41b5-4799-412f-b6ed-41f3d3a2247a
    fd941736-bd3e-4428-8d66-5c80d25f1638
    05fe88e4-f7fb-41b8-b022-5291ed74d188
    be76e688-be58-46d3-b872-4e66d9e6aa78
    ff89fb10-aac9-479d-9ce5-ab63e64dfafc
    ebd92ec2-a6e9-48c7-804b-414e27af9d8e
    b43ef658-fd3a-4950-b415-4a9e78423448
    [~/myApps/broken-spring-music] $ 
    ```
      
    Once your tmp file has been created with your list of guids you will now need to run the above cf command as a for loop. 
   
    ```execute-2
    for i in $(cat tmpfile); do      echo $(cf curl /v2/apps/$i/stats | grep name | uniq); done
    ```
   
    Example Output: 
    ```
    [~/myApps/broken-spring-music] $ for i in $(cat tmpfile); do      echo $(cf curl /v2/apps/$i/stats | grep name | uniq); done
    "name": "app-usage-scheduler",
    "name": "apps-manager-js-green",
    "name": "p-invitations-green",
    "name": "apps-manager-js-green",
    "name": "nfsbroker",
    "name": "opsmanager-health-check",
    "name": "app-usage-server",
    "name": "autoscale",
    "name": "healthwatch-api",
    "name": "healthwatch-ingestor",
    "name": "cf-health-check",
    "name": "notifications-ui",
    "name": "smbbroker",
    "name": "bosh-health-check",
    "name": "healthwatch",
    ```
    
12. From the output above we can begin investigating each app to determine if our spike in utilization was caused by normal activity or by a problematic application.


  You will want to check the logs of these applications to determine if something is causing the applications to behave inappropriately.  
    
    

  Now look for our spring-music app in this list to determine if it's the problematic application.   
    
    
  Just for kicks... 
  
  If you do not see your spring-music app, please scale your application instances to at least 3.   
      
  ```copy-and-edit
  cf scale spring-music -i 3
  ```
   
   
   Now re-run steps 9 and 11 to see if your spring-music app was deployed to the diego cell you are currently working within.   
   
   
   
   ---
    
  For more detail on key capacity scaling indicators please see the following doc.  

  https://docs.pivotal.io/application-service/2-10/overview/monitoring/key-cap-scaling.html#cell-container

  For more detail on healthwatch please see the following doc. 

  https://docs.pivotal.io/healthwatch/1-8/metrics.html#free-disk-chunks
    
    
    
