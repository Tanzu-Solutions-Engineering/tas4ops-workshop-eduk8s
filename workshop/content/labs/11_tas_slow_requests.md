## Goal

Our application is experiencing extreme latency and causing our systems to become degraded.   Let's troubleshoot using the CF CLI and BOSH to determine the root cause.   

---

## Troubleshooting slow requests in TAS 

Let's imagine our spring-music app is experiencing latency.  

1. To better understand the issue lets measure the total round-trip of our app.  
   To do this you will need to know the URI or route to your application.  
   
   Run cf apps to get a list of your applications and their corresponding urls.  
    ```
    cf apps
    ```
   Now with this information, run the following curl command with the time command to measure the total round trip of your request.   
    ```
    time curl -v <your-app-spring-music.vmware.com>
    ```
    Examine the output and take note of the "real" time.  
    
    ```
    * Connection #0 to host spring-music-fixme-active-roan-bn.cfapps.haas-236.pez.pivotal.io left intact
        real	0m0.201s
        user	0m0.002s
        sys     	0m0.010s
        
    ```
    
    
    
2. View the request time in your app's logs.  

   If you suspect that you are experiencing latency, the most important logs are the access logs. The cf logs command streams log messages from Gorouter as well as from apps. 


   From one terminal enter the following command:
    ```
    cf logs spring-music-<team name>
    ```
    
    From another terminal send a request to the app using the same curl command from earlier:  
    ```
    curl -v <your-app-spring-music.vmware.com>
    ```
    You should now see the requst in your terminal with the logs.   
    Type ctrl+c to exit the streaming logs.   
    
Example Output: 
    
        bash-5.0$ cf logs spring-music-fixme
        Retrieving logs for app spring-music-fixme in org system / space workshop as admin...
           2021-01-29T03:41:47.04+0000 [RTR/0] OUT spring-music-fixme-active-roan-bn.cfapps.haas-236.pez.pivotal.io - [2021-01-29T03:41:47.036839627Z] 
           "GET / HTTP/1.1" 200 0 2020 "-" "curl/7.64.1" "100.64.16.3:39080" "192.168.128.10:61001" x_forwarded_for:"76.211.113.136, 100.64.16.3"
           x_forwarded_proto:"http" vcap_request_id:"bc32d8fb-dfbb-492d-542d-96c3d9c75486" response_time:0.005739 gorouter_time:0.000492 app_time:0.005247 
           app_id:"8dac8193-ee26-44ec-81d8-de9753649be5" app_index:"0" x_b3_traceid:"3892855d75b961f7" x_b3_spanid:"3892855d75b961f7" 
           x_b3_parentspanid:"-" b3:"3892855d75b961f7-3892855d75b961f7"
           2021-01-29T03:41:47.04+0000 [RTR/0] OUT 


    
    
3. Duplicate latency on another endpoint

    We will now use our test-app to measure the latency we are seeing in our spring-music app.   
    First SSH into our test-app 
    ```
    cf ssh test-app-<team name>
    ```
    Now run the following curl command to measure the round trip back from our spring-music app.   
    ```
    time curl -v <your-app-spring-music.vmware.com>  
    ```
    
   ### If this experiment shows that something in your app is causing latency, use the following questions to start troubleshooting your app:
    * Did you recently push any changes?
    * Does your app make database calls?
        * If so, have your database queries changed?
    * Does your app make requests to other microservices?
        * If so, is there a problem in a downstream app?
    * Does your app log where it spends time? 
    
    
