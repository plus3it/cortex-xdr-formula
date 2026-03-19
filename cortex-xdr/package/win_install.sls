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
    'cortex_xdr.archive.source'
  )
%}
{%- set cortex_source_hash = salt.pillar.get(
    'cortex-xdr:lookup:windows_server:archive:source_hash',
    'cortex_xdr.archive.source_hash'
  )
%}

Extract Cortex XDR Agent:
  archive.extracted:
    - name: 'C:\temp\cortex_xdr_extracted'
    - source: '{{ cortex_source_archive }}'
    - source_hash: '{{ cortex_source_hash }}'
    - archive_format: zip
    - enforce_toplevel: False
    - overwrite: True
