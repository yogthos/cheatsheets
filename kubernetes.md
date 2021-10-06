### Setting up the environment

* place config files (credentials) in `~/.kube/`
* Install `kubectl` https://kubernetes.io/docs/tasks/tools/install-kubectl/
* set the `KUBECONFIG` environment variable to the desired config file (ie. `set -x KUBECONFIG ~/.kube/staging-edit.conf`) (alternatively use `--kubeconfig` flag to point to the config)
* run `kubectl version` to confirm that things are set up properly, `run kubectl get pods -n<name> to confirm that you are able to access the cluster for the corresponding credential

### General Kubernetes Telemetry

(after setting your `KUBECONFIG`)

#### Listing Resources

```
kubectl get pods                       # List all pods in the current namespace
kubectl get secrets
kubectl get services
kubectl get sts
kubectl describe pods <pod-name>       # Print a detailed description of the specified pod
kubectl describe sts/<sts-name>
```

#### Interacting with pods

Running commands

```
kubectl exec <pod-name> -it /bin/sh                           # start an interactive shell in the pod (if one container -- add '-c <container-name> if multi-container case)
kubectl exec <pod-name> env                                   # check pod environment variables
kubectl exec <pod-name> -- <command>                          # run command in pod (single container)
```
Logs
```
kubectl logs <pod-name>                                       # dump pod logs (stdout)
kubectl logs -f <pod-name>                                    # stream pod logs (stdout)
kubectl logs <pod-name> -p                                    # dump pod logs (stdout) for a previous instantiation of a container
kubectl exec <pod-name> -- tail -f <path to container logs>   # stream container logs
```

Port forward/REPL
```
kubectl port-forward <pod-name> <port>                        # listen on port <port> locally, forwarding to <port> in the pod
kubectl port-forward <pod-name> local-port:pod-port           # forward a port to a specified local port
kubectl cp <pod-name>:path/to/app.log .                       # copy log life to local directory
```

#### Restarting apps

The number of running pods is controlled by the "replicas" field in the app's statefulset. For our applications this will always be set to 1. To restart an application, set the replicas to 0 then back to 1.

```
kubectl scale --replicas=0 sts <sts name>
kubectl scale --replicas=1 sts <sts name>
```

### Other cheatsheets

* https://kubernetes.io/docs/reference/kubectl/cheatsheet/
* https://github.com/dennyzhang/cheatsheet-kubernetes-A4
