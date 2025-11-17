#!/bin/bash
#
# Script to identify and remove Cortex XDR Agent RPM's validation-key
#
###########################################################################
VALIDATION_KEY="$(
  rpm -qa gpg-pubkey\* \
    --qf '%{name}-%{version}-%{release}:%{packager}\n' | \
  awk -F':' '/@paloaltonetworks/{ print $1 }'
)"

if [[ -n ${VALIDATION_KEY:-} ]]
then
  if [[ $( rpm -e "${VALIDATION_KEY}" )$? -eq 0 ]]
  then
    echo  # an empty line here so the next line will be the last.
    echo "changed=yes comment='Deleted ${VALIDATION_KEY:-}'"
  else
    echo  # an empty line here so the next line will be the last.
    echo "changed=no comment='Failed while deleting ${VALIDATION_KEY:-}'"
  fi
else
  echo  # an empty line here so the next line will be the last.
  echo "changed=no comment='No Cortex XDR Agent RPM validation-key found'"
fi
