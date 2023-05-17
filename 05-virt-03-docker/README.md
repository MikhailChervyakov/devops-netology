# Домашнее задание к занятию 3. «Введение. Экосистема. Архитектура. Жизненный цикл Docker-контейнера»
## Задача 1

```
Сценарий выполнения задачи:

* создайте свой репозиторий на https://hub.docker.com;
* выберите любой образ, который содержит веб-сервер Nginx;
* создайте свой fork образа;
* реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
Опубликуйте созданный fork в своём репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.
```
### Ответ
```
* docker run -d -p 80:80 mike168/nginx:1.0
* curl 172.17.0.2:80
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
```
ссылка https://hub.docker.com/repository/docker/mike168/nginx/general

## Задача 2
```
Посмотрите на сценарий ниже и ответьте на вопрос: «Подходит ли в этом сценарии использование Docker-контейнеров или лучше подойдёт виртуальная машина, физическая машина? Может быть, возможны разные варианты?»

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

* высоконагруженное монолитное Java веб-приложение;
  Физический сервер или ВМ, хотя слой ВМ будет сжирать дополнительные ресурсы
* Nodejs веб-приложение;
  Есть уже готовые доккер образы, собранные для работы с микросервисами node.
* мобильное приложение c версиями для Android и iOS;
  Лучше использовать виртуальные машины. 
* шина данных на базе Apache Kafka;
  Есть уже собранные докер образы для упрощения настроек.
* Elasticsearch-кластер для реализации логирования продуктивного веб-приложения — три ноды elasticsearch, два logstash и две ноды kibana;
Возможны решения, как на докере, так и на ВМ. Если докер, то для хранения данных надо подключать физические тома. Плюс докера еще в простате настройки, например Grafana. В образе уже есть собранные необходимые настройки, надо просто прокинуть конфиг.
* мониторинг-стек на базе Prometheus и Grafana;
  Возможны решения, как на докере, так и на ВМ. Если докер, то для хранения данных надо подключать физические тома. Плюс докера еще в простате настройки, например Grafana. В образе уже есть собранные необходимые настройки, надо просто прокинуть конфиг.
* MongoDB как основное хранилище данных для Java-приложения;
  Можно использовать как ВМ так и докер. Докер сделать с persistance volume, для сохранения данных.
* Gitlab-сервер для реализации CI/CD-процессов и приватный (закрытый) Docker Registry.
Подойдет как вм, таки докер образы. Относительная быстрая настройка

```

## Задача3
```
* Запустите первый контейнер из образа centos c любым тегом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера.

docker run -d -v $(pwd)/data:/data --name centos centos:latest sleep infinity
Unable to find image 'centos:latest' locally
latest: Pulling from library/centos
a1d0c7532777: Pull complete 
Digest: sha256:a27fd8080b517143cbbbab9dfb7c8571c40d67d534bbdee55bd6c473f432b177
Status: Downloaded newer image for centos:latest
7e76a289744ea3e51cea606e245ca52382e18b3047f4edeba207e4ddd52ca108
  
запустил с коммандой sleep infinity, чтобы не получить статус exited

* Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера.

docker run -d -v $(pwd)/data:/data --name debian debian sleep infinity
Unable to find image 'debian:latest' locally
latest: Pulling from library/debian
918547b94326: Pull complete 
Digest: sha256:63d62ae233b588d6b426b7b072d79d1306bfd02a72bff1fc045b8511cc89ee09
Status: Downloaded newer image for debian:latest
e83008dd47e70c886026138ee091bff0d78a966f2081badadaccb664950747a6

запустил с коммандой sleep infinity, чтобы не получить статус exited

* Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data.

docker exec -it centos bash
[root@7e76a289744e /]# cd data
[root@7e76a289744e data]# ls
[root@7e76a289744e data]# echo "Whoa i run docker!" >> /data/centos.txt
[root@7e76a289744e data]# cat centos.txt            
Whoa i run docker!
[root@7e76a289744e data]# exut
bash: exut: command not found
[root@7e76a289744e data]# exit

* Добавьте ещё один файл в папку /data на хостовой машине.

cd ./data/
echo "test" >> ./test.txt 

* Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.

docker exec -it debian bash
root@e83008dd47e7:/# cd ./data/
root@e83008dd47e7:/data# ls
centos.txt  test.txt
root@e83008dd47e7:/data# ls -la
total 16
drwxrwxr-x 2 1000 1000 4096 May 17 16:28 .
drwxr-xr-x 1 root root 4096 May 17 16:24 ..
-rw-r--r-- 1 root root   19 May 17 16:26 centos.txt
-rw-rw-r-- 1 1000 1000    5 May 17 16:28 test.txt
```