### Goal

<br/>

In order for BOSH to communicate with specific infrastructures (GCP/AWS/vSphere/etc.) we abstract these details into a BOSH cloud-config. 

Lets inspect the Cloud Config defined in the BOSH director.

<br/>

### Part 1: Inspecting the Cloud Config

<br/>

In the same terminal where you ssh'ed into the Ops Mgr VM (step 3 of this workshop), inspect the cloud config with the following command:

```execute
bosh cloud-config
```

The command output should be the YAML content currently defined for the BOSH Director's cloud config.

Inspect the output and find the contents for the following main sections:

```
- azs
- disk_types
- networks
- vm_types
```

Then visit the [Ops Manager web interface](https://opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}), click on the "Bosh Director tile" configuration and compare it with the inspected cloud-config content obtained in the previous step.

<br/>

---
