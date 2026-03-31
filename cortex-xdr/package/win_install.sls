# -*- coding: utf-8 -*-
# vim: ft=sls
{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}

Install Cortex XDR Agent:
  pkg.installed:
    - allow_updates: True
    - name: '{{ cortex_xdr.pkg.name }}'
    - version: '{{ cortex_xdr.pkg.version }}'
