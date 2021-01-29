## Goal

As a platform engineer or operator it's important to understand various troubleshooting techniques using the cf cli.   Let's take some time to role play a scanario where your application is not starting and you need to find the root cause to resolve the issue.   

---  

## Application fails to start after issuing cf push command.  
Let's begin by cloning a repository of a broken springboot application.   

1. Clone the broken-spring-music git repo. 
```
git clone https://github.com/jrobinsonvm/broken-spring-music.git
```
2. CD into broken-spring-music directory  
```
cd broken-spring-music
```
3. Change the name of your app to your team name. (Edit the manifest.yml file) 
```
vi manifest.yml
```
4. Run "cf push" to deploy the app
```
cf push
```
It looks like our app didn't start.  Let's see what could be the issue.   
Typically the first thing to check are the logs.  This can be done with the following command.  
```
cf logs spring-music-<team name> --recent
```


From the log output you can easily identify the issue.  
```
[APP/PROC/WEB/0] ERR Cannot calculate JVM memory configuration: There is insufficient memory remaining for heap. Memory available for allocation 512M is less than allocated memory 680680K
```
The memory limit which we set within the manifest yaml file was not sufficent to run our app.  

In another scanario where our logs are not as straight forward we could use other methods to investigate the issue.   

If a command fails or produces unexpected results, re-run it with HTTP tracing enabled to view requests and responses between the cf CLI and the Cloud Controller REST API.
To do this simply rerun cf push with -v for verbose output.  
```
cf push -v 
```


Example Output: 

```
REQUEST: [2021-01-29T01:42:14Z]
GET /api/v1/read/8dac8193-ee26-44ec-81d8-de9753649be5?envelope_types=LOG&start_time=1611884532716859524 HTTP/1.1
Host: log-cache.run.haas-236.pez.pivotal.io
User-Agent: cf/6.53.0+8e2b70a4a.2020-10-01 (go1.13.8; amd64 linux)
Authorization: [PRIVATE DATA HIDDEN]


RESPONSE: [2021-01-29T01:42:14Z]
HTTP/1.1 200 OK
Content-Length: 55
Content-Type: application/json;charset=utf-8
Date: Fri, 29 Jan 2021 01:42:14 GMT
Server: nginx
X-Content-Type-Options: nosniff
X-Vcap-Request-Id: eaa5fa06-4112-4a32-71af-d09465d56264::8a8466d7-9cda-404d-a45a-d02d1cc02b23
{
"0": {
"since": 1611884531,
"state": "CRASHED",
"uptime": 2
}
}



Waiting for app to start...
Start unsuccessful

TIP: use 'cf logs spring-music-fixme --recent' for more information
FAILED
ERROR: [2021-01-29T01:42:14Z]
Get https://log-cache.run.haas-236.pez.pivotal.io/api/v1/read/8dac8193-ee26-44ec-81d8-de9753649be5?envelope_types=LOG&start_time=1611884532716859524: context canceled


```

Please try running the cf events command to get a list of key events with their corresponding timestamps.   

`
cf events spring-music-<team name>
`

