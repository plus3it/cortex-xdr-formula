# -*- coding: utf-8 -*-
# vim: ft=sls

include:
{%- if grains.kernel == "Linux" %}
  - cortex-xdr.package.lin_install
{%- elif grains.kernel == "Windows" %}
  - cortex-xdr.package.win_install
{%- endif %}
