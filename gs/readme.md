Blocks:

Minimum setup: awscli, helm, gitlab-pipeline
Regular setup: awscli, helm, gitlab-pipeline, terraform/terragrunt, datadog/newrelic

unfortunately all 4 services are written in different languages and it will not be possible to unify their assembly process completely :(

```
A. App template details

- Understanding Application Architecture: Meet with the development teams for each repository to understand the application architecture, how components interact, and their requirements in terms of storage, networking, and compute resources.
- Designing Helm for apps ( very likelly would be possible to use single helm chart ), 
  Must be: stop/start procedure, command in helm chart, healthChecks, deploy strategy,       restartPolicy
- Secret usage strategy - vault integration, aws secrets.
- Defining AWS Requirements: Determine the required AWS resources such as Elastic Load Balancers, RDS instances, S3 buckets etc., if any. Understand any specific requirements for AWS EKS like specific instance types, IAM policies, or VPC configurations.
```

```
B. CI/CD details 

- Pipeline Design: Define the stages and jobs in the pipeline for each repository. Typically, this includes 
  build - simple docker build of image
  test - at least init tests 
  deployment - at least helm upgrade
- Implementation: Create the .gitlab-ci.yml files in each repository and configure GitLab Runners to execute the jobs.
- Integration with AWS EKS: The deployment stage in the pipeline should be able to authenticate with AWS, push Docker images to ECR, and apply Kubernetes manifests to the EKS cluster.
```

```
C. AWS and infra details 

- AWS Infrastructure Design: Design the AWS environment, including VPCs, subnets, security groups, IAM roles, and ECR repositories for Docker images.
- Kubernetes Node Pool Design: Plan for separate node pools for frontend and backend services, if required. Determine the instance types and count for each node pool. Must be added affinity policy.
- Implementation: Use AWS Management Console, AWS CLI, or Infrastructure as Code (IaC) tools like AWS CloudFormation or Terraform to set up the AWS infrastructure and EKS cluster.
```

```
D. Monitoring and Maintaning 

- Monitoring Setup: at least AWS CloudWatch, set up appropriate metrics, dashboards, and alerts.
- Logging: at least AWS CloudWatch Logs. Set up a centralized logging solution using Fluentd, Elasticsearch, and Kibana (EFK stack).
- Maintenance Plan: Define procedures for regular maintenance tasks like patching nodes, upgrading the cluster, and capacity planning.
```