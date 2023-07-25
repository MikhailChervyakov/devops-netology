# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule: `pip3 install "molecule==3.5.2"`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos_7` внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу.
```
mike@mike-VirtualBox:~/devops-netology/08-ansible-05-testing/ansible-clickhouse$ molecule test -s centos_7
---
dependency:
  name: galaxy
driver:
  name: docker
  options:
    D: true
    vv: true
lint: 'yamllint .

  ansible-lint

  flake8

  '
platforms:
  - capabilities:
      - SYS_ADMIN
    command: /usr/sbin/init
    dockerfile: ../resources/Dockerfile.j2
    env:
      ANSIBLE_USER: ansible
      DEPLOY_GROUP: deployer
      SUDO_GROUP: wheel
      container: docker
    image: centos:7
    name: centos_7
    privileged: true
    tmpfs:
      - /run
      - /tmp
    volumes:
      - /sys/fs/cgroup:/sys/fs/cgroup
provisioner:
  inventory:
    links:
      group_vars: ../resources/inventory/group_vars/
      host_vars: ../resources/inventory/host_vars/
      hosts: ../resources/inventory/hosts.yml
  name: ansible
  options:
    D: true
    vv: true
  playbooks:
    converge: ../resources/playbooks/converge.yml
verifier:
  name: ansible
  playbooks:
    verify: ../resources/tests/verify.yml

CRITICAL Failed to pre-validate.

{'driver': [{'name': ['unallowed value docker']}]}
```
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
```
Перед этим установил pip3 install molecule_docker molecule_podman
mike@mike-VirtualBox:~/devops-netology/08-ansible-05-testing/vector$ molecule init scenario --driver-name docker 
INFO     Initializing new scenario default...
INFO     Initialized scenario in /home/mike/devops-netology/08-ansible-05-testing/vector/molecule/default successfully

```
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
```
platforms:
  - name: centos_8
    image: docker.io/pycontribs/centos:8
    pre_build_image: true
  - name: ubuntu_latest
    image: docker.io/pycontribs/ubuntu:latest
    pre_build_image: true
```
4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 
```
- name: Verify
  hosts: all
  gather_facts: false
  tasks:
    - name: check vector service started
      ansible.builtin.service:
        name: vector
        state: started
```
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/08-ansible-05-testing/img/1.png)
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/08-ansible-05-testing/img/2.png)
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/08-ansible-05-testing/img/3.png)
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/08-ansible-05-testing/img/4.png)
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/08-ansible-05-testing/img/5.png)
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/08-ansible-05-testing/img/6.png)
7. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
```
mike@mike-VirtualBox:~/devops-netology/08-ansible-05-testing/vector$ docker run --privileged=True -v /home/mike/devops-netology/08-ansible-05-testing/vector:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
[root@f7eb43dfe0cb vector-role]# tox
py37-ansible210 create: /opt/vector-role/.tox/py37-ansible210
py37-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2023.7.22,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.4.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.4,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='3329827577'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py37-ansible30 create: /opt/vector-role/.tox/py37-ansible30
py37-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2023.7.22,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.4.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.4,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='3329827577'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible210 create: /opt/vector-role/.tox/py39-ansible210
py39-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==4.1.5,ansible-core==2.15.2,ansible-lint==5.1.3,arrow==1.2.3,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2023.7.22,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.18.4,jsonschema-specifications==2023.7.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,referencing==0.30.0,requests==2.31.0,resolvelib==1.0.1,rich==13.4.2,rpds-py==0.9.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.4,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='3329827577'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible30 create: /opt/vector-role/.tox/py39-ansible30
py39-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==4.1.5,ansible-core==2.15.2,ansible-lint==5.1.3,arrow==1.2.3,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2023.7.22,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.18.4,jsonschema-specifications==2023.7.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,referencing==0.30.0,requests==2.31.0,resolvelib==1.0.1,rich==13.4.2,rpds-py==0.9.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.4,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='3329827577'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
_______________________________________________________________________________________ summary ________________________________________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed
[root@f7eb43dfe0cb vector-role]# 

```
4. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
```
molecule init scenario --driver-name=podman podman
```
5. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
6. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
<details>
<summary>вывод теста</summary>
mike@mike-VirtualBox:~/devops-netology/08-ansible-05-testing/vector$ docker run --privileged=True -v /home/mike/devops-netology/08-ansible-05-testing/vector:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
[root@465a230c0088 vector-role]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2023.7.22,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.4.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.4,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='757127611'
py37-ansible210 run-test: commands[0] | pip3.9 install -r tox-requirements.txt
WARNING: test command found but not installed in testenv
  cmd: /usr/local/bin/pip3.9
  env: /opt/vector-role/.tox/py37-ansible210
Maybe you forgot to specify a dependency? See also the allowlist_externals envconfig setting.

DEPRECATION WARNING: this will be an error in tox 4 and above!
Collecting selinux
  Downloading selinux-0.3.0-py2.py3-none-any.whl (4.2 kB)
Collecting ansible-lint==5.1.3
  Downloading ansible_lint-5.1.3-py3-none-any.whl (113 kB)
     |████████████████████████████████| 113 kB 810 kB/s 
Collecting yamllint==1.26.3
  Downloading yamllint-1.26.3.tar.gz (126 kB)
     |████████████████████████████████| 126 kB 1.2 MB/s 
Collecting lxml
  Downloading lxml-4.9.3-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl (7.1 MB)
     |████████████████████████████████| 7.1 MB 1.2 MB/s 
Collecting molecule==3.4.0
  Downloading molecule-3.4.0-py3-none-any.whl (239 kB)
     |████████████████████████████████| 239 kB 1.1 MB/s 
Collecting molecule_podman
  Downloading molecule_podman-2.0.3-py3-none-any.whl (15 kB)
Collecting jmespath
  Downloading jmespath-1.0.1-py3-none-any.whl (20 kB)
