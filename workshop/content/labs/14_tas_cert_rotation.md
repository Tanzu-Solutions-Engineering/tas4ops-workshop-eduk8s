## Goal

One of the worst thing that could happen to your platform is letting your certificates expire.   Once they expire normal operations can and will be eventually affected.   Let's see how we can rotate your certificates to prevent this from happening.    

---

## Part 1 of Cert Rotation 
  Since this is a very disruptive process we will NOT implement these steps during the workshop.   
  The following steps will show you how to rotate your Services TLS Certificate.  
1. Check if CredHub has a new temporary certificate from a previous rotation attempt.
    ```
    credhub get -n /services/new_ca
    ```
    
    You should see a generic error which states that no certificate is present.   
    ```
        ubuntu@opsmgr-01-haas-236-pez-pivotal-i:~$ credhub get -n /services/new_ca
        The request could not be completed because the credential does not exist or you do not have sufficient authorization.

    ```
2. If any older temporary certificate exists, delete it before proceeding. 
    ```
    credhub delete -n /services/new_ca
    ```
3. You have the option to bring your own certificate or use a self signed certificate. 
    If you select to use a self signed certificate, please see the following command to create the self signed certificate.  
    ```
        credhub generate \
        --name="/services/new_ca" \
        --type="certificate" \
        --no-overwrite \
        --is-ca \
        --duration=1825 \
        --common-name="opsmgr-services-tls-ca"
    ```
    This will create a self signed certificate called opsmgr-services-tls-ca which expires in 5 years.
    Default duration is 1 year if no input is given.   
