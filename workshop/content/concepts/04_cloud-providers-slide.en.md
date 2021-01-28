
## Cloud Provider Interface (CPI)

- The bosh director uses the CPI to interact with an IaaS to create and manage stemcells, VMs, and disks. 
- The CPI abstracts infrastructure differences from the rest of BOSH.
- The CPI is a command line executable that can be called to perform any of the actions below 
- CPIs are typically maintained by the IaaS provider 
- https://bosh.io/docs/cpi-api-v2/
- https://github.com/cloudfoundry/bosh-cli/blob/master/docs/architecture.md#deploy-command-flow

<img src="/images/Bosh_IaaS-support.png" alt="Bosh IaaS support"/>

--- 

## BOSH Component Architecture (Simplified) 

<img src="/images/Bosh_CPI_architecture.png" alt="Bosh CPI"/>

---

## How do I abstract the cloud away?

- The specific details about the size of the servers is specific to each cloud infrastructure. 

- Take the makeup of a VM as an example:  
  - On vSphere, you will want to specify the explicit allocation of CPUs, RAM, and ephemeral disk.   
  - On Amazon Web Services you might choose between a list of Instance Types such as m4.large or t2.medium.   
  - On GCP you choose a Machine Type from a list of predefined sizes which are slightly different than Amazon such as n1-standard-1.

- The Cloud Config is where BOSH takes specific infrastructure details to configure the CPI being used while abstracting the complexities away from the software you are deploying.

--- 

## Example GCP cloud-config.yml

```
azs:
- name: z1
  cloud_properties: {zone: us-central1-a}
- name: z2
  cloud_properties: {zone: us-central1-f}

vm_types:
- name: default
  cloud_properties:
    machine_type: n1-standard-4
    root_disk_size_gb: 20
    root_disk_type: pd-ssd

disk_types:
- name: default
  disk_size: 3000

networks:
- name: default
  type: manual
  subnets:
  - range:   10.0.0.0/16
    gateway: 10.0.0.1
    dns:     [8.8.8.8, 8.8.4.4]
    reserved: [10.0.0.0-10.0.0.10]
    azs:     [z1, z2]
    cloud_properties:
      ephemeral_external_ip: true
      subnetwork_name: bosh-1-sub
      network_name: bosh-1-net
      ephemeral_external_ip: true
      tags: [bosh]
- name: vip
  type: vip

compilation:
  workers: 3
  reuse_compilation_vms: true
  az: z1
  vm_type: default
  network: default
```
--- 

## Recommended activity

- View and try out the [Inspect the Cloud Config Definition](/demos/03_inspect-cloud-config) exercise lab

---
