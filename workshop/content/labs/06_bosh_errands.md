## Goal

BOSH Errands enable on demand execution of tasks within the deployment. This could be checking the status on a resource, adding a new user, running tests, or even `cf push`ing an application! Let's inspect the errands of your current deployments.

## List the errands of a deployment

1. Login to [the jumpbox and into BOSH](/demos/00_lab-connect/).

2. List all of BOSH deployments  
  
   `bosh deployments`   
  
   Get the name of a deployment from the output of the command above.

3. List the errands of the selected deployment  
   
   `bosh -d <deployment-name> errands


### Best Practice

For TAS deployments, the execution of errands should be controlled through Ops Mgr web interface only.

Each release tile installed via Ops Manager has a "Errands" configuration option where errands can be enabled or disabled.

Enageld errands are executed automatically with the corresponding tile's process during an "Apply Changes" action in Ops Manager.

The section below is provided just for training purposes.


## Run a BOSH Errand

1. Run the CF release's smoke-test errand.

  ```bash
   bosh -d <cf-deployment-name> run-errand smoke_tests
  ```

  - You should see something similar to the following:
```
Using environment '192.168.1.11' as client 'ops_manager'

Using deployment 'cf-a801abefab398f5d1a82'

Task 166

Task 166 | 22:49:04 | Preparing deployment: Preparing deployment
...
```

Examine the Output, you will notice that the  `stdout` and `stderr` is separated into multiple sections, each one with its own execution status.

---