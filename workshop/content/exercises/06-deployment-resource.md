As already highlighted, a key resource created when deploying an application is the `deployment` resource. It specifies the name of the container image to be deployed for an application, how many instances should be started, and the strategy for how the deployment should be managed.

To view the `deployment` resource used for the front end web application, run:

```execute
cat frontend/deployment.yaml
```

This has various parts to it, as well as dependencies on other resources, so let's start over and create this from scratch.

To create a new `deployment` resource what often happens is that a developer will copy an existing one, be it one from an existing application, or a sample provided in documentation or a blog post.

An alternative is to have `kubectl` create it for you. For a `deployment`, the `kubectl` command provides two options for creating the resource definition for you.

The first option is using the `kubectl create deployment` command.

```execute
kubectl create deployment --help
```

For the deployment of the front end web application, the container image we want to use is `quay.io/eduk8s-labs/app-k8s-fundamentals-frontend:latest`.

To see what `kubectl create deployment` would create for us run:

```execute
kubectl create deployment blog --image quay.io/eduk8s-labs/app-k8s-fundamentals-frontend:latest --dry-run -o yaml
```

This should yield:

```
apiVersion: apps/v1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: blog
  name: blog
spec:
  replicas: 1
  selector:
    matchLabels:
      app: blog
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: blog
    spec:
      containers:
      - image: quay.io/eduk8s-labs/app-k8s-fundamentals-frontend:latest
        name: app-k8s-fundamentals-frontend
        resources: {}
status: {}
```

Note that nothing has been created at this point as when we ran `kubectl create deployment` we used the `--dry-run` option, it therefore only showed what it would create.

Although `kubectl create deployment` could be used, it is a very bare bones skeleton for a `deployment` object.

A second option is to use `kubectl run`.

```execute
kubectl run --help
```

This command accepts numerous options for helping you fill out the resource definition with additional key configuration you might need.

To start to replicate the configuration for our sample application, run:

```execute
kubectl run blog --image quay.io/eduk8s-labs/app-k8s-fundamentals-frontend:latest --labels app=blog --replicas 2 --port 8080 --env BLOG_SITE_NAME="EduK8S Blog" --dry-run -o yaml
```

This should produce:

```
apiVersion: apps/v1beta1
kind: Deployment
metadata:
  creationTimestamp: null
  labels:
    app: blog
  name: blog
spec:
  replicas: 2
  selector:
    matchLabels:
      app: blog
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: blog
    spec:
      containers:
      - env:
        - name: BLOG_SITE_NAME
          value: EduK8S Blog
        image: quay.io/eduk8s-labs/app-k8s-fundamentals-frontend:latest
        name: blog
        ports:
        - containerPort: 8080
        resources: {}
status: {}
```

The difference is that it has set the number of replicas of our application that we want to be 2 instead of 1. It includes the port number our application listens on, and includes one of the environment variables we want to be set. We have also ensured the label used is `app=blog`. This version of the `deployment` is still far from complete, but it is enough to get us started.

One could now re-run the command and leave off the `--dry-run` option and it would create the resource. To make subsequent changes to the resource definition, one could then edit it in place using the `kubectl edit` command.

Maintaining the master copy of the configuration in Kubernetes like this is fine in a development environment, but for production, it is better to keep the master copy as a local file, under revision control so you can track it, and when changes are needed, edit the local master copy and apply it to the Kubernetes cluster.

The Kubernetes documentation has a discussion about these two different approaches to managing configuration in [Managing Kubernetes Objects Using Imperative Commands](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/imperative-command/) and [Declarative Management of Kubernetes Objects Using Configuration Files](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/declarative-config/).

As it is closer to what you would want to do for a production environment, we will use the latter approach.

For this first attempt towards replicating the front end web application, the output from `kubectl run` has been captured in the file `frontend-v1/deployment.yaml`. You can see the full contents of the directory by running:

```execute
ls -las frontend-v1
```

As is, it is only the one file. We could at this point run `kubectl apply` on just this file, but as we go along we will be adding additional files for other resources. We will therefore continue to use the ability of `kubectl apply` to be given a directory of files to process and apply them in one operation.

Create the `deployment` by running:

```execute
kubectl apply -f frontend-v1/
```

It should output:

```
deployment.apps/blog created
```

Monitor progress of the deployment so you know when it has completed.

```execute
kubectl rollout status deployment/blog
```

Note that although we used ``kubectl run`` as a basis for creating an initial version of the ``deployment`` resource, from Kubernetes 1.18 the ability to create a ``deployment`` using ``kubectl run`` has been removed, instead it creates a ``pod``. This workshop still needs to be rewritten to cater for this change and is currently still using ``kubectl`` from Kubernetes 1.17. If you are using Kubernetes 1.18 or later, you will need to construct an initial ``deployment`` by hand using ``kubectl create deployment``, but because it is missing the various parts explained above, they will need to be added.
