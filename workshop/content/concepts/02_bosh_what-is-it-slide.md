### What is BOSH?

<br/>

- BOSH is an open source tool for release engineering, deployment, lifecycle management, and monitoring of distributed systems

- BOSH installs and updates software packages on large numbers of VMs over many IaaS providers with the absolute minimum of configuration changes

- BOSH orchestrates initial deployments and ongoing updates that are:  
  - Predictable, repeatable, and reliable  
  - Self-healing  
  - Infrastructure-agnostic  

<br/>

--- 

### What can BOSH Deploy & Manage?

<br/>

- Cloud Foundry Application Runtime  
  <img src="../images/Bosh_CF-mgmt.png" alt="Bosh Manages Cloud Foundry Application Runtime " style="border:none;" />

<br/>

- Kubernetes  
  <img src="../images/Bosh_K8s-mgmt.png" alt="Bosh manages Kubernetes Clusters VMs" style="border:none;" />

<br/>

- Databases  
  <img src="../images/Bosh_DB-mgmt.png" alt="Bosh manages Database servers" style="width:100%;max-width: 600px;border:none;" />

<br/>

- Messaging Clusters  
  <img src="../images/Bosh_Messaging-mgmt.png" alt="Bosh manages Messaging Clusters" style="width:100%;max-width: 500px;border:none;" />

<br/>

- CI/CD Servers  
  <img src="../images/Bosh_CICD-mgmt.png" alt="Bosh manages CI/CD servers" style="width:100%;max-width: 500px;border:none;" />

<br/>
---

### What IaaS providers does BOSH support?

  <img src="../images/Bosh_IaaS-support.png" alt="Bosh IaaS support" style="width:100%;max-width: 900px;border:none;" />

<br/>

---

### What Operating Systems Does BOSH Support?

  <img src="../images/Bosh_OS-support.png" alt="Bosh OS support" style="width:100%;max-width: 600px;border:none;" />

<br/>

---

### The BOSH Project

<br/>

- BOSH was created in 2010 by VMWare 
- 2013 Pivotal was spun out of VMWare taking BOSH with it
- Pivotal donated the BOSH project the the Cloud Foundry Foundation 
- BOSH is a project of the Cloud Foundry Foundation
- BOSH uses the Apache 2.0 License
- Actively developed since 2010
- 244 Contributors 
- Major contributions from CF Foundation members Pivotal, IBM, SAP, VMWare, Microsoft, Google and others 
- Resources   
  - http://bosh.io    
  - http://ultimateguidetobosh.com/ (Free Book)  
  - http://mariash.github.io/learn-bosh/ (Quick Tutorial)  
  - https://cloudfoundry.org/bosh/   
  - https://github.com/cloudfoundry/bosh   

<br/>

---

### BOSH User Interaction

<img src="../images/Bosh_Interaction.png" alt="Bosh User Interaction" style="border:none;" />

- The BOSH director is a collection of components that orchestrates the initial deployments and ongoing updates of bosh managed services 
- BOSH is a distributed system that can be deployed on multiple VM’s. However it is commonly deployed on a single VM
- A single BOSH director VM can manage thousands of other VMs 
- The BOSH CLI is a single go binary that can be installed on a Mac, Windows, or Linux to drive the BOSH director 

<br/>
---

### Reference: Installing the BOSH CLI

<br/>

Your workshop environment has the BOSH CLI already installed. 
For future reference on how to install it on your local environment, here is the documentation link for the setup steps:
- https://www.bosh.io/docs/cli-v2-install/

<br/>
---