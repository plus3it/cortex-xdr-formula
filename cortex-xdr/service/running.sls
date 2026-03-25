# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_config_file = tplroot ~ '.config.file' %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}
{%- set cortex_svc_name_lin = salt.pillar.get(
    'cortex-xdr:lookup:enterprise_linux:service-name',
    cortex_xdr.service.name
  )
%}


{%- if grains.kernel == "Linux" %}
  {%- set cortex_svc_name = cortex_svc_name_lin %}
Ensure Cortex XDR agent is Running:
  service.running:
    - enable: True
    - name: '{{ cortex_svc_name }}'
    - require:
      - pkg: 'Install Cortex XDR agent'
{%- elif grains.kernel == "Windows" %}
  {#- Pull the list from parameters.os_family.Windows #}
  {%- for svc in cortex_xdr.cortex_svc_name_list %}
Ensure Cortex XDR agent service "{{ svc }}" is Running:
  service.running:
    - name: '{{ svc }}'
    - require:
      - pkg: 'Install Cortex XDR agent'
  {%- endfor %}
{%- endif %}
