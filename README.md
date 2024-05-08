# K8s Challenge

## Pre-requisites

- [Docker](https://docs.docker.com/desktop/install/mac-install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli#install-terraform)

**NOTE:** Run the `validate_tooling.sh` to verify that the appropriate are dependencies installed.

## Getting Started

- execute `terraform init`
- execute `terraform plan`
- execute `terraform apply -auto-approve`

After these steps, you should be able to access the swagger api at http://localhost/api/swagger/index.html

**NOTE:** The "Try it out" swagger functionality will not work as expected with the ingress. In order to hit the api requests will need the appropriate prefix. Example: http://localhost/api/health/ping will work, but http://localhost/health/ping will not.

### API Outage Scenario

#### Issue 1

With the most recent deployment, customers are reporting inconsistent access to the api. Try hitting localhost/api/swagger/index.html to investigate.
As the on-call, walk us through the steps you will take to troubleshoot and resolve.


**Hint:** A prometheus/grafana stack has been deployed, and is accessible at http://localhost:3000 after running the command below:

`kubectl port-forward --namespace monitoring pod/$(kubectl get pods -l app.kubernetes.io/name=grafana --namespace monitoring --template='{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}') 3000:3000`

The grafana credentials can be found in the terraform output.

#### Issue 2 

The API should now be available, but it looks like requests aren't providing the appropriate responses. Try hitting http://localhost/api/health/ping to reproduce the issue.
As the on-call, walk us through the steps you will take to troubleshoot and resolve.

## Cleanup

execute `terraform destroy -auto-approve`
