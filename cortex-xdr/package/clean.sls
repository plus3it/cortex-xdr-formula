# -*- coding: utf-8 -*-
# vim: ft=sls

include:
{%- if grains.kernel == "Linux" %}
  - .lin_clean
{%- elif grains.kernel == "Windows" %}
  - .win_clean
{%- endif %}
