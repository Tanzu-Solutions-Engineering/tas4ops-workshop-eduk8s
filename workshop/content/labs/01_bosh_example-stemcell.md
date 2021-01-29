## Goal

BOSH Stemcells contain both metadata and the raw image. Lets take some time to examine what is contained in the metadata and how a Stemcell is organized.

---

## Part 1: Inspect the stemcells on your lab environment

In the same terminal where you ssh'ed into the Ops Mgr VM (step 3 of this workshop), inspect the stemcells with the following command:

```execute
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

## Part 2: Downloading and inspecting the contents of a stemcell image

1. Download an AWS Light Stemcell - [list of stemcells](https://bosh.io/stemcells/bosh-aws-xen-hvm-ubuntu-xenial-go_agent)

   ```execute-2
   wget https://bosh-aws-light-stemcells.s3-accelerate.amazonaws.com/621.99/light-bosh-stemcell-621.99-aws-xen-hvm-ubuntu-xenial-go_agent.tgz
   ```
   

2. Extract the downloaded stemcell

   ```execute-2
   tar -xvf light-bosh-stemcell-621.99-aws-xen-hvm-ubuntu-xenial-go_agent.tgz
   ```

3. Check file `stemcell.MF` to inspect the contents of the stemcell files 

    ```execute-2
    cat stemcell.MF
    ```

    Notice versioning, and specific metadata for the stemcell

4. Inspect file `packages.txt`

    ```execute-2
    cat packages.txt
    ```

    Notice the utilities which come pre-installed on the stemcell

---