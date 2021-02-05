## Goal

Pivotal Healthwatch is a service for monitoring and alerting on the current health, performance, and capacity of your TAS environment.  

In this lab we will look at key performance indicators which helps drive decisions around capacity and scaling.    

---


## Key Capacity Scaling Indicators  

- VMware provides these indicators to operators as general guidance for capacity scaling. Each indicator is based on platform metrics from different components. This guidance is applicable to most TAS for VMs deployments. VMware recommends that operators fine-tune the suggested alert thresholds by observing historical trends for their deployments.

### Diego Cell Capacity Scaling Indicators

There are three key capacity scaling indicators VMware recommends for a Diego Cell:

- Diego Cell memory capacity is a measure of the percentage of remaining memory capacity. 

- Diego Cell disk capacity is a measure of the percentage of remaining disk capacity. 

- Diego Cell container capacity is a measure of the percentage of remaining container capacity. 

---

### Let's take a look at what's inside of Healthwatch  

Please refer to login instructions which were sent prior to the lab.  

We will use your UAA Credentials to log into Healthwatch.  

You can obtain your UAA Credentials from Ops Manager.  

[Click here to launch the Ops Manager user interface](https://opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }})

Login with credentials: `admin` / `<the same password provided by your instructor>`


From the Ops Mgr web UI > TAS Tile > Credentials tab

([link](https://opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}/api/v0/deployed/products/{{ LAB_CF_DEPLOYID }}/credentials/.uaa.admin_credentials)), please save the password for use in the next step.    


Now navigate to  ([link](https://healthwatch.run.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}   and log in.  

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
    ([link](https://healthwatch.run.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}/jobHealth/details
    ```
    
2. Now toggle the option to "Only Show Errors" off.   (Default view will only show errors) 

   We want to view all jobs regardless of state. 
   
   You will be presented with a number of jobs which represent our two deployments (healthwatch and TAS/PAS)
   

3. Now select the job for diego_cell.  
   
   This view will give you a glance at how your diego cell's are preforming.   
   
   Notice that we have 3 diego cells which show up under Metric Summary and Instance ID.   
   
   From this view we can gather high level statistics on how our diego cell's are preforming. 
   
   
      
4. Notice that we have 3 diego cells which show up under Metric Summary.

   Their names can be seen under the category for Instance ID.   
   
   From this view we can gather high level statistics about how our diego cell's are preforming. 
   
   Let's copy the Instance ID of the diego cell which shows the highest load on CPU.  
   

5. Let's prepare to SSH into this diego cell so that we can continue our investigation.       

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
   
   The deployment ID can be seen from our previous healthwatch tab which shows the Diego Cell Job.   
   The Deployment ID is shown in the top left corner of the page.   
   
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
   
   
   
      
6. SSH to our diego cell using it's instance name and deployment ID.  

   ```copy-and-edit
   bosh ssh -d <cf-*******>  <diego_cell/*********>
   ```
      
7. Now inside of the diego cell, let's use cfdot to output some useful information.     
   
   The following command will list the application guid's running in the diego cell.   
   With this detail we can lookup the names of these applications using CF CLI.    
   
   ```copy-and-edit
   cfdot cell-state <diego's InstanceID> | jq -r '. | "\ndiego_cell:", .cell_id, "\n", "App-Guids:", .LRPs[].process_guid[0:36]'
   ```
   
8. Let's use the guids from our previous step to lookup our application names.        
      
   ```copy-and-edit
   cfdot cell-state <diego's InstanceID> | jq -r '. | "\ndiego_cell:", .cell_id, "\n", "App-Guids:", .LRPs[].process_guid[0:36]'
   ```
  

