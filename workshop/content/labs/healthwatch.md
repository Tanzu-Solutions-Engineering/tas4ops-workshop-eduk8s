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