4. Remove the load balancer from the request path 

    In order to do this we will need to obtain the deployment id and router guid using bosh 
    
    This means we need to SSH to our Jumphost which has connectivity to our Bosh Director.   
    Please use the instructions which were provided prior to the lab starting.   
    
    ```
    ssh -i privatekey ubuntu@server.vmware.com 
    ```
    
    
    Once inside the jumphost we will need to SSH to our BOSH Director.  
    ```
    ssh ubuntu@BoshDirector.vmware.com 
    ```
    
    
    Once inside of the BOSH Director we will need to authenticate.
    ```
    export BOSH_CLIENT=ops_manager BOSH_CLIENT_SECRET=<BOSHSECRETHERE> BOSH_CA_CERT=/var/tempest/workspaces/default/root_ca_certificate                                 BOSH_ENVIRONMENT=<BOSH-IPADDRESS> bosh
    ```
    Now that we have setup our environment with our BOSH Credentials we can now run bosh commands.   
    
    List the vms within your bosh environment 
    ```
    bosh vms 
    ```
    Select one of your router vms and record its GUID and deployment ID. 
    
    Example Output: 
    
    ```
        ubuntu@opsmgr-01-haas-236-pez-pivotal-i:~$ bosh vms
        Using environment '192.168.1.11' as client 'ops_manager'

        Task 241. Done

        Deployment 'cf-a801abefab398f5d1a82'

        Instance                                                            Process State  AZ       IPs           VM CID                                   VM Type      Active  Stemcell  
        backup_restore/f256d66b-d083-4f9d-8efc-2e2726c4b890                 running        pas-az1  192.168.2.23  vm-38d6e4f5-b9af-400a-a16e-249e0b1f58a6  micro        true    -  
        clock_global/6420e0c7-c2c3-43a1-82e8-f604efc52b87                   running        pas-az2  192.168.2.33  vm-e5fb2b27-f232-4952-9f3d-9af0e4db4c64  medium.disk  true    -  
        clock_global/82c568e7-2c3b-439f-87a5-7689573892be                   running        pas-az1  192.168.2.32  vm-4a635faf-7e6c-4170-9a9c-cfd5751c8295  medium.disk  true    -  
        cloud_controller/8a7e1516-d815-4621-958a-d2f76ed06c83               running        pas-az2  192.168.2.30  vm-009b71d3-20e3-45b2-9397-3e07a455ef9c  medium.disk  true    -  
        cloud_controller/f2c62d99-c205-43bc-bfc2-41aa5cc3b5f8               running        pas-az1  192.168.2.29  vm-7c1ceb9f-342e-40bd-9dae-8d3fba4e7b2b  medium.disk  true    -  
        cloud_controller_worker/1fee20d4-7c4c-4a13-ac0c-e015dfda6492        running        pas-az1  192.168.2.34  vm-f7a2fe96-e1de-4531-bfdf-c723cfd15fcd  micro        true    -  
        cloud_controller_worker/4bf5ac9a-b8ca-45f6-a385-ea0d4a3340b8        running        pas-az2  192.168.2.35  vm-980a4504-2f98-4d26-a34b-d3d1240784d1  micro        true    -  
        credhub/2fd7efc3-333c-49c0-8fdb-711594b460d3                        running        pas-az1  192.168.2.45  vm-6b12dfcb-4bf9-46ec-9c5e-46992185c0c7  large        true    -  
        router/15ffac5d-c64a-4863-8566-0dd241517ce1                         running        pas-az2  192.168.2.12  vm-6e71953b-222c-460b-a28b-9f7a2eece286  micro.ram    true    -  
        router/43b99b4f-29ba-4483-bccc-9d3823207c66                         running        pas-az1  192.168.2.11  vm-8575084f-04fb-4fb9-aafc-a8c88754c18f  micro.ram    true    -  
        tcp_router/99f62efb-c5c5-43d5-91fb-a3542cd6f388                     running        pas-az1  192.168.2.14  vm-fd0432b3-584d-45ee-acba-de9b119995b3  micro        true    -  
        uaa/34517030-247f-4e7b-8486-87cfb26c5286                            running        pas-az1  192.168.2.27  vm-0d919607-096a-4465-a97a-bdc93725b8bc  medium.disk  true    -  
        uaa/43eeb350-a5b6-4e47-9f03-c799603632ec                            running        pas-az2  192.168.2.28  vm-fbb8230b-baee-4b65-b74b-4e85ea0e272f  medium.disk  true    -  
        36 vms
        Succeeded
    ```
    
    
    Since this list may be extensive, use grep to filter your options.  
    ```
    bosh vms |grep router
    ```
    
    Example Output: 
    ```
        ubuntu@opsmgr-01-haas-236-pez-pivotal-i:~$ bosh vms |grep router
        router/15ffac5d-c64a-4863-8566-0dd241517ce1                       	running	pas-az2	192.168.2.12	vm-6e71953b-222c-460b-a28b-9f7a2eece286	micro.ram  	true	-	
        router/43b99b4f-29ba-4483-bccc-9d3823207c66                       	running	pas-az1	192.168.2.11	vm-8575084f-04fb-4fb9-aafc-a8c88754c18f	micro.ram  	true	-	
        tcp_router/99f62efb-c5c5-43d5-91fb-a3542cd6f388                   	running	pas-az1	192.168.2.14	vm-fd0432b3-584d-45ee-acba-de9b119995b3	micro      	true	-	

    ```
    
    Now run the following command to ssh into one of your routers.  
    Replace the variables below with your router's GUID and deployment ID.  
    ```
    bosh ssh -d <deploymentID> router/<GUID>
    ```
    
    Example Output: 
    ```
        ubuntu@opsmgr-01-haas-236-pez-pivotal-i:~$ bosh ssh -d cf-a801abefab398f5d1a82 router/15ffac5d-c64a-4863-8566-0dd241517ce1
        Using environment '192.168.1.11' as client 'ops_manager'

        Using deployment 'cf-a801abefab398f5d1a82'

        Task 243. Done
        Unauthorized use is strictly prohibited. All access and activity
        is subject to logging and monitoring.
        Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-72-generic x86_64)

         * Documentation:  https://help.ubuntu.com
         * Management:     https://landscape.canonical.com
         * Support:        https://ubuntu.com/advantage

         * Introducing self-healing high availability clusters in MicroK8s.
           Simple, hardened, Kubernetes for production, from RaspberryPi to DC.

             https://microk8s.io/high-availability

        The programs included with the Ubuntu system are free software;
        the exact distribution terms for each program are described in the
        individual files in /usr/share/doc/*/copyright.

        Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
        applicable law.

        Last login: Fri Jan 29 03:58:42 2021 from 192.168.1.10
        To run a command as administrator (user "root"), use "sudo <command>".
        See "man sudo_root" for details.

        router/15ffac5d-c64a-4863-8566-0dd241517ce1:~$ 

    ```
    
    
    Run the same curl command from before.   
    ```
    time curl -v <your-app-spring-music.vmware.com> 
    ```
