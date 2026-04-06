# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}


# Ensure RPM signing-key is present
include:
  - .rpm_validator_key

Cleanup Cortex XDR Archive Extraction-location:
  file.absent:
    - name: '{{ cortex_xdr.pkg.dearchive_path }}'
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
    - name: '{{ cortex_xdr.pkg.dearchive_path }}'
    - require:
      - pkg: 'Cortex XDR Agent Dependencies'
    - source_hash: '{{ cortex_xdr.pkg.source_hash }}'
    - source: '{{ cortex_xdr.pkg.source }}'
    - trim_output: True
    - user: 'root'

Cortex XDR Create Config-dir:
  file.directory:
    - dir_mode: '0700'
    - file_mode: '0600'
    - group: 'root'
    - name: '{{ cortex_xdr.config.dir }}'
    - recurse:
      - group
      - mode
      - user
    - require:
      - archive: 'Cortex XDR Archive Extraction'
    - user: 'root'

Install Cortex XDR Config-file:
  file.copy:
    - name: '{{ cortex_xdr.config.dir }}/cortex.conf'
    - group: 'root'
    - mode: '0600'
    - require:
      - file: 'Cortex XDR Create Config-dir'
    - source: '{{ cortex_xdr.pkg.dearchive_path }}/cortex.conf'
    - user: 'root'

Install Cortex XDR agent:
  pkg.installed:
    - skip_verify: True
    - sources:
      - '{{ cortex_xdr.pkg.name }}': '{{ cortex_xdr.pkg.dearchive_path }}/cortex.rpm'
    - require:
      - file: 'Install Cortex XDR Config-file'
      - cmd: 'Rename It'
      - cmd: 'Import extracted signing-key'

# This is an ugly kludge, but Saltstack's `pkg` state/method seems to hate
# wildcarded package-file names
Rename It:
  cmd.run:
    - name: 'cd {{ cortex_xdr.pkg.dearchive_path }} && mv cortex-*.rpm cortex.rpm'
    - require:
      - archive: 'Cortex XDR Archive Extraction'
    - stateful: False

Set SELinux label on Cortex XDR Config-dir:
  cmd.run:
    - name: 'restorecon -Fvr {{ cortex_xdr.config.dir }}'
    - onchanges:
      - file: 'Install Cortex XDR Config-file'
    - unless:
      - '[[ $( ls -lZd {{ cortex_xdr.config.dir }} ) =~ "system_u:" ]]'