Example Output:
    
    
            2021-01-28T18:59:15.00+0000   audit.app.update           admin                disk_quota: 1024, instances: 1, memory: 1024, environment_json: [PRIVATE DATA HIDDEN]
        2021-01-28T18:58:54.00+0000   app.crash                  spring-music-fixme   index: 0, reason: CRASHED, cell_id: 551314d8-f176-4450-8627-8431564d1b79, instance: 550732bc-912f-440f-7571-c26c, exit_description: APP/PROC/WEB: Exited with status 1
        2021-01-28T18:58:54.00+0000   audit.app.process.crash    web                  index: 0, reason: CRASHED, cell_id: 551314d8-f176-4450-8627-8431564d1b79, instance: 550732bc-912f-440f-7571-c26c, exit_description: APP/PROC/WEB: Exited with status 1
        2021-01-28T18:58:10.00+0000   app.crash                  spring-music-fixme   index: 0, reason: CRASHED, cell_id: e74059de-9c19-43f0-9034-c4894154866b, instance: 5f4e0891-2632-4860-6d64-1799, exit_description: APP/PROC/WEB: Exited with status 1
        2021-01-28T18:58:10.00+0000   audit.app.process.crash    web                  index: 0, reason: CRASHED, cell_id: e74059de-9c19-43f0-9034-c4894154866b, instance: 5f4e0891-2632-4860-6d64-1799, exit_description: APP/PROC/WEB: Exited with status 1
        2021-01-28T18:58:01.00+0000   app.crash                  spring-music-fixme   index: 0, reason: CRASHED, cell_id: 551314d8-f176-4450-8627-8431564d1b79, instance: 42fca2cd-f4c7-4493-41ef-2e80, exit_description: APP/PROC/WEB: Exited with status 1
        2021-01-28T18:58:01.00+0000   audit.app.process.crash    web                  index: 0, reason: CRASHED, cell_id: 551314d8-f176-4450-8627-8431564d1b79, instance: 42fca2cd-f4c7-4493-41ef-2e80, exit_description: APP/PROC/WEB: Exited with status 1
        2021-01-28T18:57:49.00+0000   app.crash                  spring-music-fixme   index: 0, reason: CRASHED, cell_id: e74059de-9c19-43f0-9034-c4894154866b, instance: f6b999fd-66d2-4257-4c73-e089, exit_description: APP/PROC/WEB: Exited with status 1
        2021-01-28T18:57:49.00+0000   audit.app.process.crash    web                  index: 0, reason: CRASHED, cell_id: e74059de-9c19-43f0-9034-c4894154866b, instance: f6b999fd-66d2-4257-4c73-e089, exit_description: APP/PROC/WEB: Exited with status 1
        2021-01-28T18:57:31.00+0000   audit.app.droplet.create   admin
        2021-01-28T18:57:07.00+0000   audit.app.update           admin                state: STARTED
        2021-01-28T18:57:07.00+0000   audit.app.build.create     admin
        2021-01-28T18:56:56.00+0000   audit.app.upload-bits      admin
        2021-01-28T18:56:19.00+0000   audit.app.update           admin                disk_quota: 1024, instances: 1, memory: 512, environment_json: [PRIVATE DATA HIDDEN]
        2021-01-28T18:56:00.00+0000   audit.app.map-route        admin

    
    
Use the cf env command to view the environment variables that you have set using the cf set-env command and the variables in the container environment:


    cf env
    
Example Output: 
            
            {
         "VCAP_APPLICATION": {
          "application_id": "8dac8193-ee26-44ec-81d8-de9753649be5",
          "application_name": "spring-music-fixme",
          "application_uris": [
           "spring-music-fixme-active-roan-bn.cfapps.haas-236.pez.pivotal.io"
          ],
          "application_version": "46b37f45-711e-4079-811e-0e81c130e733",
          "cf_api": "https://api.run.haas-236.pez.pivotal.io",
          "limits": {
           "disk": 1024,
           "fds": 16384,
           "mem": 512
          },
          "name": "spring-music-fixme",
          "organization_id": "d031eb8a-dc54-4043-8557-0d129cc84272",
          "organization_name": "system",
          "process_id": "8dac8193-ee26-44ec-81d8-de9753649be5",
          "process_type": "web",
          "space_id": "044b88dc-c940-4a5a-acca-92a02cee22e8",
          "space_name": "workshop",
          "uris": [
           "spring-music-fixme-active-roan-bn.cfapps.haas-236.pez.pivotal.io"
          ],
          "users": null,
          "version": "46b37f45-711e-4079-811e-0e81c130e733"
         }
        }

        User-Provided:
        JBP_CONFIG_OPEN_JDK_JRE: { jre: { version: 11.+ } }
        JBP_CONFIG_SPRING_AUTO_RECONFIGURATION: {enabled: false}

        No running env variables have been set

        No staging env variables have been set

    
    
Know your app's estimated startup time (timeout issue)
By default, applications must start within 60 seconds.  
This timeout can be extended to a max of 180 seconds  
You configure the CLI staging, startup, and timeout settings to override settings in the manifest, as necessary. 

Controls the maximum time that the cf CLI waits for an app to stage after it successfully uploads and packages the app. Value set in minutes.

    CF_STAGING_TIMEOUT

Controls the maximum time that the cf CLI waits for an app to start. Value set in minutes.

    CF_STARTUP_TIMEOUT
    
Controls the maximum time that TAS allows to elapse between starting an app and the first healthy response from the app. When you use this flag, the cf CLI ignores any app start timeout value set in the manifest. Value set in seconds.
    
    cf push -t 
    

5. To increase the memory limit edit the mainifest.yaml file and replace 0.5G with 1G.  
    ```
    vi manifest.yml 
    ```

6.  Now redeploy the application 
    ```
    cf push 
    ```
    
    
 For additional details on troubleshooting your application starting please see the following.  
 
 https://community.pivotal.io/s/article/How-to-troubleshoot-an-application-that-fails-only-when-run-on-Cloud-Foundry?language=en_US
 
 
