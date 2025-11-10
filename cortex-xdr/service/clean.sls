# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex__xdr with context %}

Kill the Cortex XDR agent service ({{ cortex__xdr.service.name }}):
  service.dead:
    - name: {{ cortex__xdr.service.name }}
    - enable: False