4. Now retrieve the current TLS CA Certificate 
    ```
    credhub get --name=/services/tls_ca -k ca
    ```
    
    Example Output: 
    
    ```
        ubuntu@opsmgr-01-haas-236-pez-pivotal-i:~$ credhub get -n /services/new_ca
        id: 12f5cdb4-05d6-4991-8a8b-8037be2be75a
        name: /services/new_ca
        type: certificate
        value:
          ca: |
            -----BEGIN CERTIFICATE-----
            MIIDIzCCAgugAwIBAgIUBM+AhSr3/udKrVEQ6jtul+LpAO0wDQYJKoZIhvcNAQEL
            BQAwITEfMB0GA1UEAxMWb3BzbWdyLXNlcnZpY2VzLXRscy1jYTAeFw0yMTAxMjkw
            NDUyNDVaFw0yNjAxMjgwNDUyNDVaMCExHzAdBgNVBAMTFm9wc21nci1zZXJ2aWNl
            cy10bHMtY2EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCjNA3HZ+0j
            DBXwEO0lK8oXjmVArolGs5tjlxHeOOGwca/Akun5L3w5IXvegX56Gm381f4jodG9
            Vc/AZ27ns85xMm9F9Gap66DMVmAfIyqCPq+MfNA2h0Kt2JRZ0bfmwtLAzBRTKSbM
            8MfC5D1+A/cGiotX0LVrm/fXr6oLDOlicIe7LbtAdBkMxLR4WLEi162rPyzx89Wn
            ++++---------------------REDACTED---------------------------++++
            j2u5KxyavC/uHtSYLwz/52FCw7b8unXWeMBRpHF4+uQR2fgx2qNPzKr1ZX/Kfkq9
            lJf1UfARAFmNAgMBAAGjUzBRMB0GA1UdDgQWBBRoWtfTEjLDgDA5gynOxX4aJhUp
            XjAfBgNVHSMEGDAWgBRoWtfTEjLDgDA5gynOxX4aJhUpXjAPBgNVHRMBAf8EBTAD
            AQH/MA0GCSqGSIb3DQEBCwUAA4IBAQBqs8TEYeb6+f9ZXmmp3w3B2xIHrpcP2DJz
            GCbt7mIyajJ5z/zLqtQedVVk9QVCvlfNW5M/FP0FC+NIp+mOCpkZ5qxjhnzHua5r
            moD9Iz63pYlP8xAAViD8IvMg5zy06Mq+IN/DTWa+0VnWWaT1M3K3zXnpR4dr34z1
            tnmhjZHk5n44AfS+g7BS/yL7CG1KuCuq+b9HzNqwG1eq4u/hdrNg855e+oLov3x5
            wWI4xOjHM00eHXwyArtrhP5DIHRMZKnOMEWkclCCZyG7c6vJPLDVhyOak8+jWyWK
            vTUEqpZ/LH53vsnjuErr7wWd99qUsWMh5FWxDlttxz8Zju15+u9D
            -----END CERTIFICATE-----
          certificate: |
            -----BEGIN CERTIFICATE-----
            MIIDIzCCAgugAwIBAgIUBM+AhSr3/udKrVEQ6jtul+LpAO0wDQYJKoZIhvcNAQEL
            BQAwITEfMB0GA1UEAxMWb3BzbWdyLXNlcnZpY2VzLXRscy1jYTAeFw0yMTAxMjkw
            NDUyNDVaFw0yNjAxMjgwNDUyNDVaMCExHzAdBgNVBAMTFm9wc21nci1zZXJ2aWNl
            cy10bHMtY2EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCjNA3HZ+0j
            DBXwEO0lK8oXjmVArolGs5tjlxHeOOGwca/Akun5L3w5IXvegX56Gm381f4jodG9
            Vc/AZ27ns85xMm9F9Gap66DMVmAfIyqCPq+MfNA2h0Kt2JRZ0bfmwtLAzBRTKSbM
            8MfC5D1+A/cGiotX0LVrm/fXr6oLDOlicIe7LbtAdBkMxLR4WLEi162rPyzx89Wn
            RcSvULp+kYe6fPQp2RH/aD8UT12ueQgw8vMJeojt2pgYSXBcJygdvAQq3fhIZXRQ
            ++++---------------------REDACTED---------------------------++++
            lJf1UfARAFmNAgMBAAGjUzBRMB0GA1UdDgQWBBRoWtfTEjLDgDA5gynOxX4aJhUp
            XjAfBgNVHSMEGDAWgBRoWtfTEjLDgDA5gynOxX4aJhUpXjAPBgNVHRMBAf8EBTAD
            AQH/MA0GCSqGSIb3DQEBCwUAA4IBAQBqs8TEYeb6+f9ZXmmp3w3B2xIHrpcP2DJz
            GCbt7mIyajJ5z/zLqtQedVVk9QVCvlfNW5M/FP0FC+NIp+mOCpkZ5qxjhnzHua5r
            moD9Iz63pYlP8xAAViD8IvMg5zy06Mq+IN/DTWa+0VnWWaT1M3K3zXnpR4dr34z1
            tnmhjZHk5n44AfS+g7BS/yL7CG1KuCuq+b9HzNqwG1eq4u/hdrNg855e+oLov3x5
            wWI4xOjHM00eHXwyArtrhP5DIHRMZKnOMEWkclCCZyG7c6vJPLDVhyOak8+jWyWK
            vTUEqpZ/LH53vsnjuErr7wWd99qUsWMh5FWxDlttxz8Zju15+u9D
            -----END CERTIFICATE-----
          private_key: |
            -----BEGIN RSA PRIVATE KEY-----
            MIIEowIBAAKCAQEAozQNx2ftIwwV8BDtJSvKF45lQK6JRrObY5cR3jjhsHGvwJLp
            +S98OSF73oF+ehpt/NX+I6HRvVXPwGdu57POcTJvRfRmqeugzFZgHyMqgj6vjHzQ
            NodCrdiUWdG35sLSwMwUUykmzPDHwuQ9fgP3BoqLV9C1a5v316+qCwzpYnCHuy27
            ++++---------------------REDACTED---------------------------++++
            UOlSjRldoUEgChRFBsA+KS0I4k32ehMtnHeMo2KQ1HscaFv/iNoyO5G4NRlis37w
            ++++---------------------REDACTED---------------------------++++
            isxbQe8gJfRVf9GjuoZ51mHH2fkp6e4xoWky/upSX1zX67a/dXIWsZgyYSBLH2sZ
            toK4/ERTSyxHEZHKimEo+gdLPaaK0ng2+5FmTaLdK5uG6pJM/wbkW6yz3Dq5589d
            ++++---------------------REDACTED---------------------------++++
            z0+L3eisW5pOGAO+Juenozu8Evy0v45U+to4PFd99s3ElicvVzU72Mpw7PAixqJ0
            ++++---------------------REDACTED---------------------------++++
            BKnIAQKBgFeKoei9a/5t+iqVlDfKIHJOGn9GoIj34LTeacg42BLOpf8s6e4T1pU5
            oyP/xc5fARl1pSIFDS0IvdtBj3dKfutDj80f4QCrMXpn/rGutS6kWfO9Tc+kDYwF
            ty/KsBvXJRF30yuX6j9NLNhTiphghad7KgEibB4Waaifs9r087/E
            -----END RSA PRIVATE KEY-----
        version_created_at: "2021-01-29T04:52:45Z"

    ```
