# External set of variable 
infra := devops
region := us-east-1
env := prod
org := tgm
org_short := tg
# Internal set of variable 
ENVS := int stag prod
PROJECT := infrastructure
TERRAFORM_BIN := terraform
TF_ENV_VARS := 
TF_OPTIONS := 
LOCAL := false
STATEDIR := tfstates
MAIN_FOLDER=$(shell basename $(CURDIR))
IDENT := $(org)_$(region)_$(env)
TF_STATE_NAME := $(PROJECT)_$(region)_$(env)
# This one should be chnaged 
BUCKET=$(org)-devops-use1-tfstate-stag
DYNAMODB=$(org)-devops-use1-tfstate-stag


.PHONY: help
help:
	@echo $(MAIN_FOLDER)
	@echo "make (plan|apply|autoapply) [env=]"
	@echo "		e.g. make plan env=dev [default: $(env)]"
	@echo " "
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

tf_vars:
    TF_OPTIONS :=  $(TF_OPTIONS) -var="env=$(env)"
    TF_OPTIONS :=  $(TF_OPTIONS) -var="region=$(region)"
    TF_OPTIONS :=  $(TF_OPTIONS) -var="project=$(org)"
    TF_INIT_CONF := $(TF_INIT_CONF) -backend-config="bucket=$(org)-devops-use1-tfstate-$(env)"
    TF_INIT_CONF := $(TF_INIT_CONF) -backend-config="dynamodb_table=$(org)-devops-use1-tfstate-$(env)"
    TF_INIT_CONF := $(TF_INIT_CONF) -backend-config="key=terraform/$(region)/$(MAIN_FOLDER)/$(TF_STATE_NAME).tfstate"
    TF_INIT_CONF := $(TF_INIT_CONF) -backend-config="region=$(region)"
    TF_INIT_CONF := $(TF_INIT_CONF) -var-file="vars/$(IDENT).tfvars"

    TF_ENV_VARS := TF_DATA_DIR=".tf_$(org)_$(region)_$(env)"    
    TF_RUN_CONF := $(TF_RUN_CONF) -var-file="vars/$(IDENT).tfvars"
	
tf_init: 
    ifeq ($(filter $(env),$(ENVS)),)
		$(error $(env) is not supported)
    endif
	@echo "# Running $(PROJECT) on : $(AWS_ENV)"
	@echo "# TF_ENV_VARS: $(TF_ENV_VARS)"
	$(TF_ENV_VARS) ${TERRAFORM_BIN} init $(TF_OPTIONS) $(TF_INIT_CONF) 
 

.PHONY: init 
init:  tf_vars tf_init
	
.PHONY: plan 
plan:  tf_vars tf_init 
	$(TF_ENV_VARS) ${TERRAFORM_BIN} plan  $(TF_OPTIONS) $(TF_RUN_CONF) -lock=false

.PHONY: apply
apply:  tf_vars tf_init 
	$(TF_ENV_VARS) ${TERRAFORM_BIN} apply  $(TF_OPTIONS) $(TF_RUN_CONF)

.PHONY: destroy 
destroy: tf_vars tf_init  
	$(TF_ENV_VARS) ${TERRAFORM_BIN} destroy $(TF_OPTIONS) $(TF_RUN_CONF)

.PHONY: autoapply
autoapply: tf_vars tf_init 
	$(TF_ENV_VARS) ${TERRAFORM_BIN} apply -auto-approve $(TF_OPTIONS) $(TF_RUN_CONF)
