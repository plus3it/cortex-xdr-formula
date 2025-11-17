# State to install package GPG-key used to validate the Cortex XDR
# Agent RPM. Original GPG-key may be downloaded from:
#
#   https://docs-cortex.paloaltonetworks.com/v/u/cortex-xdr-agent.zip
#
# Using a browser with JavaScript enabled
#
# This state is a pre-condition to the main "install" state
#
# -*- coding: utf-8 -*-
# vim: ft=sls
#
######################################################################
{%- set cortex_signing_key = salt.pillar.get('cortex-xdr:lookup:enterprise_linux:archive:signing_key', '') %}
{%- set cortex_signing_key_hash = salt.pillar.get('cortex-xdr:lookup:enterprise_linux:archive:signing_key_hash', '') %}
{%- set cortex_signing_key_path = '/tmp/cortex_xdr_signing_key.asc' %}

Get Cortex XDR Agent Signing-Key:
  file.managed:
    - name: '{{ cortex_signing_key_path }}'
    - source: '{{ cortex_signing_key }}'
    - source_hash: '{{ cortex_signing_key_hash }}'

Install Cortex XDR Agent Signing-Key:
  cmd.run:
    - name: 'rpm --import {{ cortex_signing_key_path }}'
    - onchanges:
      - file: 'Get Cortex XDR Agent Signing-Key'
    - stateful: False
    - unless:
      - '[[ $( rpm -qia gpg-pubkey\* | grep -q ''Palo Alto XDR'' )$? -eq 0 ]]'
