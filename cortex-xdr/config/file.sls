# -*- coding: utf-8 -*-
# vim: ft=sls

{#- Get the `tplroot` from `tpldir` #}
{%- set tplroot = tpldir.split('/')[0] %}
{%- set sls_package_install = tplroot ~ '.package.install' %}
{%- from tplroot ~ "/map.jinja" import mapdata as cortex_xdr with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

# This file is part of the saltstack templates for new formulae. The Cortex
# XDR archive-bundle includes a site-optimized configuration file. The
# archive-bundle's inclusion of a config-file moots this SaltStack file.
