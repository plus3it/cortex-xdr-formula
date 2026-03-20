# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}
{%- set cortex_pkg_name = salt.pillar.get(
    'cortex-xdr:lookup:windows_server:archive:msi_name',
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
{%- set cortex_display_name = 'Cortex XDR 9.1.0.20768' %}

Download and Extract Cortex XDR Agent:
  archive.extracted:
    - name: '{{ cortex_xdr.pkg.dearchive_path }}'
    - source: '{{ cortex_source_archive }}'
    - source_hash: '{{ cortex_source_hash }}'
    - archive_format: zip
    - enforce_toplevel: False
    - overwrite: True

Install Cortex XDR Agent:
  pkg.installed:
    - name: {{ cortex_display_name | json }}
    - version: '9.1.0.20768'
    - sources:
      - {{ cortex_display_name | json }}: 'C:\Windows\Temp\cortex_xdr_extracted\Windows_Agent_Pkg-v91020768_x64.msi'
    - extra_install_flags: '/qn /norestart'
    - require:
      - archive: 'Download and Extract Cortex XDR Agent'
