# Домашнее задание к занятию 1. «Введение в виртуализацию. Типы и функции гипервизоров. Обзор рынка вендоров и областей применения»

## Задача 1 Опишите кратко, в чём основное отличие полной (аппаратной) виртуализации, паравиртуализации и виртуализации на основе ОС.
```
Основная разница в необходимости модифицировать гостевые ОС.
 1 Полная виртуализация не требуется  гостевая ОС, вм полностью изолированы друг от друга и используют собственные ядра,
 гипервизор получает доступ к аппаратным ресурсам на прямую.  Примеры: xen,продукты vmware,
 2 Виртуализация на основе ОС, не имеет собственного ядра, а использует ядро хоста. 
 Контейнеры  полностью изолированы друг от друга, но нельзя запускать вм с ядрами отличными от хостовой.
 Примеры: docker, podman, lxc
 3 Паравиртуализации необходима модификация ядра и драйверов. Данная виртуализация  требует  ОС для доступа к аппаратным ресурсам хоста.
 Основные решения: kvm, proxmox,virtualbox, hyper-v


Чем больше модифицирована ОС, тем производительность выше. Наиболее высокая производительность у виртуализации средствами ОС,
т.к. приложения напрямую используют ядро хостовой ОС.
```

## Задача 2.Выберите один из вариантов использования организации физических серверов в зависимости от условий использования.
```
Организация серверов:

физические сервера,
паравиртуализация,
виртуализация уровня ОС.

Условия использования:

высоконагруженная база данных, чувствительная к отказу;
различные web-приложения;
Windows-системы для использования бухгалтерским отделом;
системы, выполняющие высокопроизводительные расчёты на GPU.
Опишите, почему вы выбрали к каждому целевому использованию такую организацию
```

* Высоконагруженная база данных, чувствительная к отказу
```
Виртуализация уровня ОС.
Это позволит создать несколько виртуальных машин на одном физическом сервере, каждая из которых будет работать, как отдельный экземпляр операционной системы. 
```
* Различные web-приложения
```
Виртуализация уровня ОС.
Слой виртуализации ОС обеспечивает изоляцию и безопасность ресурсов между различными контейнерами. Слой виртуализации делает каждый контейнер похожим на физический сервер. Каждый контейнер обслуживает приложения в нем и рабочую нагрузку.

```

* Windows-системы для использования бухгалтерским отделом
```
Паравиртуализация. 
Для windows системы из предложенных выше, наиболее оптимальным будет использование паравиртуализации. В целом наверное лучше использовать аппаратную виртуализацию, на базе Hyper-V
```

* Системы, выполняющие высокопроизводительные расчёты на GPU
```
Физические сервера.
Физический сервер позволяет задействовать все вычислительные возможности для выполнения расчетов GPU.
```

## Задача 3.Выберите один из вариантов использования организации физических серверов в зависимости от условий использования.
```
Выберите подходящую систему управления виртуализацией для предложенного сценария. Детально опишите ваш выбор.

Сценарии:
```
1. 100 виртуальных машин на базе Linux и Windows, общие задачи, нет особых требований. Преимущественно Windows based-инфраструктура, требуется реализация программных балансировщиков нагрузки, репликации данных и автоматизированного механизма создания резервных копий.
2. Требуется наиболее производительное бесплатное open source-решение для виртуализации небольшой (20-30 серверов) инфраструктуры на базе Linux и Windows виртуальных машин.
3. Необходимо бесплатное, максимально совместимое и производительное решение для виртуализации Windows-инфраструктуры.
4. Необходимо рабочее окружение для тестирования программного продукта на нескольких дистрибутивах Linux.

1. VMware vSphere. Она позволяет создавать и управлять виртуальными машинами на базе Linux и Windows, есть функции балансировки нагрузки, создания резервных копий и репликации данных
2. KVM. Бесплатное opensource решение для создания и управления вм на базе linux и Windows
3. Hyper-V.Бесплатное  решение для создания и управления вм на базе  Windows. Интеграция с другими решениями windows
4. Docker. Подходит для быстрого развертывания и тестирования, а также быстот

## Задача 4.Опишите возможные проблемы и недостатки гетерогенной среды виртуализации (использования нескольких систем управления виртуализацией одновременно) и что необходимо сделать для минимизации этих рисков и проблем. Если бы у вас был выбор, создавали бы вы гетерогенную среду или нет? Мотивируйте ваш ответ примерами.

```
Гетерогенная среда виртуализации может привести к ряду проблем:

1. Наличие высококвалифицированных специалистов, специализирующихся на разных продуктах виртуализации.
2. Повышение расходов на покупку лицензированного ПО
3. Сложность мониторинга.

Действия для минимизации рисков и проблем:
1. Отказаться от гетерогенности
2. Максимальная автоматизация и исключение человеческого фактора
3. Единая система управления и мониторинга 

Нет, я бы предпочел работать в какой-то одной системе виртуализации. Одну систему проще изучить, меньше требуется затрат на ее поддержку и мониторинг.
```

