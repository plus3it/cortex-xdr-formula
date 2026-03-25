# -*- coding: utf-8 -*-
# vim: ft=sls
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}
{%- set cortex_winrepo_name = salt.pillar.get(
    'cortex-xdr:lookup:windows_server:winrepo_info:repo_name',
    cortex_xdr.pkg.repo_name
  )
%}
{%- set cortex_target_version = salt.pillar.get(
    'cortex-xdr:lookup:windows_server:winrepo_info:repo_key',
    cortex_xdr.pkg.repo_version
  )
%}

Install Cortex XDR Agent:
  pkg.installed:
    - allow_updates: True
    - name: '{{ cortex_winrepo_name }}'
    - version: '{{ cortex_target_version }}'
