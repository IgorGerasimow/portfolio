# Repo for AWS-PROD-studio and AWS-STAGE-studio aws accounts

To be able to use this repo, you have to setup aws config
1. First option is to create your own, local `~/.aws/credentials or ~/.aws/config` file and add your aws `aws-stage-studio` and `aws-prod-studio` secrets to profile. Then you can select needed one from your list `export AWS_PROFILE="aws-stage-studio"`
2. Second option is to copy AWS environment variables from https://studio.awsapps.com/start#/ and export directly to your shell.
Note! Credential has TTL, so you have to keep it updated.
You do not need to run terraform init to install providers modules, as we are using terragrunt.
3. We are trying to keep our terragrunt code DRY. About DRY you can read here https://terragrunt.gruntwork.io/docs/features/keep-your-terraform-code-dry/
Before add some resource please check modules in repo https://git.corp.com/DevOps/terraform/aws-infra-studio/aws-infra-studio-modules always try to use existing module, only if the needed module is absent you can write new one.
4. After make some changed you have to run terragrunt plan, please note that you have to spesify your module location with --terragrunt-source argument
Example for EC2 resource:
go to aws-infra-studio/live/prod/aws/compute/containers/ecs/atlantis directory and run
`terragrunt plan --terragrunt-source ../../../../../../../../../aws-infra-studio/aws-infra-studio-modules//providers/aws/compute/containers/ecs/atlantis`
Note if you have that error:
terraform/aws-infra-studio/aws-infra-studio/live/prod/aws/compute/containers/ecs/atlantis/terragrunt.hcl:1,9-15: Extraneous label for include; No labels are expected for include blocks.
ERRO[0000] Unable to determine underlying exit code, so Terragrunt will exit with error code 1
Your terragrant version is outdated, please update you terragrunt, for macOS you can use `brew upgrade terragrunt`
5. When terragrunt plan is O.K. you can commit and push.
6. Get approved megre request and apply your changes with general atlantis apply flow
7. Do not forget to merge your pool request. Good luck.


Some usefull refs:
https://terragrunt.gruntwork.io/docs/features/keep-your-terragrunt-architecture-dry/#motivation
https://terragrunt.gruntwork.io/docs/features/keep-your-remote-state-configuration-dry/
https://en.wikipedia.org/wiki/Don%27t_repeat_yourself
