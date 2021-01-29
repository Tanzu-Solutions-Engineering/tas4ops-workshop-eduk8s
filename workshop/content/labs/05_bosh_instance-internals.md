
## Goal

Persistence and monitoring are two of the most important pieces of a BOSH release. 
Lets explore how both of these are done, and where the important files are by examining a VM (instance) deployed by BOSH.

---

## Part 1: How does persistence work with BOSH?

1. As a continuation from the previous lab, lets understand how and where BOSH places persistent disks vs ephemeral disks. In an `bosh ssh` session with an instance, issue the following command:

  ```execute
  df -h
  ```

  - You should see something like the following:
    
    ```
            Filesystem      Size  Used Avail Use% Mounted on
            udev            7.4G  4.0K  7.4G   1% /dev
            tmpfs           1.5G  268K  1.5G   1% /run
            /dev/sda1       2.8G  1.2G  1.5G  46% /
            none            4.0K     0  4.0K   0% /sys/fs/cgroup
            none            5.0M     0  5.0M   0% /run/lock
            none            7.4G     0  7.4G   0% /run/shm
            none            100M     0  100M   0% /run/user
            /dev/sda3       8.4G   22M  7.9G   1% /var/vcap/data
            tmpfs           1.0M  4.0K 1020K   1% /var/vcap/data/sys/run
            /dev/sdb1       4.8G   10M  4.6G   1% /var/vcap/store
    ```

  - Any persistent disk specified in this instance's deployment manifest is attached to the `/var/vcap/store` mount point.   

    This requires that any software system deployed with BOSH write any persistent data to this directory or a subdirectory.

  - This allows us the ability to stop, terminate, or delete the BOSH instance, with our persistent disk data remaining intact and also is how BOSH is able to update BOSH instances in the future without losing data.

---

## Part 2: How does BOSH monitor software packages?

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

    ```execute
    monit summary
    ```

    - The same command is used for `restart`, `start`, and `stop`.

---

## Part 3: How does a BOSH Release get deployed on the running BOSH instance?

1. When deploying BOSH releases, BOSH places compiled code and other resources in the `/var/vcap/` directory tree, which BOSH creates on the BOSH instances. Two directories seen in the BOSH release, `jobs`, and `packages` appear on BOSH instances as `/var/vcap/jobs` and `/var/vcap/packages` respectively. Once `SSH`ed into the BOSH instance lets use the `tree` utility to show these.

```execute
sudo apt-get install tree
```

```execute
tree /var/vcap
```

---

## Part 4: Where can we see logs?

1. All logs on the BOSH instances are stored relative to which BOSH job they come from starting from the `/var/vcap/sys/log/` directory. Once `SSH`ed into the BOSH instance lets use the `tree` utility to show these.

  ```execute
  tree /var/vcap/sys/log/
  ```

---

## Part 5: Other commands

1. Check the number of CPU cores via the `nproc` utility.

  ```execute
  nproc --all
  ```

1. Check the memory capacity via the `free` utility.

  ```execute
  free -g
  ```

1. Exit the vm when done.

   ```execute
   exit
   exit
   ```

---

## Part 6: Understanding BOSH 'start', 'stop', 'restart' and 'recreate'

1. Exit the ssh session with the instance used i the previous section

1. Check the following article "[Understanding BOSH 'start', 'stop', 'restart' and 'recreate'](https://community.pivotal.io/s/article/understanding-bosh-start-stop-restart-and-recreate)" to understand the differences between those bosh cli commands and the corresponding `monit` commands tested further above.

1. Use `bosh start ...` and `bosh stop ...` to restart some of the jobs of an instance of your deployment

---