Collecting distro>=1.3.0
  Downloading distro-1.8.0-py3-none-any.whl (20 kB)
Collecting wcmatch>=7.0
  Downloading wcmatch-8.4.1-py3-none-any.whl (39 kB)
Collecting enrich>=1.2.6
  Downloading enrich-1.2.7-py3-none-any.whl (8.7 kB)
Collecting rich>=9.5.1
  Downloading rich-13.4.2-py3-none-any.whl (239 kB)
     |████████████████████████████████| 239 kB 1.1 MB/s 
Collecting ruamel.yaml<1,>=0.15.37; python_version >= "3.7"
  Downloading ruamel.yaml-0.17.32-py3-none-any.whl (112 kB)
     |████████████████████████████████| 112 kB 1.1 MB/s 
Collecting tenacity
  Downloading tenacity-8.2.2-py3-none-any.whl (24 kB)
Collecting pyyaml
  Downloading PyYAML-6.0.1-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (738 kB)
     |████████████████████████████████| 738 kB 1.1 MB/s 
Collecting packaging
  Downloading packaging-23.1-py3-none-any.whl (48 kB)
     |████████████████████████████████| 48 kB 873 kB/s 
Collecting pathspec>=0.5.3
  Downloading pathspec-0.11.1-py3-none-any.whl (29 kB)
Requirement already satisfied: setuptools in /usr/local/lib/python3.9/site-packages (from yamllint==1.26.3->-r tox-requirements.txt (line 3)) (49.2.1)
Collecting pluggy<1.0,>=0.7.1
  Downloading pluggy-0.13.1-py2.py3-none-any.whl (18 kB)
Collecting cookiecutter>=1.7.3
  Downloading cookiecutter-2.2.3-py3-none-any.whl (39 kB)
Collecting click<9,>=8.0
  Downloading click-8.1.6-py3-none-any.whl (97 kB)
     |████████████████████████████████| 97 kB 657 kB/s 
Collecting subprocess-tee>=0.3.2
  Downloading subprocess_tee-0.4.1-py3-none-any.whl (5.1 kB)
Collecting cerberus!=1.3.3,!=1.3.4,>=1.3.1
  Downloading Cerberus-1.3.2.tar.gz (52 kB)
     |████████████████████████████████| 52 kB 46 kB/s 
Collecting paramiko<3,>=2.5.0
  Downloading paramiko-2.12.0-py2.py3-none-any.whl (213 kB)
     |████████████████████████████████| 213 kB 994 kB/s 
Collecting click-help-colors>=0.9
  Downloading click_help_colors-0.9.1-py3-none-any.whl (5.5 kB)
Collecting Jinja2>=2.11.3
  Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
     |████████████████████████████████| 133 kB 1.1 MB/s 
Collecting ansible-compat>=2.2.0
  Downloading ansible_compat-4.1.5-py3-none-any.whl (22 kB)
Collecting bracex>=2.1.1
  Downloading bracex-2.3.post1-py3-none-any.whl (12 kB)
Collecting pygments<3.0.0,>=2.13.0
  Downloading Pygments-2.15.1-py3-none-any.whl (1.1 MB)
     |████████████████████████████████| 1.1 MB 1.0 MB/s 
Collecting markdown-it-py>=2.2.0
  Downloading markdown_it_py-3.0.0-py3-none-any.whl (87 kB)
     |████████████████████████████████| 87 kB 764 kB/s 
Collecting ruamel.yaml.clib>=0.2.7; platform_python_implementation == "CPython" and python_version < "3.12"
  Downloading ruamel.yaml.clib-0.2.7-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl (519 kB)
     |████████████████████████████████| 519 kB 1.1 MB/s 
Collecting python-slugify>=4.0.0
  Downloading python_slugify-8.0.1-py2.py3-none-any.whl (9.7 kB)
Collecting arrow
  Downloading arrow-1.2.3-py3-none-any.whl (66 kB)
     |████████████████████████████████| 66 kB 852 kB/s 
Collecting requests>=2.23.0
  Downloading requests-2.31.0-py3-none-any.whl (62 kB)
     |████████████████████████████████| 62 kB 420 kB/s 
Collecting binaryornot>=0.4.4
  Downloading binaryornot-0.4.4-py2.py3-none-any.whl (9.0 kB)
Collecting cryptography>=2.5
  Downloading cryptography-41.0.2-cp37-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (4.3 MB)
     |████████████████████████████████| 4.3 MB 851 kB/s 
Collecting pynacl>=1.0.1
  Downloading PyNaCl-1.5.0-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl (856 kB)
     |████████████████████████████████| 856 kB 1.0 MB/s 
Collecting bcrypt>=3.1.3
  Downloading bcrypt-4.0.1-cp36-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (593 kB)
     |████████████████████████████████| 593 kB 1.1 MB/s 
Collecting six
  Using cached six-1.16.0-py2.py3-none-any.whl (11 kB)
Collecting MarkupSafe>=2.0
  Downloading MarkupSafe-2.1.3-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
Collecting typing-extensions>=4.5.0; python_version < "3.10"
  Downloading typing_extensions-4.7.1-py3-none-any.whl (33 kB)
Collecting ansible-core>=2.12
  Downloading ansible_core-2.15.2-py3-none-any.whl (2.2 MB)
     |████████████████████████████████| 2.2 MB 1.0 MB/s 
Collecting jsonschema>=4.6.0
  Downloading jsonschema-4.18.4-py3-none-any.whl (80 kB)
     |████████████████████████████████| 80 kB 687 kB/s 
Collecting mdurl~=0.1
  Downloading mdurl-0.1.2-py3-none-any.whl (10.0 kB)
Collecting text-unidecode>=1.3
  Downloading text_unidecode-1.3-py2.py3-none-any.whl (78 kB)
     |████████████████████████████████| 78 kB 726 kB/s 
