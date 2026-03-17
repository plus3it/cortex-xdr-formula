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
{%- set cortex_pkg_signing_key = salt.pillar.get(
    'cortex-xdr:lookup:enterprise_linux:pkg_signing_key',
    cortex_xdr.pkg.pkg_signing_key
  )
%}

{%- if cortex_pkg_signing_key.endswith('.zip') %}
Get and extract archived Cortex XDR Agent Signing-Key:
  archive.extracted:
    - archive_format: zip
    - group: root
    - name: '/tmp/cortex_signing_key.d'
    - skip_verify: True
    - source: '{{ cortex_pkg_signing_key }}'
    - user: root

Normalize extracted Cortex XDR Agent Signing-Key name:
  cmd.run:
    - name: 'mv /tmp/cortex_signing_key.d/cortex-xdr-agent.asc {{ cortex_signing_key_path }}'
    - onchanges:
      - archive: 'Get and extract archived Cortex XDR Agent Signing-Key'
    - onchanges_in:
      - cmd: 'Install Cortex XDR Agent Signing-Key'
{%- elif cortex_pkg_signing_key.endswith('.asc') %}
Get raw Cortex XDR Agent Signing-Key:
  file.managed:
    - name: '{{ cortex_signing_key_path }}'
    - onchanges_in:
      - cmd: 'Install Cortex XDR Agent Signing-Key'
    - source: '{{ cortex_signing_key }}'
    - source_hash: '{{ cortex_signing_key_hash }}'
{%- endif %}

Install Cortex XDR Agent Signing-Key:
  cmd.run:
    - name: 'rpm --import {{ cortex_signing_key_path }}'
    - onlyif:
      - '[[ -s {{ cortex_signing_key_path }} ]]'
    - stateful: False
    - unless:
      - '[[ $( rpm -qia gpg-pubkey\* | grep -q ''Palo Alto XDR'' )$? -eq 0 ]]'
