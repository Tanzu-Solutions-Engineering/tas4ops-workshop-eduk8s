## Goal

Familiarization with Workshop Lab environment.

## Workshop Lab Architecture: Tanzu Application Service

<img src="/images/Workshop_architecture1.png" alt="Workshop Lab Architecture"/>

### Using the TAS Operations Manager VM as a Jumpbox

- The TAS Operations Manager VM can be used as a jump box to access and inspect a TAS deployment infrastructure, given that it is usually deployed inside of the TAS infrastructure network along with the BOSH Director VM and that it contains PCF and BOSH management tools pre-installed (e.g. uaac and bosh CLI's).
- [TAS Knowledge Base article](https://community.pivotal.io/s/article/Using-bosh-and-uaac-cli-to-inspect-and-manage-pivotal-cloud-foundry-from-an-ops-manager-vm)

## Part 1: Connect to the Ops Manager VM

1. Provide TAS Ops Manager VM's fully-qualified domain name from provided pre-workshop email

2. Provide corresponding ssh private key content from provided pre-workshop email

3. SSH into the OpsMgr VM

    `ssh -i ~/.ssh/haas.key ubuntu@<opsmgr-fqdn>`   e.g. opsmgr-01.haas-236.pez.pivotal.io

4. Configure alias for BOSH commands  
   - From the Ops Mgr web UI > Bosh Tile > Credentials tab, copy the contents of <"Bosh Commandline Credentials"  
   - `alias bosh="<data-from-previous-step>"`

## Part 2: Inspect the Bosh Director environment

5. Check which BOSH deployments exist 

    `bosh deployments`

6. Check for BOSH managed VMs for the existing deployments

    `bosh vms`

