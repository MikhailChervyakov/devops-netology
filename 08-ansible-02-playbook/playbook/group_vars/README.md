## Описание playbook site.yml
```
Playbook выполняет установку и первоначальную конфигурацию:

Clickhouse
Vector

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