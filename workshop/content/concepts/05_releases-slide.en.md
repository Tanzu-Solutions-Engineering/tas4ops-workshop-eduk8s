
## Suppose you deploying a very simple 2 VM service 

<img src="/images/Bosh_Releases_01.png" alt="Bosh Releases"/>

---

## Typical Deployment Steps 

- Setup Postgres  
  - We need CentOS 7 machine  
  - With 8 GB RAM, 10GB Disk, and one IP Address  
  - Provision the required VM on IaaS (vSphere, AWS, etc)  
  - Get the source for postgres   
  - Compile postgres and install it   
  - Configure postgres as a monitored service  
  - Start postgres and note it’s ip address / port   

- Setup Tomcat   
  - We need an Ubuntu 16.04 LTS machine  
  - With 4 GB RAM, 10GB Disk, and one IP Address  
  - Provision the required VM on IaaS (vSphere, AWS, etc)  
  - Install the Java Runtime Environment on the VM   
  - Install the Tomcat on the OS   
  - Configure Tomcat as a monitored service   
  - Configure Tomcat data source pointing to postgres   
  - Deploy app into Tomcat   
  - Start tomcat  

---

## Deployment Steps Mapped to BOSH Concepts 

<img src="/images/Bosh_Releases_02.png" alt="Bosh Releases"/>

---

## BOSH Release

- A BOSH release is similar to a collection of traditional software packages, such as Debian APT or MacOS Homebrew packages.

- A traditional software package focused on installing a single piece of software.  
  - Executable (The software)  
  - Library (Dependencies)

- A traditional software package might also configure and run a service.   
  - Default Config Files  
  - Startup Script  
  - Monitoring

- A BOSH release combines all these functions   
  - Compile all packages for the target operating system and architecture  
  - Install runtime dependencies via BOSH packages  
  - Configuring the software (clustering)  
  - Initialize, and run processes using Monit (monitoring system)

---

## release.MF - A YAML metadata file describing the release

```
name: sample-bosh-release
version: 0+dev.1
commit_hash: a2b19b8
uncommitted_changes: false
jobs:
- name: sample_job
 version: 3772798c13278206d9bdf5d58872f7bc8fa77521
 fingerprint: 3772798c13278206d9bdf5d58872f7bc8fa77521
 sha1: f9888b65ad57263475369004a73d28c1ac6c6328
packages:
- name: sample_app
 version: 3698d0cc632d3162a6a2fedcd36ac00364a7cd64
 fingerprint: 3698d0cc632d3162a6a2fedcd36ac00364a7cd64
 sha1: d224739b881e9dd957988bcd7513a37edff69205
 dependencies: []
```
---

## BOSH Packages

- A BOSH release contains a set of software packages that can be installed 
- Each package is stored as a single .tgz file inside of the packages/ directory of the release  
- A BOSH package must contain a shell script called packaging that will invoked to produce the binaries that will be installed on a VM
- A BOSH package must contain the code/binaries that the packaging script uses to produce the bosh package  

---

## BOSH Jobs

- A BOSH job is a set of processes that are configured on a VM 
- Each job is stored as a single .tgz file inside of the jobs/ directory of the release 
- A job must contain a job.MF YAML file that contains metadata about the job 
- A job must contain a monit file that describes how to run and monitor the job 
- A job may contain a collect of ruby ERB templates that are used to generate the startup and configuration scripts for job 

---

## JOB.MF - A YAML metadata file describing the release

```
---
name: sample_job

templates:
 ctl.erb: bin/ctl

packages:
- sample_app

properties: {}
```
---

## Monit script and templates

<img src="https://mmonit.com/monit/img/logo.png" alt="Monit" align="left" width="50px" style="padding-right:10px"/> 
Monit is a small Open Source utility for managing and monitoring Unix systems. Monit conducts automatic maintenance and repair and can execute meaningful causal actions in error situations.

https://mmonit.com/monit/ 

<br/>

---

#### Monit Control script

```
check process sample_app
  with pidfile /var/vcap/sys/run/sample_job/pid
  start program "/var/vcap/jobs/sample_job/bin/ctl start"
  stop program "/var/vcap/jobs/sample_job/bin/ctl stop"
  group vcap
```

Ctl.erb generates ctl shell script used from monit

```
#!/bin/bash
RUN_DIR=/var/vcap/sys/run/sample_job
LOG_DIR=/var/vcap/sys/log/sample_job
PIDFILE=${RUN_DIR}/pid

case $1 in
 start)
   mkdir -p $RUN_DIR $LOG_DIR
   chown -R vcap:vcap $RUN_DIR $LOG_DIR
   echo $$ > $PIDFILE
   cd /var/vcap/packages/sample_app
     exec ./app \
     >>  $LOG_DIR/sample_app.stdout.log \
     2>> $LOG_DIR/sample_app.stderr.log
   ;;
 stop)
   kill -9 `cat $PIDFILE`
   rm -f $PIDFILE
   ;;
 *)
   echo "Usage: ctl {start|stop}" ;;
esac
```
---

## Recommended activity

- View and try out the [Examine Bosh Releases](/demos/05_examine-bosh-release) exercise lab

---

