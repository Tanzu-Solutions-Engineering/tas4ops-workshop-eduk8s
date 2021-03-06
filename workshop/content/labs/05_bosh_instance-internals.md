
### Goal

<br/>

Persistence and monitoring are two of the most important pieces of a BOSH release. 

Lets explore how both of these are done, and where the important files are by examining a VM (instance) deployed by BOSH.

<br/>

---

### Part 1: How does persistence work with BOSH?

<br/>

1. As a continuation from the previous lab, lets understand how and where BOSH places persistent disks vs ephemeral disks. In an `bosh ssh` session with an instance, issue the following command:

  ```execute
  df -h
  ```

  You should see something like the following:
    
    ```
      Filesystem      Size  Used Avail Use% Mounted on
      devtmpfs        479M     0  479M   0% /dev
      tmpfs           493M     0  493M   0% /dev/shm
      tmpfs           493M   62M  432M  13% /run
      tmpfs           5.0M     0  5.0M   0% /run/lock
      tmpfs           493M     0  493M   0% /sys/fs/cgroup
      /dev/sda1       2.9G  1.4G  1.4G  50% /
      /dev/sdb2       6.9G  952M  5.6G  15% /var/vcap/data
      tmpfs           1.0M   40K  984K   4% /var/vcap/data/sys/run
      /dev/sdc1       197G   60M  187G   1% /var/vcap/store
    ```

  Any persistent disk specified in this instance's deployment manifest is attached to the `/var/vcap/store` mount point.   

    This requires that any software system deployed with BOSH write any persistent data to this directory or a subdirectory.
  
  This allows us the ability to stop, terminate, or delete the BOSH instance, with our persistent disk data remaining intact and also is how BOSH is able to update BOSH instances in the future without losing data.

<br/>

---

### Part 2: How does BOSH monitor software packages?

<br/>

1. In the same bosh instance ssh session, issue the following commands.

    ```execute
    sudo su
    ```

    ```execute
    monit summary
    ```

    - You should see something like the following:
      ```  
        The Monit daemon 5.2.5 uptime: 19d 5h 10m

        Process 'loggregator_agent'         running
        Process 'loggr-syslog-agent'        running
        Process 'metrics-discovery-registrar' running
        Process 'metrics-agent'             running
        ...
        System 'system_localhost'           running
      ```

    - For each BOSH job we are running on the BOSH instance we will see a `Process` type entry. 

    - Also notice that there is a `System` type entry. This is the entry for the overall system including the BOSH agent itself.

1. When we want to restart a job all we need to do is ask monit to do it for us with the `monit restart` command.

    ```execute 
    monit restart metrics-agent
    ```

    Then issue the `monit summary` command a few times while the process restarts in order to inspect the status updates provided by monit.  

    ```execute
    monit summary
    ```

    - The same command is used for `restart`, `start`, and `stop`.

<br/>

---

### Part 3: How does a BOSH Release get deployed on the running BOSH instance?

<br/>

1. When deploying BOSH releases, BOSH places compiled code and other resources in the `/var/vcap/` directory tree, which BOSH creates on the BOSH instances. Two directories seen in the BOSH release, `jobs`, and `packages` appear on BOSH instances as `/var/vcap/jobs` and `/var/vcap/packages` respectively. Once `SSH`ed into the BOSH instance lets use the `tree` utility to show these.

```execute
sudo apt-get install tree
```

```execute
tree /var/vcap
```
<br/>

---

### Part 4: Where can we see logs?

<br/>

1. All logs on the BOSH instances are stored relative to which BOSH job they come from starting from the `/var/vcap/sys/log/` directory. Once `SSH`ed into the BOSH instance lets use the `tree` utility to show these.

  ```execute
  tree /var/vcap/sys/log/
  ```
<br/>

---

### Part 5: Other commands

<br/>

1. Check the number of CPU cores via the `nproc` utility.

  ```execute
  nproc --all
  ```

1. Check the memory capacity via the `free` utility.

  ```execute
  free -g
  ```

1. Exit the vm when done and go back to the Ops Mgr VM ssh session.

   ```execute
   exit
   exit
   ```

<br/>

---

### Part 6: Understanding BOSH 'start', 'stop', 'restart' and 'recreate'

<br/>

1. Exit the ssh session with the instance used i the previous section

1. Check the following article "[Understanding BOSH 'start', 'stop', 'restart' and 'recreate'](https://community.pivotal.io/s/article/understanding-bosh-start-stop-restart-and-recreate)" to understand the differences between those bosh cli commands and the corresponding `monit` commands tested further above.

1. Use `bosh start ...` and `bosh stop ...` to restart some of the jobs of an instance of your deployment

  <br/>

  Hint: to list alls jobs of all instances of a deployment, use `bosh instances --ps`


<br/>
---