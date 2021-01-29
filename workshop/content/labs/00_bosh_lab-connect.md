## Goal

Familiarization with Workshop Lab environment.

## Workshop Lab Architecture: Tanzu Application Service

<img src="../images/Workshop_architecture1.png" alt="Workshop Lab Architecture"/>

### Using the TAS Operations Manager VM as a Jumpbox

- The TAS Operations Manager VM can be used as a jump box to access and inspect a TAS deployment infrastructure, given that it is usually deployed inside of the TAS infrastructure network along with the BOSH Director VM and that it contains PCF and BOSH management tools pre-installed (e.g. uaac and bosh CLI's).
- [TAS Knowledge Base article](https://community.pivotal.io/s/article/Using-bosh-and-uaac-cli-to-inspect-and-manage-pivotal-cloud-foundry-from-an-ops-manager-vm)

## Part 1: Connect to the Ops Manager VM

1. Provide TAS Ops Manager VM's fully-qualified domain name from provided pre-workshop email

1. Provide corresponding ssh private key content from provided pre-workshop email

1. SSH into the jumpbox VM of your Lab environment

    ```execute
    ssh ubuntu@ubuntu-236.haas-236.pez.pivotal.io
    ```
1. Once into the jumpbox, SSH into the Ops Manager VM of your environment

    ```execute
    ssh ubuntu@opsmgr-01.haas-236.pez.pivotal.io
    ```

1. Test connection to Ops Mgr web interface

    Hardcoded:  
    ```dashboard:create-dashboard
    name: OpsMgr
    url: https://opsmgr-01.haas-236.pez.pivotal.io
    ```

    With LAB_SLOT_ID:
    ```dashboard:create-dashboard
    name: OpsMgr
    url: https://opsmgr-01.haas-{{ LAB_SLOT_ID }}.pez.pivotal.io
    ```

    With ENV_LAB_SLOT_ID:
    ```dashboard:create-dashboard
    name: OpsMgr
    url: https://opsmgr-01.haas-{{ LAB_SLENV_LAB_SLOT_IDOT_ID }}.pez.pivotal.io
    ```


1. Configure alias for BOSH commands  
   - From the Ops Mgr web UI > Bosh Tile > Credentials tab, copy the contents of <"Bosh Commandline Credentials"  
   - `alias bosh="<data-from-previous-step>"`

## Part 2: Inspect the Bosh Director environment

1. Check which BOSH deployments exist 

    `bosh deployments`

1. Check for BOSH managed VMs for the existing deployments

    `bosh vms`

