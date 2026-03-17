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
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}

{%- set cortex_signing_key = salt.pillar.get('cortex-xdr:lookup:enterprise_linux:archive:signing_key', '') %}
{%- set cortex_signing_key_hash = salt.pillar.get('cortex-xdr:lookup:enterprise_linux:archive:signing_key_hash', '') %}
{%- set cortex_signing_key_path = '/tmp/cortex_xdr_signing_key.asc' %}
{%- set cortex_pkg_signing_key  = salt.pillar.get(
    'cortex-xdr:lookup:enterprise_linux:archive:pkg_signing_key',
    cortex_xdr.pkg.pkg_signing_key
  )
%}
# Juju to suss-out redirect nonsense
{%- if cortex_pkg_signing_key.startswith(('http://', 'https://')) %}
  {%- set real_pkg_signing_key_url = salt['cmd.run']('curl -Ls -o /dev/null -w %{url_effective} ' ~ cortex_pkg_signing_key) %}
{%- else %}
  {%- set real_pkg_signing_key_url = cortex_pkg_signing_key %}
{%- endif %}

{# Logic to determine local filename and extension #}
{%- if real_pkg_signing_key_url.startswith('s3://') %}
    {# S3 Logic: Always ZIP or ASC #}
    {%- if ".asc" in real_pkg_signing_key_url|lower %}
        {%- set local_file_name = '/tmp/cortex_key.asc' %}
    {%- else %}
        {# Default S3 assumption per your requirement #}
        {%- set local_file_name = '/tmp/cortex_pkg.zip' %}
    {%- endif %}
{%- else %}
    {# API/Web Logic: No extension in URL, keyword search instead #}
    {%- if "download=" in real_pkg_signing_key_url|lower %}
        {%- set local_file_name = '/tmp/cortex_signing.key' %}
    {%- endif %}
{%- endif %}

Download signing-key blob:
  file.managed:
    - name: {{ local_file_name }}
    - source: {{ real_pkg_signing_key_url }}
    - skip_verify: True
    {%- if real_pkg_signing_key_url.startswith('s3://') %}
    - https_enable: True
    - path_style: False
    {%- else %}
    - verify_ssl: False
    {%- endif %}

{%- if local_file_name.endswith('.key') %}
Extract signing-key from HTTP-hosted ZIP archive:
  archive.extracted:
    - archive_format: zip
    - enforce_toplevel: False
    - group: root
    - name: '/tmp/cortex_signing_key.d'
    - skip_verify: True
    - source: '{{ local_file_name }}'
    - user: root
    - onlyif:
      - '[[ $( file /tmp/cortex_signing.key ) =~ "Zip archive data" ]]'

Import extracted signing-key:
  cmd.run:
    - name: 'rpm --import /tmp/cortex_signing_key.d/cortex-xdr-agent.asc'
    - onchanges:
      - archive: 'Extract signing-key from HTTP-hosted ZIP archive'
    - onlyif:
      - '[[ -s /tmp/cortex_signing_key.d/cortex-xdr-agent.asc ]]'
    - unless:
      - '[[ $( rpm -qia gpg-pubkey\* | grep -q ''Palo Alto XDR'' )$? -eq 0 ]]'
{%- elif local_file_name.endswith('.zip') %}
Extract signing-key from S3-hosted ZIP archive:
  archive.extracted:
    - archive_format: zip
    - enforce_toplevel: False
    - group: root
    - name: '/tmp/cortex_signing_key.d'
    - skip_verify: True
    - source: '{{ local_file_name }}'
    - user: root
    - onlyif:
      - '[[ $( file /tmp/cortex_signing.key ) =~ "Zip archive data" ]]'

Import extracted signing-key:
  cmd.run:
    - name: 'rpm --import /tmp/cortex_signing_key.d/cortex-xdr-agent.asc'
    - onchanges:
      - archive: 'Extract signing-key from S3-hosted ZIP archive'
    - onlyif:
      - '[[ -s /tmp/cortex_signing_key.d/cortex-xdr-agent.asc ]]'
    - unless:
      - '[[ $( rpm -qia gpg-pubkey\* | grep -q ''Palo Alto XDR'' )$? -eq 0 ]]'
{%- elif local_file_name.endswith('.asc') %}
Import extracted signing-key:
  cmd.run:
    - name: 'rpm --import {{ local_file_name }}'
    - onchanges:
      - file: 'Download signing-key blob'
    - unless:
      - '[[ $( rpm -qia gpg-pubkey\* | grep -q ''Palo Alto XDR'' )$? -eq 0 ]]'
{%- endif %}
