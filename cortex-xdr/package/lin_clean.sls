# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}
{%- set helper_script_loc = tplroot ~ '/files/helper_scripts' %}

include:
  - {{ sls_config_clean }}

Remove Cortex XDR agent RPM:
  pkg.removed:
    - name: {{ cortex_xdr.pkg.name }}
    - require:
      - sls: {{ sls_config_clean }}

Remove Cortex XDR agent RPM Verification-Key:
  cmd.script:
    - cwd: /root
    - source: 'salt://{{ helper_script_loc }}/gpgkey_remove.sh}
    - stateful: True