Collecting python-dateutil>=2.7.0
  Downloading python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
     |████████████████████████████████| 247 kB 939 kB/s 
Collecting urllib3<3,>=1.21.1
  Downloading urllib3-2.0.4-py3-none-any.whl (123 kB)
     |████████████████████████████████| 123 kB 1.1 MB/s 
Collecting idna<4,>=2.5
  Downloading idna-3.4-py3-none-any.whl (61 kB)
     |████████████████████████████████| 61 kB 21 kB/s 
Collecting charset-normalizer<4,>=2
  Downloading charset_normalizer-3.2.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (202 kB)
     |████████████████████████████████| 202 kB 1.0 MB/s 
Collecting certifi>=2017.4.17
  Downloading certifi-2023.7.22-py3-none-any.whl (158 kB)
     |████████████████████████████████| 158 kB 1.0 MB/s 
Collecting chardet>=3.0.2
  Downloading chardet-5.1.0-py3-none-any.whl (199 kB)
     |████████████████████████████████| 199 kB 936 kB/s 
Collecting cffi>=1.12
  Downloading cffi-1.15.1-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (441 kB)
     |████████████████████████████████| 441 kB 1.2 MB/s 
Collecting importlib-resources<5.1,>=5.0; python_version < "3.10"
  Downloading importlib_resources-5.0.7-py3-none-any.whl (24 kB)
Collecting resolvelib<1.1.0,>=0.5.3
  Downloading resolvelib-1.0.1-py2.py3-none-any.whl (17 kB)
Collecting attrs>=22.2.0
  Downloading attrs-23.1.0-py3-none-any.whl (61 kB)
     |████████████████████████████████| 61 kB 801 kB/s 
Collecting rpds-py>=0.7.1
  Downloading rpds_py-0.9.2-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (1.2 MB)
     |████████████████████████████████| 1.2 MB 904 kB/s 
Collecting referencing>=0.28.4
  Downloading referencing-0.30.0-py3-none-any.whl (25 kB)
Collecting jsonschema-specifications>=2023.03.6
  Downloading jsonschema_specifications-2023.7.1-py3-none-any.whl (17 kB)
Collecting pycparser
  Downloading pycparser-2.21-py2.py3-none-any.whl (118 kB)
     |████████████████████████████████| 118 kB 1.0 MB/s 
Using legacy 'setup.py install' for yamllint, since package 'wheel' is not installed.
Using legacy 'setup.py install' for cerberus, since package 'wheel' is not installed.
Installing collected packages: distro, selinux, bracex, wcmatch, pygments, mdurl, markdown-it-py, rich, enrich, ruamel.yaml.clib, ruamel.yaml, tenacity, pyyaml, packaging, ansible-lint, pathspec, yamllint, lxml, pluggy, click, MarkupSafe, Jinja2, text-unidecode, python-slugify, six, python-dateutil, arrow, urllib3, idna, charset-normalizer, certifi, requests, chardet, binaryornot, cookiecutter, subprocess-tee, cerberus, pycparser, cffi, cryptography, pynacl, bcrypt, paramiko, click-help-colors, molecule, typing-extensions, importlib-resources, resolvelib, ansible-core, attrs, rpds-py, referencing, jsonschema-specifications, jsonschema, ansible-compat, molecule-podman, jmespath
    Running setup.py install for yamllint ... done
    Running setup.py install for cerberus ... done
ERROR: After October 2020 you may experience errors when installing or updating packages. This is because pip will change the way that it resolves dependency conflicts.

We recommend you use --use-feature=2020-resolver to test your packages with the new resolver before it becomes the default.

molecule 3.4.0 requires PyYAML<6,>=5.1, but you'll have pyyaml 6.0.1 which is incompatible.
molecule-podman 2.0.3 requires molecule>=4.0.0, but you'll have molecule 3.4.0 which is incompatible.
Successfully installed Jinja2-3.1.2 MarkupSafe-2.1.3 ansible-compat-4.1.5 ansible-core-2.15.2 ansible-lint-5.1.3 arrow-1.2.3 attrs-23.1.0 bcrypt-4.0.1 binaryornot-0.4.4 bracex-2.3.post1 cerberus-1.3.2 certifi-2023.7.22 cffi-1.15.1 chardet-5.1.0 charset-normalizer-3.2.0 click-8.1.6 click-help-colors-0.9.1 cookiecutter-2.2.3 cryptography-41.0.2 distro-1.8.0 enrich-1.2.7 idna-3.4 importlib-resources-5.0.7 jmespath-1.0.1 jsonschema-4.18.4 jsonschema-specifications-2023.7.1 lxml-4.9.3 markdown-it-py-3.0.0 mdurl-0.1.2 molecule-3.4.0 molecule-podman-2.0.3 packaging-23.1 paramiko-2.12.0 pathspec-0.11.1 pluggy-0.13.1 pycparser-2.21 pygments-2.15.1 pynacl-1.5.0 python-dateutil-2.8.2 python-slugify-8.0.1 pyyaml-6.0.1 referencing-0.30.0 requests-2.31.0 resolvelib-1.0.1 rich-13.4.2 rpds-py-0.9.2 ruamel.yaml-0.17.32 ruamel.yaml.clib-0.2.7 selinux-0.3.0 six-1.16.0 subprocess-tee-0.4.1 tenacity-8.2.2 text-unidecode-1.3 typing-extensions-4.7.1 urllib3-2.0.4 wcmatch-8.4.1 yamllint-1.26.3
WARNING: You are using pip version 20.2.3; however, version 23.2.1 is available.
You should consider upgrading via the '/usr/local/bin/python3.9 -m pip install --upgrade pip' command.
py37-ansible210 run-test: commands[1] | molecule test -s podman
INFO     podman scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git': 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/chervyakov.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running podman > dependency
INFO     Running ansible-galaxy collection install --force -v containers.podman:>=1.7.0
INFO     Running ansible-galaxy collection install --force -v ansible.posix:>=1.3.0
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running podman > lint
INFO     Lint is disabled.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '720406711825.101', 'results_file': '/root/.ansible_async/720406711825.101', 'changed': True, 'failed': False, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running podman > syntax

