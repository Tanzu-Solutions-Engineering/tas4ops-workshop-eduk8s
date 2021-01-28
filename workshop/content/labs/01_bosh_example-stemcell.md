## Goal

BOSH Stemcells contain both metadata and the raw image. Lets take some time to examine what is contained in the metadata and how a Stemcell is organized.

---

## Part 1: Inspect the stemcells on your lab environment

After you [connect to your Lab jumpbox](/demos/00_lab-connect/), inspect the stemcells with the following command:

```
bosh stemcells
```

You should see output similar to the one below, where the information about currently uploaded stemcells is provided:

```
Using environment '192.168.1.11' as client 'ops_manager'

Name                                      Version  OS             CPI                   CID
bosh-vsphere-esxi-ubuntu-xenial-go_agent  621.41*  ubuntu-xenial  fffb4dfb7562eb41a90b  sc-7b9c56ee-4399-4844-8ffe-c61d4af6b27d

(*) Currently deployed

1 stemcells

Succeeded
```

### Best Practice

On a Tanzu Application Service environment, stemcells should be managed through the Ops Manager user interface.
See product documentation for more details: 
- [Importing and Managing Stemcells](https://docs.pivotal.io/ops-manager/opsguide/managing-stemcells.html)

---

## Part 2: (Optional) Downloading and inspecting the contents of a stemcell image

### Pre-requisites

1. A file archiver to extract files with.

    Windows - [7 Zip](http://www.7-zip.org/)  
    Mac/Linux - [Tar](https://superuser.com/a/46521) - (Factory Installed)

### Extracting the stemcell image

1. Download the latest vSphere Stemcell [here](https://bosh.io/stemcells/bosh-vsphere-esxi-ubuntu-xenial-go_agent)
2. Extract the downloaded stemcell

    `tar -xvf bosh-stemcell-621.41-vsphere-esxi-ubuntu-xenial-go_agent.tgz`
3. Take a look at the contents of the `stemcell.MF` file

    `cat stemcell.MF`

    Notice versioning, and specific metadata for the stemcell

4. Take a look at the contents of the `stemcell_dpkg_l.txt` file

    `cat stemcell_dpkg_l.txt`

    Notice the utilities which come pre-installed on the stemcell

---