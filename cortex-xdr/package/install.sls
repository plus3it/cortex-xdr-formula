# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}
{%- set cortex_pkg_name = salt.pillar.get('cortex-xdr:lookup:archive:rpm_name', 'cortex_xdr.pkg.name') %}
{%- set cortex_source_archive = salt.pillar.get('cortex-xdr:lookup:archive:source', '') %}
{%- set cortex_source_hash = salt.pillar.get('cortex-xdr:lookup:archive:source_hash', '') %}

Cortex XDR Agent Dependencies:
  pkg.installed:
    - name: selinux-policy-devel


Cortex XDR Archive Extraction:
  archive.extracted:
    - enforce_toplevel: False
    - group: 'root'
    - keep_source: False
    - name: '{{ cortex_xdr.package.dearchive_path }}'
    - require:
      - pkg: 'Cortex XDR Agent Dependencies'
    - source_hash: '{{ cortex_source_hash }}'
    - source: '{{ cortex_source_archive }}'
    - trim_output: True
    - user: 'root'

Cortex XDR Create Config-dir:
  file.directory:
    - dir_mode: '0700'
    - file_mode: '0600'
    - group: 'root'
    - name: '{{ cortex_xdr.config_dir }}'
    - recurse:
      - group
      - mode
      - user
    - require:
      - pkg: 'Cortex XDR Agent Dependencies'
    - selinux:
        serange: 's0'
        serole: 'object_r'
        setype: 'etc_t'
        seuser: 'system_u'
    - user: 'root'
