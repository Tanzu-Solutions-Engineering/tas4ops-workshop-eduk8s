### Goal

<br/>

BOSH Errands enable on demand execution of tasks within the deployment. 

This could be checking the status on a resource, adding a new user, running tests, or even when doing a `cf push` for an application! Let's inspect the errands of your current deployments.

<br/>

### List the errands of a deployment

<br/>

In the same terminal where you ssh'ed into the Ops Mgr VM (step 3 of this workshop):

1. List all of BOSH deployments  
  
   ```execute
   bosh deployments
   ```
  
   Get the name of a deployment from the output of the command above.

1. List the errands of the selected deployment with command the `bosh -d <deployment-name> errands` 
   
   ```execute
   DEPLOYMENT=$(bosh deployments --json | jq .Tables[0].Rows[0].name) &&
   bosh -d $DEPLOYMENT errands
   ```

<br/>

**Best Practice**

For TAS deployments, the execution of errands should be controlled through Ops Mgr web interface only.

Each release tile installed via Ops Manager has a "Errands" configuration option where errands can be enabled or disabled.

Enageld errands are executed automatically with the corresponding tile's process during an "Apply Changes" action in Ops Manager.

The section below is provided just for training purposes.

<br/>

### Run a BOSH Errand

<br/>

1. Run the CF release's smoke-test errand.

  ```execute
  DEPLOYMENT=$(bosh deployments --json | jq .Tables[0].Rows[0].name) &&
  bosh -d $DEPLOYMENT run-errand smoke_tests
  ```

  You should see something similar to the following:

   ```
   Using environment '192.168.1.11' as client 'ops_manager'

   Using deployment 'cf-a801abefab398f5d1a82'

   Task 166

   Task 166 | 22:49:04 | Preparing deployment: Preparing deployment
   ...
   ```

   Examine the Output, you will notice that the  `stdout` and `stderr` is separated into multiple sections, each one with its own execution status.

<br/>

---