# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}
{%- set cortex_pkg_name = salt.pillar.get(
    'cortex-xdr:lookup:windows_server:archive:pkg_name',
    'cortex_xdr.pkg.name'
  )
%}
{%- set cortex_source_archive = salt.pillar.get(
    'cortex-xdr:lookup:windows_server:archive:source',
    'cortex_xdr.pkg.source'
  )
%}
{%- set cortex_source_hash = salt.pillar.get(
    'cortex-xdr:lookup:windows_server:archive:source_hash',
    'cortex_xdr.pkg.source_hash'
  )
%}

Download Cortex XDR Agent archive-file:
  file.managed:
    - name: 'C:/Windows/TEMP/{{ cortex_pkg_name }}'
    - source: '{{ cortex_source_archive }}'
    - source_hash: '{{ cortex_source_hash }}'
