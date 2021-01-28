## Goal

Deploying software systems with BOSH is done with BOSH Releases. 
Releases abstract code away from the underlying OS and create a specific packing structure all software systems must adhere to. 
Lets explore the BOSH Releases currently available on your environment.

## Prerequisites

You are in the [jumpbox and logged into BOSH](/demos/00_lab-connect/).

## Exploring the BOSH Releases

1. Issue the following bosh command:

```
bosh releases
```

which should get you the list of all releases uploaded to the BOSH Director:

```
Using environment '192.168.1.11' as client 'ops_manager'

Name                           Version          Commit Hash
backup-and-restore-sdk         1.17.2*          f7138d2
binary-offline-buildpack       1.0.35*          6ad45ac
bosh-dns                       1.17.0*          c10f409
bosh-dns-aliases               0.0.3*           eca9c5a
bosh-system-metrics-forwarder  0.0.18*          7dc0683
bpm                            1.1.5*           98f635b
...
```

Notice that the release versions listed with asterisks are currently in use by the deployments.
You can only delete BOSH releases that are not currently in use.

### Best Practice

BOSH Directors deployed by OpsMgr for a TAS installation should not be used for ad-hoc release deployments to minimize the risk of deployment misconfiguration accidents (e.g. delete the TAS deployment by accident).

If you planning to deploy BOSH releases that are not deployed by OpsMgr tiles (e.g. Concourse), it is highly recommended to have a separate BOSH Director instance to be created for such purposes. 


2. Inspect jobs and packages of a release

Pick the name and version of one of the releases listed in the previous step and issue the following command:

```
bosh inspect-release <name>/<version>
```

e.g. `bosh inspect-release backup-and-restore-sdk/1.17.2`

The [inspect-release](https://bosh.io/docs/cli-v2/#inspect-release) sub-command lists all jobs and packages associated with a release version.


## Unused Releases Clean-up

As new versions of releases are uploaded and upgraded in the system, a clean-up is recommended to be done in BOSH on a regular basis, since it does not do it automatically.

Preferably, use Ops Mgr's "DELETE UNUSED PRODUCTS" from its web interface for that task.

Alternatively, `bosh clean-up` ([docs](https://bosh.io/docs/cli-v2/#clean-up)) and `bosh delete-release` ([docs](https://bosh.io/docs/cli-v2/#delete-release)) can also be used for that purpose.

---