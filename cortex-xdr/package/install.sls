# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex__xdr with context %}

Cortex XDR Agent Dependencies:
  pkg.installed:
    - name: selinux-policy-devel