playbook: /opt/vector-role/molecule/podman/converge.yml
INFO     Running podman > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: quay.io/centos/centos:stream8") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=quay.io/centos/centos:stream8) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (298 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (297 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (296 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (295 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (294 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (293 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (292 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running podman > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Copy something to test use of synchronize module] ************************
changed: [instance]

TASK [Include vector] **********************************************************
ERROR! the role 'vector' was not found in /opt/vector-role/molecule/podman/roles:/root/.cache/molecule/vector-role/podman/roles:/opt:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles:/opt/vector-role/molecule/podman

The error appears to be in '/opt/vector-role/molecule/podman/converge.yml': line 12, column 15, but may
be elsewhere in the file depending on the exact syntax problem.

The offending line appears to be:

      ansible.builtin.include_role:
        name: "vector"
              ^ here

PLAY RECAP *********************************************************************
instance                   : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/root/.cache/molecule/vector-role/podman/inventory', '--skip-tags', 'molecule-notest,notest', '/opt/vector-role/molecule/podman/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '270063777600.981', 'results_file': '/root/.ansible_async/270063777600.981', 'changed': True, 'failed': False, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s podman (exited with code 1)
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2023.7.22,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.4.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.4,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='757127611'
py37-ansible30 run-test: commands[0] | pip3.9 install -r tox-requirements.txt
WARNING: test command found but not installed in testenv
  cmd: /usr/local/bin/pip3.9
  env: /opt/vector-role/.tox/py37-ansible30
Maybe you forgot to specify a dependency? See also the allowlist_externals envconfig setting.

