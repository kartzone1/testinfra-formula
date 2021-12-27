# -*- coding: utf-8 -*-
# vim: ft=sls

{%- set tplroot = tpldir.split('/')[0] %}
{%- from "testinfra/map.jinja" import testinfra with context %}

{%- if testinfra.use_pip %}
python-pip:
  pkg.installed

testinfra-pip-packages:
  pip.installed:
    - pkgs:
      - pytest-testinfra
    {%- if 'pippkgs' in testinfra and testinfra.pippkgs is iterable %}
      {%- for pippkg in testinfra.pippkgs %}
      - {{ pippkg }}
      {%- endfor %}
    {%- endif %}
    - require:
      - pkg: python-pip
{%- endif %}

{%- if testinfra.use_distro_pkg %}
  {%- if 'pkgs' in testinfra and testinfra.pkgs is iterable %}
testinfra-packages:
  pkg.installed:
    - pkgs:
    {%- for pkg in testinfra.pkgs %}
      - {{ pkg }}
    {%- endfor %}
    {%- if testinfra.use_pip %}
    - require:
      - pip: testinfra-pip-packages 
    {%- endif %}
  {%- endif %}
{% endif %}
