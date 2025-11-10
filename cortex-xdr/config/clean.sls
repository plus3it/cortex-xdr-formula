# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_service_clean = tplroot ~ '.service.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}

include:
  - {{ sls_service_clean }}

Nuke the Cortex Config-dir ({{ cortex_xdr.config_dir }}):
  file.absent:
    - name: {{ cortex_xdr.config_dir }}
    - require:
      - sls: {{ sls_service_clean }}
