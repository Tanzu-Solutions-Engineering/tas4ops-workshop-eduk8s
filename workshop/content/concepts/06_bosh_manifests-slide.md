
## How does BOSH know what we want to deploy?

Hint: manifests

## Deployment Steps Mapped to BOSH Concepts 

<img src="/images/Bosh_Releases_02.png" alt="Bosh Releases"/>


### Manifests 

Typically when creating a machine to run software on you perform the following:
- Open an admin console to a server virtualization platform.
- Create a virtual machine
- Create a disk and add it to the virtual machine
- Create a network and add it to the virtual machine
- SSH into the virtual machine and Install software

With BOSH this is all encapsulated into a deployment manifest.

A deployment manifest is the explicit declaration of what a software system requires to run successfully.

Tip: The same deployment manifest deployed today should produce the same running system if you deployed it again in five years time.

## Example sample-bosh-manifest.yml

```
name: sample-bosh-deployment

releases:
- {name: sample-bosh-release, version: latest}

stemcells:
- alias: trusty
  os: ubuntu-trusty
  version: latest

update:
  canaries: 1
  max_in_flight: 10
  canary_watch_time: 1000-30000
  update_watch_time: 1000-30000

instance_groups:
- name: sample_vm
  instances: 1
  networks:
  - name: default
  azs: [z1]
  jobs:
  - name: sample_job
    release: sample-bosh-release
  stemcell: trusty
  vm_type: default
```

## Recommended activity

- View and try out the [Access Managed Instances](/demos/07_access-managed-instance/) exercise lab

---
