# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}
{%- set cortex_svc_name = salt.pillar.get('cortex-xdr:lookup:service-name', cortex_xdr.service.name) %}

Ensure Cortex XDR agent is Running:
  service.running:
    - enable: True
    - name: '{{ cortex_svc_name }}'
    - require:
      - pkg: 'Install Cortex XDR agent'
