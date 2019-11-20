#!/bin/bash

# Varibles for Ansible AD-Join Script
# Region
region=$1
# AD domain to join
ad_domain=$2
# AD Group used for join
ad_join_group=$3
# sudo AD group
sudogrp=$4
# ssm parameter store
userparam_name=$5
passparam_name=$6
# list of AD principals (user or groups) to allow
ad_entities=$4
# script names
adscript="AD-Join-install.yaml"
localdir="/tmp"
adjoinlog="/tmp/adjoin.log"

#Creating log file
touch ${localdir}/adjoin.log

set -x

# get from ssm parameter store
export ad_username="$(aws ssm get-parameters --name "${userparam_name}" --with-decryption --region "${region}" | \
                jq -r '.Parameters[].Value')" 
export ad_pass="$(aws ssm get-parameters --name "${passparam_name}" --with-decryption --region "${region}" | \
                jq -r '.Parameters[].Value')" 

if [ -z "${ad_pass}" -o -z "${ad_username}" ]; then           
  echo "ERROR: Getting AD value from SSM parameter store failed.. Please check" 
  exit 1
fi

ip="$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4 | awk -F"." '{print $4}')"
host_name="hostname" #hostname identifier (some random name!!)
DT=`date +%s`

# Run the Ansible Script
echo "Executing the Ansible Playbook - Install ad_auth tools, do a AD join, Allow access by AD user/group..."
echo "AD Domain: ${ad_domain}"
echo "AD Group: ${ad_join_group}" 
echo "sudo Group: ${sudogrp}"
echo "Additional AD users or groups: ${ad_entities}"


echo "Executing AD realm join.. Takes about 3-5 minutes..."
[[ -f ${localdir}/${adscript} ]] && 
sudo ansible-playbook \
      ${localdir}/${adscript} \
      --extra-vars "ad_username=${ad_username} , ad_pass='${ad_pass}' , \
          host_name=${host_name}-${ip} , group=${ad_join_group} , \
          sudogrp=${sudogrp} , domain=${ad_domain}" > ${adjoinlog} 2>&1 ; status=$?

if [ ${status} -ne 0 ]; then
  echo "ERROR: Status Code: ${status} - AD realm join [ FAIL ]... Please check !!" 
  echo "AD Join Log.."
  cat ${adjoinlog}
  exit 1
else
  sudo realm list | grep sssd
  sudo realm list; status=$?
  if [ ${status} -eq 0 ]; then 
    echo "Status: AD realm join [ SUCCESS ]"
  else
    echo "ERROR: Status Code: ${status} - AD realm join Check [ FAIL ].... Please check !!"
    cat ${adjoinlog}
    exit 1
  fi
fi

# Add any additional AD groups to allow

if [ ! -z "${ad_entities}" ]; then
  for group in ${ad_entities}
  do
    echo "ALLOW - Additional AD user or group: ${group}"
    sudo /usr/sbin/realm permit -g "${group}@${ad_domain}" && 
    echo "Allow Success"
  done
  sudo realm list
fi

# TODO: extract relevant information from AD join log
echo "AD Join log"
cat ${adjoinlog}

echo "End of AD Join script"

#set +x
