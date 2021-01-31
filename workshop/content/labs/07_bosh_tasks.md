### Goal

<br/>

Learn how to inspect BOSH tasks as updates are applied to deployments.

<br/>

### Inspect BOSH tasks when changes are applied to BOSH deployments

<br/>

#### Change the number of Compilation Jobs VMs

<br/>

1. Access the Ops Mgr web interface > BOSH Director tile > Resource Config panel

1. Find the "Master Compilation Job" job and increase its number of INSTANCES by 1

1. Click the SAVE button

1. Go back to Ops Mgr HOME page and click the "Review Pending Changes" button

1. Click the "Apply Changes" Button

<br/>

####  Monitor the logs of tasks

<br/>

After you trigger the Apply Changes process in Ops Mgr, the Apply Changes log view is displayed.

The output of each section of this window is basically the output of a distinct BOSH task output.

To inspect those individual task log files with the BOSH CLI, in the same terminal where you ssh'ed into the Ops Mgr VM (step 3 of this workshop):

1. Issue 'bosh tasks` commands to visualize the current tasks being executed

   ```execute
   bosh tasks
   ```

1. To look at the logs of a task, issue the following command: `bosh task <task-ID>` or `bosh task` to look at the logs of one under execution (if any).

   ```execute
   bosh task
   ```

<br/>

---