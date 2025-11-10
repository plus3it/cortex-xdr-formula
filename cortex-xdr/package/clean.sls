# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_clean = tplroot ~ '.config.clean' %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}

Cleanup Cortex XDR Archive Extraction-location:
  file.absent:
    - name: '{{ cortex_xdr.package.dearchive_path }}'
    - require:
      - pkg: 'Install Cortex XDR agent'
