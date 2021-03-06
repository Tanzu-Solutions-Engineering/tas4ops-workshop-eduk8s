## Goal

One of the worst thing that could happen to your platform is letting your certificates expire.   Once they expire normal operations can and will be eventually affected.   Let's see how we can check your certificates via the CredHub CLI.  

---

# Lets check for expired certificates using the CredHub CLI 
0. First ensure we are still logged into our ops manager.   
   If not, please follow the steps provided prior to the workshop.   

   SSH into the jumpbox VM of your Lab environment

    ```execute
    ssh -o "StrictHostKeyChecking no" ubuntu@ubuntu-{{ LAB_SLOT_ID }}.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}
    ```
    Type in the password for the environment provided by your instructor.

   Once logged in to the jumpbox, SSH into the Ops Manager VM of your environment

    ```execute
    ssh -o "StrictHostKeyChecking no" ubuntu@opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}
    ```
    
1. Configure an alias for BOSH commands  

    The BOSH CLI requires several parameters to run commands, such as the targeted BOSH Director environment and authentication credentials. 

    To make that easier, you can define an alias containing all of those parameters and the Ops Manager web interface makes the content for that alias readily available in its credentials tab page.

    From the Ops Mgr web UI > Bosh Tile > Credentials tab ([link](https://opsmgr-01.haas-{{ LAB_SLOT_ID }}.{{ LAB_DOMAIN }}/api/v0/deployed/director/credentials/bosh_commandline_credentials)), copy the contents of "Bosh Command line Credentials" and then define the alias issue the following command:  

   ```copy-and-edit
   alias bosh="<command-from-ops-mgr-panel>"
   ```
   
   As an extra step for this lab, let's export our BOSH variables to our environment.
   
   We will use them in the next couple of steps.   
   
   
   ```copy-and-edit
   export BOSH_CLIENT=ops_manager BOSH_CLIENT_SECRET="examplesecret" BOSH_CA_CERT=/var/tempest/workspaces/default/root_ca_certificate BOSH_ENVIRONMENT=192.168.1.x bosh
   ```

    
2.  Set your credhub target to point to the Bosh Director  

    ```execute
    credhub api https://$BOSH_ENVIRONMENT:8844 --ca-cert=/var/tempest/workspaces/default/root_ca_certificate
    ```
    
    Example Output: 
    
   ``` 
        ubuntu@opsmgr-01-haas-236-pez-pivotal-i:~$ credhub api https://192.168.1.11:8844 --ca-cert=/var/tempest/workspaces/default/root_ca_certificate
        Setting the target url: https://192.168.1.11:8844
   ```


3.  Next authenticate to CredHub using your bosh credentials 

    ```execute
    credhub login \
     --client-name=$BOSH_CLIENT \
     --client-secret=$BOSH_CLIENT_SECRET
    ```
  
4.  Run the following credhub command to view any expired certificates. 

    ```execute
    credhub get -n /services/tls_ca -j | jq -r .value.ca  | openssl x509 -text -noout | grep -A 2 "Validity"
    ```
    
    Example Output: 
    ```
    ubuntu@opsmgr-01-haas-236-pez-pivotal-i:~$ credhub get -n /services/tls_ca -j | jq -r .value.ca  | openssl x509 -text -noout | grep -A 2 "Validity"
       Validity
           Not Before: Jan 20 15:13:47 2021 GMT
           Not After : Jan 19 15:13:47 2026 GMT
    ```
    
    The output should show two dates.  
    The first date will show when your certificate became valid. 
    The second date will show when your certificate expires.
    
    Alternatively you could run this command without grep to get more details.  
    
    ```execute
    credhub get -n /services/tls_ca -j | jq -r .value.ca  | openssl x509 -text -noout
    ```

---
    
For additional detail on verifying your certificates please see the following: 

https://docs.pivotal.io/ops-manager/2-10/security/pcf-infrastructure/check-expiration.html
 

If your certificate has already expired please see the knowledge base article below: 

https://community.pivotal.io/s/article/How-to-rotate-and-already-expired-services-tls-ca-certificate?language=en_US