5. Retrieve the new certificate from a pre-existing file or from your new CredHub location
    ```
    credhub get --name=/services/new_ca -k ca
    ```
    
    Example Output: 
    
    ```
    ubuntu@opsmgr-01-haas-236-pez-pivotal-i:~$ credhub get --name=/services/new_ca -k ca
        -----BEGIN CERTIFICATE-----
        MIIDIzCCAgugAwIBAgIUI1QddY+HSj7uF4FnyoMTlt0ldGQwDQYJKoZIhvcNAQEL
        BQAwITEfMB0GA1UEAxMWb3BzbWdyLXNlcnZpY2VzLXRscy1jYTAeFw0yMTAxMjkw
        NDU1MzdaFw0yNjAxMjgwNDU1MzdaMCExHzAdBgNVBAMTFm9wc21nci1zZXJ2aWNl
        ++++---------------------REDACTED---------------------------++++
        VemxD4TojQTxNh2vbCpTK7K22oh2ov4eT+zzQIqXPiX3aoOtsXMRx/JEEbWKFdVR
        2k4agiBDtLBobyQJuE5q4kFW64E0/ovUXx9iT61pLQi+PbuvJXfZR5mP3DCF82y/
        fYTfJF6SQmAfzypr4n+POKY+WLhVJhNaNAfpfNoCxceicEbe9+Yw7ARGN/C02ZxG
        2S3J7Smlv9nCOWYxT6JNjUF2MFbg/M7jukW1pm2g7jD+n0xaRKpOhYmZL1KsCpVq
        FVebgf+u/1kKuHKE55KsdoLRahX0bBhHYz5OE/rojyUDG2/65Q/xHacpOBTTHlnE
        2X6d+lBW54urAgMBAAGjUzBRMB0GA1UdDgQWBBR8svPBhDtHB6rTA7PjyrFSdgcN
        ++++---------------------REDACTED---------------------------++++
        AQH/MA0GCSqGSIb3DQEBCwUAA4IBAQCwYznd7DCu2gLt3qSxWe5W7xvnQj8n7BuW
        gz4hWH3Cob//VqWMcucoFHhQUvNZ5N1SpXYBqTo0Jn/VryzaDYB8ohE4AUUHsH53
        VtMNrKovJkad4zUOLE3Gr2shZCMur7MKVRNXgJxpuM4HKuij9TQvzwMH3Mhed8jz
        vg2pjCO6fybolIeIIVy3oYYwjC/qAv6ZfGcHSkufysOoDFs4rSHuoKdjn/LwwVfL
        P3YgmGM3iXXJoPiIngKdJCIWfsEJHNdiwp3akT1jjqnIjfMnSH7NrnCXxqn6eQqq
        6UfoAFp5FayfKER9vtnmJ37aiGOPDRZC3tWah0xTrkzbxLXJ9GGU
        -----END CERTIFICATE-----

    ```
