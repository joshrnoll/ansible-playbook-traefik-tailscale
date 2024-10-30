#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

printf "${GREEN}Installing requirements...${NC}"
echo
ansible-galaxy collection install joshrnoll.homelab --force
echo

printf "${GREEN}Encrypting secrets.yml...${NC}"
echo

printf "${BLUE}You will be asked to create a vault password. You will need to provide the password a total of three times.${NC}"
echo
sleep 1

ansible-vault encrypt secrets.yml
echo

printf "${BLUE}Please re-enter the vault password that you just created...${NC}"
echo

# Prompt for the vault password
read -sp 'VAULT password: ' VAULT_PASS
echo  

# Create a temporary file for the vault password
VAULT_PASS_FILE=$(mktemp)
echo "$VAULT_PASS" > "$VAULT_PASS_FILE"

# Prompt for the SUDO password
printf "${BLUE}Please sudo password for the target machines...${NC}"
sleep 1
echo

read -sp 'Enter your sudo (BECOME) password: ' BECOME_PASS
echo  

printf "${GREEN}Building inventory files...${NC}"
echo

# Run setup playbook to build inventory files
ansible-playbook setup.yml --vault-password-file "$VAULT_PASS_FILE"

printf "${GREEN}Running playbooks...${NC}"
echo

# Run main playbook
ansible-playbook main.yml -i hosts.yml \
--extra-vars "ansible_become_pass=$BECOME_PASS" \
--vault-password-file "$VAULT_PASS_FILE"

# Ensure the temporary file is deleted after script execution
trap 'rm -f "$VAULT_PASS_FILE"' EXIT