## Описание playbook site.yml
```
Playbook выполняет установку и первоначальную конфигурацию:

Clickhouse
Vector
lighthouse + nginx

Установка выполняется на разные хосты, перечисленные в prod.yml

Требования к хостам: RPM-based Linux distribution

Установка Clickhouse
в файле group_vars/clickhouse/vars.yml задается:

версия
пакеты для установки
Описание tasks:

Get clickhouse distrib - скачивание дистрибутива в текущую директорию
Install clickhouse packages - установка пакетов
Create database - создание БД
хэндлер Start clickhouse service используется для принудителного запуска сервиса clickhouse
```

## Установка Vector
group_vars/vector/vars.yml задается:

версия (vector_version)
директория установки (vector_path)
конфигурационный файл (vector_config)


Описание tasks:
```
Vector | Create directory for bin - cоздание дирректории для bin файлa, для конфига вектора
Vector | download Vector - скачивание Вектора
Vector | Unarchive files - распаковка архива
Vector | Create service - создание сервис вектора
Vector | Creat config - создание конфига вектора
Vector | Start vector - запуск ввектора
```
## Установка Lighthouse
group_vars/light/lighthose.yml задается:

url гитхаб (lighthouse_url )
директория установки (lighthouse_dir)
nginx пользователь (lighthouse_nginx_user)


Описание tasks:
```
Lighthouse | Install git - установка гита. pre_task
Lighthouse | Install lighthouse - установка ЛХ
Lighthouse | Clone repository - клонирование репозитория ЛХ
Lighthouse | Create Lighthouse config - создание конфига ЛХ
Install epel-release - установка epel-release
Install nginx - установка nginx
Create nginx config - создание конфига
```

```
Используются тэги click, vector, light для раздельного запуска
```

```
запуска происходит из файла site.yml, который содержит имортированные плейбуки click.yml - установка vector и clickhouse, light.yml - установка nginx и lighthouse
```