6. From the Ops Manager tile, paste both certificates into the Bosh Director > Security > Trusted Certificates field and click save.  
7. From the Tas for VMs tile, paste both certificates into the Networking > Certificate Authorities trusted by the Gorouter and Certificate Authorities trusted by the HAProxy fields and click save.  
8. From Ops Manager, click Review Pending Changes. 
9. Before applying any changes, identify which service tiles are using the Services TLS CA certificate
    ```
    credhub curl -p /api/v1/certificates?name=%2Fservices%2Ftls_ca
    ```
    
    Example Output: 
    
    ```
        ubuntu@opsmgr-01-haas-236-pez-pivotal-i:~$ credhub curl -p /api/v1/certificates?name=%2Fservices%2Ftls_ca
        {
          "certificates": [
            {
              "id": "0af2cf10-c451-4c50-97aa-0691da25ce10",
              "name": "/services/tls_ca",
              "signed_by": "/services/tls_ca",
              "signs": [],
              "versions": [
                {
                  "certificate_authority": true,
                  "expiry_date": "2026-01-19T15:13:47Z",
                  "generated": true,
                  "id": "f15728c3-e8eb-4ea6-9adf-652ebc587ed5",
                  "self_signed": true,
                  "transitional": false
                }
              ]
            }
          ]
        }

    ```
    The output from the above command should give you a list of services which are depenedent on the Services TLS CA Certificate.  
    
10. Now for each service tile listed in the previous output 

    Expand the errands view and enable the errand to upgrade all service instances.        
    
    
11. Now from Ops manager, select Review Pending Changes and click Apply.   

## Part 2 of Cert Rotation 
12. After changes have been successfully applied we will need to set the new Services TLS Certificate. 
    If you are using an exisiting certificate use the following command. 
    ```
        credhub set \
        --name="/services/tls_ca" \
        --type="certificate" \
        --certificate=<PEM-PATH/root.pem> \
        --private=<CERT-KEY>
    ```
    If you are using a self signed certificate use the following command.  
    ```
        credhub get -n /services/new_ca -k ca > new_ca.ca
        credhub get -n /services/new_ca -k certificate > new_ca.certificate
        credhub get -n /services/new_ca -k private_key > new_ca.private_key
        credhub set -n /services/tls_ca \
        --type=certificate \
        --root=new_ca.ca \
        --certificate=new_ca.certificate \
        --private=new_ca.private_key
    ```
13. Now navigate back to the Ops Manager and select Review Changes.  
14. As a precautionary step before applying any changes, identify which service tiles are using the Services TLS CA certificate
    ```
    credhub curl -p /api/v1/certificates?name=%2Fservices%2Ftls_ca
    ```
15. Now for each service tile listed in the previous output 
    Expand the errands view and enable the errand to upgrade all service instances.        
16. Now from Ops manager, select Review Pending Changes and click Apply.   

## Part 3 of Cert Rotation 
Now we will need to remove the old services TLS Certificate 

17. From Ops Manager select the Bosh Director tile.  

18. Click Security and delete the old CA Certificate from the Trusted Certificates field and click save. 

19. From Ops Manager select the TAS for VMs tile

20. Click Networking and delete the old CA Certificate in the Certificate Authorities trueted by Gorouter and Certificate Authorities trusted by HAProxy fields and click save.  

21. Finally Navigae back to Ops Manager dashboard and click Review Pending Changes.   

22. Ensure that errands have been enabled to upgrade all service instances. 

23. Click Apply Changes.   


    For additional detail on checking your certificates 
    please see -> https://docs.pivotal.io/ops-manager/2-10/security/pcf-infrastructure/services_tls_ca_rotate.html
 

    If your certificate has already expired please follow the knowledge base article below. 
    
    https://community.pivotal.io/s/article/How-to-rotate-and-already-expired-services-tls-ca-certificate?language=en_US

