# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}
{%- if grains.kernel == "Linux" %}
  {%- set cortex_svc_name = 'traps_pmd.service' %}
{%- elif grains.kernel == "Windows" %}
  {%- set cortex_svc_name = 'cyserver' %}
{%- endif %}

Ensure Cortex XDR agent is Running:
  service.running:
    - enable: True
    - name: '{{ cortex_svc_name }}'
    - require:
      - pkg: 'Install Cortex XDR agent'