DEPRECATION WARNING: this will be an error in tox 4 and above!
Requirement already satisfied: selinux in /usr/local/lib/python3.9/site-packages (from -r tox-requirements.txt (line 1)) (0.3.0)
Requirement already satisfied: ansible-lint==5.1.3 in /usr/local/lib/python3.9/site-packages (from -r tox-requirements.txt (line 2)) (5.1.3)
Requirement already satisfied: yamllint==1.26.3 in /usr/local/lib/python3.9/site-packages (from -r tox-requirements.txt (line 3)) (1.26.3)
Requirement already satisfied: lxml in /usr/local/lib/python3.9/site-packages (from -r tox-requirements.txt (line 4)) (4.9.3)
Requirement already satisfied: molecule==3.4.0 in /usr/local/lib/python3.9/site-packages (from -r tox-requirements.txt (line 5)) (3.4.0)
Requirement already satisfied: molecule_podman in /usr/local/lib/python3.9/site-packages (from -r tox-requirements.txt (line 6)) (2.0.3)
Requirement already satisfied: jmespath in /usr/local/lib/python3.9/site-packages (from -r tox-requirements.txt (line 7)) (1.0.1)
Requirement already satisfied: distro>=1.3.0 in /usr/local/lib/python3.9/site-packages (from selinux->-r tox-requirements.txt (line 1)) (1.8.0)
Requirement already satisfied: wcmatch>=7.0 in /usr/local/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (8.4.1)
Requirement already satisfied: enrich>=1.2.6 in /usr/local/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (1.2.7)
Requirement already satisfied: rich>=9.5.1 in /usr/local/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (13.4.2)
Requirement already satisfied: ruamel.yaml<1,>=0.15.37; python_version >= "3.7" in /usr/local/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (0.17.32)
Requirement already satisfied: tenacity in /usr/local/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (8.2.2)
Requirement already satisfied: pyyaml in /usr/local/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (6.0.1)
Requirement already satisfied: packaging in /usr/local/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (23.1)
Requirement already satisfied: pathspec>=0.5.3 in /usr/local/lib/python3.9/site-packages (from yamllint==1.26.3->-r tox-requirements.txt (line 3)) (0.11.1)
Requirement already satisfied: setuptools in /usr/local/lib/python3.9/site-packages (from yamllint==1.26.3->-r tox-requirements.txt (line 3)) (49.2.1)
Requirement already satisfied: pluggy<1.0,>=0.7.1 in /usr/local/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.13.1)
Requirement already satisfied: cookiecutter>=1.7.3 in /usr/local/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.2.3)
Requirement already satisfied: click<9,>=8.0 in /usr/local/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (8.1.6)
Requirement already satisfied: subprocess-tee>=0.3.2 in /usr/local/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.4.1)
Requirement already satisfied: cerberus!=1.3.3,!=1.3.4,>=1.3.1 in /usr/local/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.3.2)
Requirement already satisfied: paramiko<3,>=2.5.0 in /usr/local/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.12.0)
Requirement already satisfied: click-help-colors>=0.9 in /usr/local/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.9.1)
Requirement already satisfied: Jinja2>=2.11.3 in /usr/local/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (3.1.2)
Requirement already satisfied: ansible-compat>=2.2.0 in /usr/local/lib/python3.9/site-packages (from molecule_podman->-r tox-requirements.txt (line 6)) (4.1.5)
Requirement already satisfied: bracex>=2.1.1 in /usr/local/lib/python3.9/site-packages (from wcmatch>=7.0->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (2.3.post1)
Requirement already satisfied: pygments<3.0.0,>=2.13.0 in /usr/local/lib/python3.9/site-packages (from rich>=9.5.1->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (2.15.1)
Requirement already satisfied: markdown-it-py>=2.2.0 in /usr/local/lib/python3.9/site-packages (from rich>=9.5.1->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (3.0.0)
Requirement already satisfied: ruamel.yaml.clib>=0.2.7; platform_python_implementation == "CPython" and python_version < "3.12" in /usr/local/lib/python3.9/site-packages (from ruamel.yaml<1,>=0.15.37; python_version >= "3.7"->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (0.2.7)
Requirement already satisfied: python-slugify>=4.0.0 in /usr/local/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (8.0.1)
Requirement already satisfied: arrow in /usr/local/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.2.3)
Requirement already satisfied: requests>=2.23.0 in /usr/local/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.31.0)
Requirement already satisfied: binaryornot>=0.4.4 in /usr/local/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.4.4)
Requirement already satisfied: cryptography>=2.5 in /usr/local/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (41.0.2)
Requirement already satisfied: pynacl>=1.0.1 in /usr/local/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.5.0)
Requirement already satisfied: bcrypt>=3.1.3 in /usr/local/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (4.0.1)
Requirement already satisfied: six in /usr/local/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.16.0)
Requirement already satisfied: MarkupSafe>=2.0 in /usr/local/lib/python3.9/site-packages (from Jinja2>=2.11.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.1.3)
Requirement already satisfied: typing-extensions>=4.5.0; python_version < "3.10" in /usr/local/lib/python3.9/site-packages (from ansible-compat>=2.2.0->molecule_podman->-r tox-requirements.txt (line 6)) (4.7.1)
Requirement already satisfied: ansible-core>=2.12 in /usr/local/lib/python3.9/site-packages (from ansible-compat>=2.2.0->molecule_podman->-r tox-requirements.txt (line 6)) (2.15.2)
Requirement already satisfied: jsonschema>=4.6.0 in /usr/local/lib/python3.9/site-packages (from ansible-compat>=2.2.0->molecule_podman->-r tox-requirements.txt (line 6)) (4.18.4)
Requirement already satisfied: mdurl~=0.1 in /usr/local/lib/python3.9/site-packages (from markdown-it-py>=2.2.0->rich>=9.5.1->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (0.1.2)
Requirement already satisfied: text-unidecode>=1.3 in /usr/local/lib/python3.9/site-packages (from python-slugify>=4.0.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.3)
Requirement already satisfied: python-dateutil>=2.7.0 in /usr/local/lib/python3.9/site-packages (from arrow->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.8.2)
Requirement already satisfied: urllib3<3,>=1.21.1 in /usr/local/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.0.4)
Requirement already satisfied: idna<4,>=2.5 in /usr/local/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (3.4)
Requirement already satisfied: charset-normalizer<4,>=2 in /usr/local/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (3.2.0)
Requirement already satisfied: certifi>=2017.4.17 in /usr/local/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2023.7.22)
Requirement already satisfied: chardet>=3.0.2 in /usr/local/lib/python3.9/site-packages (from binaryornot>=0.4.4->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (5.1.0)
Requirement already satisfied: cffi>=1.12 in /usr/local/lib/python3.9/site-packages (from cryptography>=2.5->paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.15.1)
Requirement already satisfied: importlib-resources<5.1,>=5.0; python_version < "3.10" in /usr/local/lib/python3.9/site-packages (from ansible-core>=2.12->ansible-compat>=2.2.0->molecule_podman->-r tox-requirements.txt (line 6)) (5.0.7)
Requirement already satisfied: resolvelib<1.1.0,>=0.5.3 in /usr/local/lib/python3.9/site-packages (from ansible-core>=2.12->ansible-compat>=2.2.0->molecule_podman->-r tox-requirements.txt (line 6)) (1.0.1)
Requirement already satisfied: attrs>=22.2.0 in /usr/local/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=2.2.0->molecule_podman->-r tox-requirements.txt (line 6)) (23.1.0)
Requirement already satisfied: rpds-py>=0.7.1 in /usr/local/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=2.2.0->molecule_podman->-r tox-requirements.txt (line 6)) (0.9.2)
Requirement already satisfied: referencing>=0.28.4 in /usr/local/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=2.2.0->molecule_podman->-r tox-requirements.txt (line 6)) (0.30.0)
Requirement already satisfied: jsonschema-specifications>=2023.03.6 in /usr/local/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=2.2.0->molecule_podman->-r tox-requirements.txt (line 6)) (2023.7.1)
Requirement already satisfied: pycparser in /usr/local/lib/python3.9/site-packages (from cffi>=1.12->cryptography>=2.5->paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.21)
WARNING: You are using pip version 20.2.3; however, version 23.2.1 is available.
You should consider upgrading via the '/usr/local/bin/python3.9 -m pip install --upgrade pip' command.
py37-ansible30 run-test: commands[1] | molecule test -s podman
INFO     podman scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git': 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/chervyakov.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running podman > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running podman > lint
INFO     Lint is disabled.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '395838253002.1137', 'results_file': '/root/.ansible_async/395838253002.1137', 'changed': True, 'failed': False, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running podman > syntax

playbook: /opt/vector-role/molecule/podman/converge.yml
INFO     Running podman > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="instance registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: quay.io/centos/centos:stream8") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=instance)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=quay.io/centos/centos:stream8) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="instance command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=instance: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=instance)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
changed: [localhost] => (item=instance)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running podman > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [instance]

TASK [Copy something to test use of synchronize module] ************************
changed: [instance]

TASK [Include vector] **********************************************************
ERROR! the role 'vector' was not found in /opt/vector-role/molecule/podman/roles:/root/.cache/molecule/vector-role/podman/roles:/opt:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles:/opt/vector-role/molecule/podman

The error appears to be in '/opt/vector-role/molecule/podman/converge.yml': line 12, column 15, but may
be elsewhere in the file depending on the exact syntax problem.

The offending line appears to be:

      ansible.builtin.include_role:
        name: "vector"
              ^ here

PLAY RECAP *********************************************************************
instance                   : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

