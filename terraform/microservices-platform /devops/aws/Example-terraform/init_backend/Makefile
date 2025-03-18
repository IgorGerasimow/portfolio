region := us-east-1
env := prod
project := infrastructure
TF_ENV_VARS :=
TF_OPTIONS :=

LOCAL := true
STATEDIR := tfstates

ENVS := dev stag prod stag all
# Need to think about it 

PROJECT := $(project)
TERRAFORM_BIN := terraform
IDENT := $(PROJECT)_$(env)_$(region)

.PHONY: help
help:
	@echo "make (plan|apply|autoapply) [env=]"
	@echo "		e.g. make plan account=dev [default: $(env)]"
	@echo " "
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

tf_vars:
    TF_OPTIONS :=  $(TF_OPTIONS) -var env=$(env)
    TF_OPTIONS :=  $(TF_OPTIONS) -var region=$(region)
    ifeq ($(LOCAL),true)
        TF_ENV_VARS := TF_DATA_DIR=".tf_$(IDENT)"    
        TF_INIT_CONF := $(TF_INIT_CONF) -backend-config="$(CURDIR)/$(STATEDIR)/$(IDENT).tfstate"
        TF_INIT_CONF := $(TF_INIT_CONF) -var-file="vars/$(IDENT).tfvars"
        TF_RUN_CONF := $(TF_RUN_CONF) -state="$(CURDIR)/$(STATEDIR)/$(IDENT).tfstate"
        TF_RUN_CONF := $(TF_RUN_CONF) -var-file="vars/$(IDENT).tfvars"
    endif
	# @echo "# TF_OPTIONS= $(TF_OPTIONS)"

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
	$(TF_ENV_VARS) ${TERRAFORM_BIN} plan $(TF_OPTIONS) $(TF_RUN_CONF)

.PHONY: apply
apply:  tf_vars tf_init 
	$(TF_ENV_VARS) ${TERRAFORM_BIN} apply $(TF_OPTIONS) $(TF_RUN_CONF)

.PHONY: destroy 
destroy: tf_vars tf_init  
	$(TF_ENV_VARS) ${TERRAFORM_BIN} destroy $(TF_OPTIONS) $(TF_RUN_CONF)

.PHONY: autoapply
autoapply: tf_vars tf_init 
	$(TF_ENV_VARS) ${TERRAFORM_BIN} apply -auto-approve $(TF_OPTIONS) $(TF_RUN_CONF)
