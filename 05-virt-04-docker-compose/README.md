# Домашнее задание к занятию 4. «Оркестрация группой Docker-контейнеров на примере Docker Compose»

## Задача 1 Создайте собственный образ любой операционной системы (например ubuntu-20.04) с помощью Packer (инструкция). Чтобы получить зачёт, вам нужно предоставить скриншот страницы с созданным образом из личного кабинета YandexCloud.

```
* curl -sSL https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash  
* yc init
* устанавливаем токен
* yc vpc network create --name net --labels my-label=netology --description "test1" - создаем сеть в облаке
* yc vpc subnet create --name subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "subnet" - создаем подсетку 
* packer validate .packer/centos-7-base.json
* packer build .packer/centos-7-base.json
```
В итоге получилось воть.
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/05-virt-04-docker-compose/images/1.png)
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/05-virt-04-docker-compose/images/2.png)


## Задача 22.1. Создайте вашу первую виртуальную машину в YandexCloud с помощью web-интерфейса YandexCloud.

## 2.2.* (Необязательное задание)
Создайте вашу первую виртуальную машину в YandexCloud с помощью Terraform (вместо использования веб-интерфейса YandexCloud). Используйте Terraform-код в директории (src/terraform).


![](https://github.com/MikhailChervyakov/devops-netology/blob/main/05-virt-04-docker-compose/images/3.png)
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/05-virt-04-docker-compose/images/4.png)

```
* устанавливаем terraform
* В папке terraform, делаем terraform init
* terraform plan
* terraform apply
```
## 3 С помощью Ansible и Docker Compose разверните на виртуальной машине из предыдущего задания систему мониторинга на основе Prometheus/Grafana. Используйте Ansible-код в директории (src/ansible). Чтобы получить зачёт, вам нужно предоставить вывод команды "docker ps" , все контейнеры, описанные в docker-compose, должны быть в статусе "Up".

![](https://github.com/MikhailChervyakov/devops-netology/blob/main/05-virt-04-docker-compose/images/5.png)
``1
деплоил коммандой  ansible-playbook provision.yml  -e "ansible_port=22" 
```

## 4 С помощью Ansible и Docker Compose разверните на виртуальной машине из предыдущего задания систему мониторинга на основе Prometheus/Grafana. Используйте Ansible-код в директории (src/ansible). Чтобы получить зачёт, вам нужно предоставить вывод команды "docker ps" , все контейнеры, описанные в docker-compose, должны быть в статусе "Up".
```
1.    Откройте веб-браузер, зайдите на страницу http://<внешний_ip_адрес_вашей_ВМ>:3000.
2.    Используйте для авторизации логин и пароль из .env-file.
3.    Изучите доступный интерфейс, найдите в интерфейсе автоматически созданные   
4.    docker-compose-панели с графиками(dashboards).
5.    Подождите 5-10 минут, чтобы система мониторинга успела накопить данные.
```
![](https://github.com/MikhailChervyakov/devops-netology/blob/main/05-virt-04-docker-compose/images/6.png)

