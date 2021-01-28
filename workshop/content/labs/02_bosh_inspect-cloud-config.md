## Goal

In order for BOSH to communicate with specific infrastructures (GCP/AWS/vSphere/etc.) we abstract these details into a BOSH cloud-config. 
Lets inspect the Cloud Config defined in the BOSH director.

## Part 1: Inspecting the Cloud Config

After you [connect to your Lab jumpbox](/demos/00_lab-connect/), inspect the cloud config with the following command:

```
bosh cloud-config
```

The command output should be the YAML content currently defined for the BOSH Director's cloud config.

Inspect the output and find the contents for the following main sections:

- azs
- disk_types
- networks
- vm_types

Then visit the corresponding environment's Ops Manager web interface, click on the "Bosh Director tile" configuration and compare it with the inspected cloud-config content obtained in the previous step.

---