CRITICAL Ansible return code was 2, command was: ['ansible-playbook', '--inventory', '/root/.cache/molecule/vector-role/podman/inventory', '--skip-tags', 'molecule-notest,notest', '/opt/vector-role/molecule/podman/converge.yml']
WARNING  An error occurred during the test sequence action: 'converge'. Cleaning up.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '479316804181.1860', 'results_file': '/root/.ansible_async/479316804181.1860', 'changed': True, 'failed': False, 'item': {'image': 'quay.io/centos/centos:stream8', 'name': 'instance', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s podman (exited with code 1)
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==4.1.5,ansible-core==2.15.2,ansible-lint==5.1.3,arrow==1.2.3,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2023.7.22,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.18.4,jsonschema-specifications==2023.7.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,referencing==0.30.0,requests==2.31.0,resolvelib==1.0.1,rich==13.4.2,rpds-py==0.9.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.4,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='757127611'
py39-ansible210 run-test: commands[0] | pip3.9 install -r tox-requirements.txt
Requirement already satisfied: selinux in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r tox-requirements.txt (line 1)) (0.3.0)
Requirement already satisfied: ansible-lint==5.1.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r tox-requirements.txt (line 2)) (5.1.3)
Requirement already satisfied: yamllint==1.26.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r tox-requirements.txt (line 3)) (1.26.3)
Requirement already satisfied: lxml in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r tox-requirements.txt (line 4)) (4.9.3)
Requirement already satisfied: molecule==3.4.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r tox-requirements.txt (line 5)) (3.4.0)
Requirement already satisfied: molecule_podman in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r tox-requirements.txt (line 6)) (1.0.1)
Requirement already satisfied: jmespath in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r tox-requirements.txt (line 7)) (1.0.1)
Requirement already satisfied: wcmatch>=7.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (8.4.1)
Requirement already satisfied: enrich>=1.2.6 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (1.2.7)
Requirement already satisfied: rich>=9.5.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (13.4.2)
Requirement already satisfied: ruamel.yaml<1,>=0.15.37 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (0.17.32)
Requirement already satisfied: tenacity in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (8.2.2)
Requirement already satisfied: pyyaml in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (5.4.1)
Requirement already satisfied: packaging in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (23.1)
Requirement already satisfied: setuptools in ./.tox/py39-ansible210/lib/python3.9/site-packages (from yamllint==1.26.3->-r tox-requirements.txt (line 3)) (62.1.0)
Requirement already satisfied: pathspec>=0.5.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from yamllint==1.26.3->-r tox-requirements.txt (line 3)) (0.11.1)
Requirement already satisfied: pluggy<1.0,>=0.7.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.13.1)
Requirement already satisfied: cookiecutter>=1.7.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.2.3)
Requirement already satisfied: click<9,>=8.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (8.1.6)
Requirement already satisfied: subprocess-tee>=0.3.2 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.4.1)
Requirement already satisfied: cerberus!=1.3.3,!=1.3.4,>=1.3.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.3.2)
Requirement already satisfied: paramiko<3,>=2.5.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.12.0)
Requirement already satisfied: click-help-colors>=0.9 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.9.1)
Requirement already satisfied: Jinja2>=2.11.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (3.1.2)
Requirement already satisfied: distro>=1.3.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from selinux->-r tox-requirements.txt (line 1)) (1.8.0)
Requirement already satisfied: ansible-compat>=0.5.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from molecule_podman->-r tox-requirements.txt (line 6)) (4.1.5)
Requirement already satisfied: typing-extensions>=4.5.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (4.7.1)
Requirement already satisfied: ansible-core>=2.12 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (2.15.2)
Requirement already satisfied: jsonschema>=4.6.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (4.18.4)
Requirement already satisfied: python-slugify>=4.0.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (8.0.1)
Requirement already satisfied: arrow in ./.tox/py39-ansible210/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.2.3)
Requirement already satisfied: requests>=2.23.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.31.0)
Requirement already satisfied: binaryornot>=0.4.4 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.4.4)
Requirement already satisfied: MarkupSafe>=2.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from Jinja2>=2.11.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.1.3)
Requirement already satisfied: cryptography>=2.5 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (41.0.2)
Requirement already satisfied: pynacl>=1.0.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.5.0)
Requirement already satisfied: bcrypt>=3.1.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (4.0.1)
Requirement already satisfied: six in ./.tox/py39-ansible210/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.16.0)
Requirement already satisfied: pygments<3.0.0,>=2.13.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from rich>=9.5.1->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (2.15.1)
Requirement already satisfied: markdown-it-py>=2.2.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from rich>=9.5.1->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (3.0.0)
Requirement already satisfied: ruamel.yaml.clib>=0.2.7 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ruamel.yaml<1,>=0.15.37->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (0.2.7)
Requirement already satisfied: bracex>=2.1.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from wcmatch>=7.0->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (2.3.post1)
Requirement already satisfied: importlib-resources<5.1,>=5.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-core>=2.12->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (5.0.7)
Requirement already satisfied: resolvelib<1.1.0,>=0.5.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-core>=2.12->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (1.0.1)
Requirement already satisfied: chardet>=3.0.2 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from binaryornot>=0.4.4->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (5.1.0)
Requirement already satisfied: cffi>=1.12 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from cryptography>=2.5->paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.15.1)
Requirement already satisfied: attrs>=22.2.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (23.1.0)
Requirement already satisfied: rpds-py>=0.7.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (0.9.2)
Requirement already satisfied: referencing>=0.28.4 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (0.30.0)
Requirement already satisfied: jsonschema-specifications>=2023.03.6 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (2023.7.1)
Requirement already satisfied: mdurl~=0.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from markdown-it-py>=2.2.0->rich>=9.5.1->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (0.1.2)
Requirement already satisfied: text-unidecode>=1.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from python-slugify>=4.0.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.3)
Requirement already satisfied: urllib3<3,>=1.21.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.0.4)
Requirement already satisfied: idna<4,>=2.5 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (3.4)
Requirement already satisfied: charset-normalizer<4,>=2 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (3.2.0)
Requirement already satisfied: certifi>=2017.4.17 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2023.7.22)
Requirement already satisfied: python-dateutil>=2.7.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from arrow->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.8.2)
Requirement already satisfied: pycparser in ./.tox/py39-ansible210/lib/python3.9/site-packages (from cffi>=1.12->cryptography>=2.5->paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.21)
WARNING: You are using pip version 22.0.4; however, version 23.2.1 is available.
You should consider upgrading via the '/opt/vector-role/.tox/py39-ansible210/bin/python -m pip install --upgrade pip' command.
py39-ansible210 run-test: commands[1] | molecule test -s podman
INFO     podman scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/chervyakov.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running podman > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running podman > lint
INFO     Lint is disabled.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'
Traceback (most recent call last):
  File "/opt/vector-role/.tox/py39-ansible210/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1157, in __call__
    return self.main(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1078, in main
    rv = self.invoke(ctx)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1688, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 1434, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/core.py", line 783, in invoke
    return __callback(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/click/decorators.py", line 33, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/test.py", line 159, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/base.py", line 119, in execute_cmdline_scenarios
    execute_scenario(scenario)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/base.py", line 161, in execute_scenario
    execute_subcommand(scenario.config, action)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/base.py", line 150, in execute_subcommand
    return command(config).execute()
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/logger.py", line 187, in wrapper
    rt = func(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/command/destroy.py", line 107, in execute
    self._config.provisioner.destroy()
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/provisioner/ansible.py", line 705, in destroy
    pb.execute()
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule/provisioner/ansible_playbook.py", line 106, in execute
    self._config.driver.sanity_checks()
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/molecule_podman/driver.py", line 212, in sanity_checks
    if runtime.version < Version("2.10.0") and runtime.config.ansible_pipelining:
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible_compat/runtime.py", line 375, in version
    self._version = parse_ansible_version(proc.stdout)
  File "/opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible_compat/config.py", line 42, in parse_ansible_version
    raise InvalidPrerequisiteError(msg)
ansible_compat.errors.InvalidPrerequisiteError: Unable to parse ansible cli version: ansible 2.10.17
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /opt/vector-role/.tox/py39-ansible210/lib/python3.9/site-packages/ansible
  executable location = /opt/vector-role/.tox/py39-ansible210/bin/ansible
  python version = 3.9.2 (default, Jun 13 2022, 19:42:33) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10)]

Keep in mind that only 2.12 or newer are supported.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s podman (exited with code 1)
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==4.1.5,ansible-core==2.15.2,ansible-lint==5.1.3,arrow==1.2.3,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2023.7.22,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.18.4,jsonschema-specifications==2023.7.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.4.0,molecule-podman==1.0.1,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==0.13.1,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,referencing==0.30.0,requests==2.31.0,resolvelib==1.0.1,rich==13.4.2,rpds-py==0.9.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.4,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='757127611'
py39-ansible30 run-test: commands[0] | pip3.9 install -r tox-requirements.txt
Requirement already satisfied: selinux in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r tox-requirements.txt (line 1)) (0.3.0)
Requirement already satisfied: ansible-lint==5.1.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r tox-requirements.txt (line 2)) (5.1.3)
Requirement already satisfied: yamllint==1.26.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r tox-requirements.txt (line 3)) (1.26.3)
Requirement already satisfied: lxml in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r tox-requirements.txt (line 4)) (4.9.3)
Requirement already satisfied: molecule==3.4.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r tox-requirements.txt (line 5)) (3.4.0)
Requirement already satisfied: molecule_podman in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r tox-requirements.txt (line 6)) (1.0.1)
Requirement already satisfied: jmespath in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r tox-requirements.txt (line 7)) (1.0.1)
Requirement already satisfied: wcmatch>=7.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (8.4.1)
Requirement already satisfied: enrich>=1.2.6 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (1.2.7)
Requirement already satisfied: rich>=9.5.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (13.4.2)
Requirement already satisfied: ruamel.yaml<1,>=0.15.37 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (0.17.32)
Requirement already satisfied: tenacity in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (8.2.2)
Requirement already satisfied: pyyaml in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (5.4.1)
Requirement already satisfied: packaging in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (23.1)
Requirement already satisfied: setuptools in ./.tox/py39-ansible30/lib/python3.9/site-packages (from yamllint==1.26.3->-r tox-requirements.txt (line 3)) (62.1.0)
Requirement already satisfied: pathspec>=0.5.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from yamllint==1.26.3->-r tox-requirements.txt (line 3)) (0.11.1)
Requirement already satisfied: pluggy<1.0,>=0.7.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.13.1)
Requirement already satisfied: cookiecutter>=1.7.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.2.3)
Requirement already satisfied: click<9,>=8.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (8.1.6)
Requirement already satisfied: subprocess-tee>=0.3.2 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.4.1)
Requirement already satisfied: cerberus!=1.3.3,!=1.3.4,>=1.3.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.3.2)
Requirement already satisfied: paramiko<3,>=2.5.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.12.0)
Requirement already satisfied: click-help-colors>=0.9 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.9.1)
Requirement already satisfied: Jinja2>=2.11.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from molecule==3.4.0->-r tox-requirements.txt (line 5)) (3.1.2)
Requirement already satisfied: distro>=1.3.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from selinux->-r tox-requirements.txt (line 1)) (1.8.0)
Requirement already satisfied: ansible-compat>=0.5.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from molecule_podman->-r tox-requirements.txt (line 6)) (4.1.5)
Requirement already satisfied: typing-extensions>=4.5.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (4.7.1)
Requirement already satisfied: ansible-core>=2.12 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (2.15.2)
Requirement already satisfied: jsonschema>=4.6.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (4.18.4)
Requirement already satisfied: python-slugify>=4.0.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (8.0.1)
Requirement already satisfied: arrow in ./.tox/py39-ansible30/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.2.3)
Requirement already satisfied: requests>=2.23.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.31.0)
Requirement already satisfied: binaryornot>=0.4.4 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (0.4.4)
Requirement already satisfied: MarkupSafe>=2.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from Jinja2>=2.11.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.1.3)
Requirement already satisfied: cryptography>=2.5 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (41.0.2)
Requirement already satisfied: pynacl>=1.0.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.5.0)
Requirement already satisfied: bcrypt>=3.1.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (4.0.1)
Requirement already satisfied: six in ./.tox/py39-ansible30/lib/python3.9/site-packages (from paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.16.0)
Requirement already satisfied: pygments<3.0.0,>=2.13.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from rich>=9.5.1->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (2.15.1)
Requirement already satisfied: markdown-it-py>=2.2.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from rich>=9.5.1->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (3.0.0)
Requirement already satisfied: ruamel.yaml.clib>=0.2.7 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ruamel.yaml<1,>=0.15.37->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (0.2.7)
Requirement already satisfied: bracex>=2.1.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from wcmatch>=7.0->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (2.3.post1)
Requirement already satisfied: importlib-resources<5.1,>=5.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-core>=2.12->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (5.0.7)
Requirement already satisfied: resolvelib<1.1.0,>=0.5.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-core>=2.12->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (1.0.1)
Requirement already satisfied: chardet>=3.0.2 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from binaryornot>=0.4.4->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (5.1.0)
Requirement already satisfied: cffi>=1.12 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from cryptography>=2.5->paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.15.1)
Requirement already satisfied: attrs>=22.2.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (23.1.0)
Requirement already satisfied: rpds-py>=0.7.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (0.9.2)
Requirement already satisfied: referencing>=0.28.4 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (0.30.0)
Requirement already satisfied: jsonschema-specifications>=2023.03.6 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from jsonschema>=4.6.0->ansible-compat>=0.5.0->molecule_podman->-r tox-requirements.txt (line 6)) (2023.7.1)
Requirement already satisfied: mdurl~=0.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from markdown-it-py>=2.2.0->rich>=9.5.1->ansible-lint==5.1.3->-r tox-requirements.txt (line 2)) (0.1.2)
Requirement already satisfied: text-unidecode>=1.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from python-slugify>=4.0.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (1.3)
Requirement already satisfied: urllib3<3,>=1.21.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.0.4)
Requirement already satisfied: idna<4,>=2.5 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (3.4)
Requirement already satisfied: charset-normalizer<4,>=2 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (3.2.0)
Requirement already satisfied: certifi>=2017.4.17 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from requests>=2.23.0->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2023.7.22)
Requirement already satisfied: python-dateutil>=2.7.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from arrow->cookiecutter>=1.7.3->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.8.2)
Requirement already satisfied: pycparser in ./.tox/py39-ansible30/lib/python3.9/site-packages (from cffi>=1.12->cryptography>=2.5->paramiko<3,>=2.5.0->molecule==3.4.0->-r tox-requirements.txt (line 5)) (2.21)
WARNING: You are using pip version 22.0.4; however, version 23.2.1 is available.
You should consider upgrading via the '/opt/vector-role/.tox/py39-ansible30/bin/python -m pip install --upgrade pip' command.
py39-ansible30 run-test: commands[1] | molecule test -s podman
INFO     podman scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
WARNING  Failed to locate command: [Errno 2] No such file or directory: 'git'
INFO     Guessed /opt/vector-role as project root directory
INFO     Using /root/.cache/ansible-lint/b984a4/roles/chervyakov.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Added ANSIBLE_ROLES_PATH=~/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles:/root/.cache/ansible-lint/b984a4/roles
INFO     Running podman > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running podman > lint
INFO     Lint is disabled.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'
Traceback (most recent call last):
  File "/opt/vector-role/.tox/py39-ansible30/bin/molecule", line 8, in <module>
    sys.exit(main())
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1157, in __call__
    return self.main(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1078, in main
    rv = self.invoke(ctx)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1688, in invoke
    return _process_result(sub_ctx.command.invoke(sub_ctx))
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 1434, in invoke
    return ctx.invoke(self.callback, **ctx.params)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/core.py", line 783, in invoke
    return __callback(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/click/decorators.py", line 33, in new_func
    return f(get_current_context(), *args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/test.py", line 159, in test
    base.execute_cmdline_scenarios(scenario_name, args, command_args, ansible_args)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 119, in execute_cmdline_scenarios
    execute_scenario(scenario)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 161, in execute_scenario
    execute_subcommand(scenario.config, action)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/base.py", line 150, in execute_subcommand
    return command(config).execute()
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/logger.py", line 187, in wrapper
    rt = func(*args, **kwargs)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/command/destroy.py", line 107, in execute
    self._config.provisioner.destroy()
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/provisioner/ansible.py", line 705, in destroy
    pb.execute()
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule/provisioner/ansible_playbook.py", line 106, in execute
    self._config.driver.sanity_checks()
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/molecule_podman/driver.py", line 212, in sanity_checks
    if runtime.version < Version("2.10.0") and runtime.config.ansible_pipelining:
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible_compat/runtime.py", line 375, in version
    self._version = parse_ansible_version(proc.stdout)
  File "/opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible_compat/config.py", line 42, in parse_ansible_version
    raise InvalidPrerequisiteError(msg)
ansible_compat.errors.InvalidPrerequisiteError: Unable to parse ansible cli version: ansible 2.10.17
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /opt/vector-role/.tox/py39-ansible30/lib/python3.9/site-packages/ansible
  executable location = /opt/vector-role/.tox/py39-ansible30/bin/ansible
  python version = 3.9.2 (default, Jun 13 2022, 19:42:33) [GCC 8.5.0 20210514 (Red Hat 8.5.0-10)]

Keep in mind that only 2.12 or newer are supported.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s podman (exited with code 1)
_______________________________________________________________________________________ summary ________________________________________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed
</details>
  
7. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.
