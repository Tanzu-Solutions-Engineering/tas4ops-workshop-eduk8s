## Goal

Learn how to inspect BOSH tasks as updates are applied to deployments.

## Prerequisites

You are in the [jumpbox and logged into BOSH](/demos/00_lab-connect/).

## Inspect BOSH tasks when changes are applied to BOSH deployments

### Change the number of Compilation Jobs VMs

1. Access the Ops Mgr web interface > BOSH Director tile > Resource Config panel

1. Find the "Master Compilation Job" job and increase its number of INSTANCES by 1

1. Click the SAVE button

1. Go back to Ops Mgr HOME page and click the "Review Pending Changes" button

1. Click the "Apply Changes" Button


###  Monitor the logs of tasks

After you trigger the Apply Changes process in Ops Mgr, the Apply Changes log view is displayed.
The output of each section of this window is basically the output of a distinct BOSH task output.
To inspect those individual task log files with the BOSH CLI, from the jumpbox shell:

1. Issue 'bosh tasks` commands to visualize the current tasks being executed

1. To look at the logs of a task, issue the following command: `bosh task <task-ID>`

---