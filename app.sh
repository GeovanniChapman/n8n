#!/bin/bash
# AWS
export AWS_ACCOUNT=
export AWS_ACCESS_KEY_ID=
export AWS_SECRET_ACCESS_KEY=
export AWS_REGION=
export VPC_ID=
export SUBNET_IDS=

export COMPANY=demo
export ENVIRONMENT=develop
export DOMAIN=
export HOSTEDZONE_ID=
export CERTIFICATE_ARN=

# To get the current Cpu Architecture in Mac run this command: arch
# export DOCKER_DEFAULT_PLATFORM=linux/amd64 # Force amd64 Cpu Architecture
export DOCKER_DEFAULT_PLATFORM=linux/arm64 # Apple M1 Pro

# Deploy
deploy_aws_infrastructure() {
    aws cloudformation deploy \
      --stack-name $COMPANY-n8n-$ENVIRONMENT \
      --template aws-infrastructure.yaml \
      --capabilities CAPABILITY_NAMED_IAM \
      --no-fail-on-empty-changeset \
      --parameter-override \
      Environment=$ENVIRONMENT \
      VpcId=$VPC_ID \
      SubnetIds=$SUBNET_IDS \
      Company=$COMPANY \
      Domain=n8n.$DOMAIN \
      HostedZoneId=$HOSTEDZONE_ID \
      CertificateArn=$CERTIFICATE_ARN
    exit 1
}

# Menu
main_menu() {
  # Define color codes
  RESET="\033[0m"        # Reset to default color
  RED="\033[31m"         # Red
  GREEN="\033[32m"       # Green
  YELLOW="\033[33m"      # Yellow
  BLUE="\033[34m"        # Blue
  CYAN="\033[36m"        # Cyan
  MAGENTA="\033[35m"     # Magenta
  while true; do
    echo -e "${GREEN}Please select an option:${RESET}"
    echo -e "${CYAN}1. ${YELLOW}Start local${RESET}"
    echo -e "${CYAN}2. ${YELLOW}Deploy in AWS${RESET}"
    echo -ne "${BLUE}Enter your choice: ${RESET}"
    read -r choice
    case $choice in
        1)
          docker-compose up
        ;;
        2)
          deploy_aws_infrastructure
        ;;
        *)
        echo -e "${RED}Invalid option, please try again.${RESET}"
        ;;
    esac
  done
}

main_menu