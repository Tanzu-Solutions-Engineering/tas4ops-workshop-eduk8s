### Goal

<br/>

Familiarization with Workshop Lab environment.

<br/>

### Workshop Lab Architecture: Tanzu Application Service

<img src="../images/Workshop_architecture1.png" alt="Workshop Lab Architecture" style="border:none;"/>

<br/>

### Using the TAS Operations Manager VM as a Jumpbox

<br/>

The TAS Operations Manager VM can be used as a jump box to access and inspect a TAS deployment infrastructure, given that it is usually deployed inside of the TAS infrastructure network along with the BOSH Director VM and that it contains PCF and BOSH management tools pre-installed (e.g. uaac and bosh CLI's). ([TAS Knowledge Base article](https://community.pivotal.io/s/article/Using-bosh-and-uaac-cli-to-inspect-and-manage-pivotal-cloud-foundry-from-an-ops-manager-vm)).

<br/>

### Part 1: Connect to the Ops Manager VM

<br/>

1. Provide TAS Ops Manager VM's fully-qualified domain name from provided pre-workshop email

1. Provide corresponding ssh private key content from provided pre-workshop email

1. SSH into the jumpbox VM of your Lab environment

    ```execute
    ssh -o "StrictHostKeyChecking no" ubuntu@ubuntu-{{ LAB_SLOT_ID }}.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}
    ```

    Type in the password for the environment provided by your instructor.


1. Once logged in to the jumpbox, SSH into the Ops Manager VM of your environment

    ```execute
    ssh -o "StrictHostKeyChecking no" ubuntu@opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}
    ```

1. Test connectivity with the Ops Mgr web interface

    [Click here to launch the Ops Manager user interface](https://opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }})

    Login with credentials: `admin` / `<the same password provided by your instructor>`

1. Configure an alias for BOSH commands  

    The BOSH CLI requires several parameters to run commands, such as the targeted BOSH Director environment and credentials for authentication. 

    To make that easier, you can define an alias containing all of those parameters. And the Ops Manager web interface makes the content for that alias readily available in its credentials tab page.

    From the Ops Mgr web UI > Bosh Tile > Credentials tab ([link](https://opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}/api/v0/deployed/director/credentials/bosh_commandline_credentials)), copy the contents of "Bosh Command line Credentials" and then define the alias with the following command:  

    ```copy-and-edit
    alias bosh="<command-from-ops-mgr-panel>"
    ```

    Example: 

    `alias bosh="BOSH_CLIENT=ops_manager BOSH_CLIENT_SECRET=... BOSH_CA_CERT=/var/tempest/workspaces/default/root_ca_certificate BOSH_ENVIRONMENT=192.168.1.11 bosh "`


<br/>

### Part 2: Inspect the Bosh Director environment

<br/>

1. Check which BOSH deployments exist 

    ```execute
    bosh deployments
    ```

1. Check for BOSH managed VMs for the existing deployments

    ```execute
    bosh vms
    ```

<br/>
---