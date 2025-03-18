#!/usr/bin/env bash

AWS_STAGE_ACCOUNT=627992770327
AWS_PROD_ACCOUNT=ID
AWS_REGION=eu-central-1
PROD_KMS_NAME='alias/vault-kms-prod'
STAGE_KMS_NAME='alias/vault-kms-stage'
SECRET_NAME=db-auth
declare -A LITERALS

###
read -p "Enter secrets name: " name

if [ -z "$name" ]
then
  echo "Empty secret name"
  exit 0;
else
  SECRET_NAME=${name}
fi

###
PS3='Please choose env: '
options=("stage" "prod" "Exit")
select opt in "${options[@]}"
do
    case $opt in
        "stage")
            ENV=stage
            echo "you chose choice ${ENV}"
            break
            ;;
        "prod")
            ENV=prod
            echo "you chose choice ${ENV}"
            break
            ;;
        "Exit")
            break
            ;;
        *) echo "Invalid option $REPLY";;
    esac
done

if [ -z "$ENV" ]
then
  exit 0;
fi

###
while true; do
  if [ ! ${#LITERALS[@]} -eq 0 ]; then
    for k in "${!LITERALS[@]}"; do
      echo "${k}=${LITERALS[$k]}"
    done
  fi
  read -p "Enter key name (empty to continue): " key
  case $key in
    * )
      if [ -z "$key" ]
      then
        break;
      else
        read -p "Enter value for \"${key}\": " value
        LITERALS[${key}]=${value}
      fi
      ;;
  esac
done

if [ ${#LITERALS[@]} -eq 0 ]; then
  echo "Nothing to encrypt, please fill KEY=value pairs."
  exit 0
fi

###
if [ $ENV == "stage" ]
then
  KMS_NAME=$STAGE_KMS_NAME
  AWS_ACCOUNT=$AWS_AWS_STAGE_ACCOUNT
  AWS_PROFILE=company-stage
else
  KMS_NAME=$PROD_KMS_NAME
  AWS_ACCOUNT=$AWS_PROD_ACCOUNT
  AWS_PROFILE=company-prod
fi

SECRET_PATH="./apps/${ENV}/company-mail/secrets/${SECRET_NAME}.yaml"

CREATE_SECRET_COMMAND="kubectl create secret generic ${SECRET_NAME} "
for k in "${!LITERALS[@]}"; do
  CREATE_SECRET_COMMAND+="--from-literal=${k}=${LITERALS[$k]} "
done
CREATE_SECRET_COMMAND+="--dry-run=client "
CREATE_SECRET_COMMAND+="-o yaml > ${SECRET_PATH}"

ENCRYPT_SECRET_COMMAND="AWS_PROFILE=${AWS_PROFILE} sops
--kms arn:aws:kms:${AWS_REGION}:${AWS_ACCOUNT}:${KMS_NAME} -e
--encrypted-regex \"^(data|stringData)\"
--output ${SECRET_PATH}
${SECRET_PATH}"

echo "Create kubernetes secrets command: "
echo $CREATE_SECRET_COMMAND
echo "Encrypt secrets command: "
echo $ENCRYPT_SECRET_COMMAND

while true; do
    read -p "Execute commands (y/n)?" yn
    case $yn in
        [Yy]* )
          touch $SECRET_PATH
          eval $CREATE_SECRET_COMMAND
          cat $SECRET_PATH
          eval $ENCRYPT_SECRET_COMMAND
          cat $SECRET_PATH
          echo "Done."
          break
          ;;
        [Nn]* )
          echo "Bye."
          exit
          ;;
        * ) echo "Please answer yes or no.";;
    esac
done
