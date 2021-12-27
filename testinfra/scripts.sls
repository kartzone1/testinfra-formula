# -*- coding: utf-8 -*-
# vim: ft=sls

{%- from "testinfra/map.jinja" import testinfra with context %}

testinfra_scripts_create_directory:
  file.directory:
    - name: {{ testinfra.path.scripts }}
    - makedirs: True

{%- for repo_name, repo in salt['pillar.get']('testinfra:lookup:scripts', {}).items() %}

{%- if repo == None %}
{%- set repo = {} %}
{%- endif %}

{%- set address = repo.get('address') %}
{%- set revision = repo.get('revision', 'master') %}

testinfra_scripts_git_repo_{{ repo_name }}:
  git.latest:
    - name: {{ address }}
    - target: {{ testinfra.path.scripts }}/{{ repo_name }}
    - rev: {{ revision }}
    - require:
      - file: testinfra_scripts_create_directory

{%- endfor %}
