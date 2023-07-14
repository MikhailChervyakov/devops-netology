# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/08-ansible-03-yandex/img/1.png)
2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/08-ansible-03-yandex/img/2.png) 
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/08-ansible-03-yandex/img/3.png)   
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/08-ansible-03-yandex/img/3.png)   

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9.  Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
[описание README](https://github.com/MikhailChervyakov/devops-netology/blob/main/08-ansible-03-yandex/playbook/group_vars/README.md)

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.
[tag](https://github.com/MikhailChervyakov/devops-netology/releases/tag/08-ansible-03-yandex)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---