### Goal

BOSH runs software systems on virtual machines referred to as BOSH instances. 

Since BOSH deploys instances behind firewalls, without public IPs, and with secured ssh keys, it can be hard to get access to these machines via the typical SSH client. Lets explore how to access these machines via the BOSH CLI directly.

<br/>

---

### Part 1: Inspect the manifest file of a BOSH deployment

In the same terminal where you ssh'ed into the Ops Mgr VM (step 3 of this workshop):

1. List all of BOSH deployments  
  
   ```execute
   bosh deployments --column name
   ```
  
   Get the name of a deployment from the output of the command above.

2. Inspect the full manifest file of the selected deployment with the `bosh manifest -d <name-of-deployment>` command   

   ```execute
   bosh manifest -d $(bosh deployments --json | jq .Tables[0].Rows[0].name)
   ```

<br/>

---

### Part 2: Accessing a deployed instance

1. Find the instance we want to SSH into by listing all instances in the selected deployment from Part 1. Use command `bosh -d <name-of-deployment> instances`.

    ```execute
    bosh -d $(bosh deployments --json | jq .Tables[0].Rows[0].name) instances
    ```

    - You should see something like the following, note down the `instance_name/uuid`:  

  ```bash
    Using environment '192.168.1.11' as client 'ops_manager'

    Task 160. Done

    Deployment 'cf-a801abefab398f5d1a82'

    Instance                                                            Process State  AZ       IPs           Deployment
    backup_restore/f256d66b-d083-4f9d-8efc-2e2726c4b890                 running        pas-az1  192.168.2.23  cf-a801abefab398f5d1a82
    clock_global/6420e0c7-c2c3-43a1-82e8-f604efc52b87                   running        pas-az2  192.168.2.33  cf-a801abefab398f5d1a82
    clock_global/82c568e7-2c3b-439f-87a5-7689573892be                   running        pas-az1  192.168.2.32  cf-a801abefab398f5d1a82
    cloud_controller/8a7e1516-d815-4621-958a-d2f76ed06c83               running        pas-az2  192.168.2.30  cf-a801abefab398f5d1a82
    cloud_controller/f2c62d99-c205-43bc-bfc2-41aa5cc3b5f8               running        pas-az1  192.168.2.29  cf-a801abefab398f5d1a82
    cloud_controller_worker/1fee20d4-7c4c-4a13-ac0c-e015dfda6492        running        pas-az1  192.168.2.34  cf-a801abefab398f5d1a82
    cloud_controller_worker/4bf5ac9a-b8ca-45f6-a385-ea0d4a3340b8        running        pas-az2  192.168.2.35  cf-a801abefab398f5d1a82
    ...
    ```

   By the way, you can also check the vitals information of the instances with the `--vitals` option added to the command above.

   ```execute
      bosh -d $(bosh deployments --json | jq .Tables[0].Rows[0].name) instances --vitals
    ```

   This option will also show each instance's load, cpu and memory information.

   <br/>

1. Using the `instance_name/uuid` utilize the BOSH CLI to access the instance via the `ssh` sub-command.   
   For example `bosh -d <name-of-deployment> ssh <instance-name-and-id>`

    ```execute
    DEPLOYMENT=$(bosh deployments --json | jq .Tables[0].Rows[0].name) && 
    bosh -d $DEPLOYMENT ssh backup_restore
    ```

    - If successful you should now be inside the instance and have full `root` access via `sudo su`.

<br/>

---