5. Remove Gorouter from the request path 

   (From the second terminal)
   
   Retrieve the IP Address and Port number of the Diego Cell where your app is running 
   
    ```
    cf ssh spring-music-<team name> -c "env |grep CF_INSTANCE_ADDR"
    ```
    The output should provide you with an IP address (Save this for later) 
    
    ```
    bash-5.0$ cf ssh spring-music-fixme -c "env |grep CF_INSTANCE_ADDR"
    CF_INSTANCE_ADDR=192.168.2.38:61012

    ```
    
    You could have also ran the following command which provides slightly more detail.  
    ```
    cf curl /v2/apps/$(cf app test-app --guid)/stats
    ```
    
    Example Output: 
    
    ```
        bash-5.0$ cf curl /v2/apps/$(cf app test-app --guid)/stats
        {
           "0": {
              "state": "RUNNING",
              "isolation_segment": null,
              "stats": {
                 "name": "test-app",
                 "uris": [
                    "test-app-anxious-wolverine-ug.cfapps.haas-236.pez.pivotal.io"
                 ],
                 "host": "192.168.2.36",
                 "port": 61016,
                 "uptime": 5145,
                 "mem_quota": 268435456,
                 "disk_quota": 1073741824,
                 "fds_quota": 16384,
                 "usage": {
                    "time": "2021-01-29T04:19:53+00:00",
                    "cpu": 0.001660650909655187,
                    "mem": 15761408,
                    "disk": 12312576
                 }
              }
           }
        }
    ```
    
    
    Now we will use bosh to ssh back into our router VM
    ```
    bosh ssh -d <deploymentID> router/<GUID>
    ```
    Now determine the amount of time a request takes when it skips Gorouter.  
    Run the following command. Replacing the variable with the IP Address we obtained earlier. 
    ```
    time curl <IPaddressOfDiegoCellforSpringMusicApp>
    ```
    
For additional detail on troubleshooting slow connectivity please see the following url. 

https://docs.pivotal.io/application-service/2-10/adminguide/troubleshooting-router-error-responses.html
