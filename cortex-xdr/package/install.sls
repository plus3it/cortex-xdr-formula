# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}
{%- set cortex_pkg_name = salt.pillar.get('cortex-xdr:lookup:enterprise_linux:archive:rpm_name', 'cortex_xdr.pkg.name') %}
{%- set cortex_source_archive = salt.pillar.get('cortex-xdr:lookup:enterprise_linux:archive:source', '') %}
{%- set cortex_source_hash = salt.pillar.get('cortex-xdr:lookup:enterprise_linux:archive:source_hash', '') %}

Cleanup Cortex XDR Archive Extraction-location:
  file.absent:
    - name: '{{ cortex_xdr.package.dearchive_path }}'
    - require:
      - pkg: 'Install Cortex XDR agent'

Cortex XDR Agent Dependencies:
  pkg.installed:
    - pkgs:
      - policycoreutils-python-utils
      - selinux-policy-devel
      - selinux-policy-targeted

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
      - archive: 'Cortex XDR Archive Extraction'
    - user: 'root'

Install Cortex XDR Config-file:
  file.copy:
    - name: '{{ cortex_xdr.config_dir }}/cortex.conf'
    - group: 'root'
    - mode: '0600'
    - require:
      - file: 'Cortex XDR Create Config-dir'
    - source: '{{ cortex_xdr.package.dearchive_path }}/cortex.conf'
    - user: 'root'

Install Cortex XDR agent:
  pkg.installed:
    - sources:
      - '{{ cortex_xdr.pkg.name }}': '{{ cortex_xdr.package.dearchive_path }}/cortex.rpm'
    - require:
      - file: 'Install Cortex XDR Config-file'
      - cmd: 'Rename It'
      - cmd: 'Install Cortex XDR Agent Signing-Key'


# This is an ugly kludge, but Saltstack's `pkg` state/method seems to hate
# wildcarded package-file names
Rename It:
  cmd.run:
    - name: 'cd {{ cortex_xdr.package.dearchive_path }} && mv cortex-*.rpm cortex.rpm'
    - require:
      - archive: 'Cortex XDR Archive Extraction'
    - stateful: False

Set SELinux label on Cortex XDR Config-dir:
  cmd.run:
    - name: 'restorecon -Fvr {{ cortex_xdr.config_dir }}'
    - onchanges:
      - file: 'Install Cortex XDR Config-file'
    - unless:
      - '[[ $( ls -lZd {{ cortex_xdr.config_dir }} ) =~ "system_u:" ]]'
