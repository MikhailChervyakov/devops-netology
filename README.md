# devops-netology

###Whoa it's my first chamnges

#second commit

Игнорировать все файлы в директории .terraform
Игнорировать все файлы заканчивающиеся на .tfstate и содержащие .tfstate.
Игнорировать файлы crash.log и файл содержащий crash.log

Игнорировать файлы заканчивающиеся на .tfvars и .tfvars.json
Игнорировать файлы override.tf, override.tf.json и заканчивающиеся на _override.tf и _override.tf.json
Игнорировать файлы .terraformrc и terraform.rc
****

# Домашнее задание к занятию «Инструменты Git»

## Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.
```
Комманда 
git show aefea
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Update CHANGELOG.md
```
2. 
## Какому тегу соответствует коммит 85024d3? 
```
Комманда git show 85024d3
tag: v0.12.23
```
## Сколько родителей у коммита b8d720? Напишите их хеши.
```
2 коммита
Комманда git show b8d720
9ea88f22fc6269854151c571162c5bcf958bee2b
56cd7859e05c36c06b56d013b55a252d0bb7e158
```

## Перечислите хеши и комментарии всех коммитов, которые были сделаны между тегами v0.12.23 и v0.12.24.
```
Комманда git log ^v0.12.23 v0.12.24 --oneline

33ff1c03bb (tag: v0.12.24) v0.12.24
b14b74c493 [Website] vmc provider links
3f235065b9 Update CHANGELOG.md
6ae64e247b registry: Fix panic when server is unreachable
5c619ca1ba website: Remove links to the getting started guide's old location
06275647e2 Update CHANGELOG.md
d5f9411f51 command: Fix bug when using terraform login on Windows
4b6d06cc5d Update CHANGELOG.md
dd01a35078 Update CHANGELOG.md
225466bc3e Cleanup after v0.12.23 release
```

## Найдите коммит, в котором была создана функция func providerSource, её определение в коде выглядит так: func providerSource(...) (вместо троеточия перечислены аргументы).
```
8c928e83589d90a031f811fae52a81be7153e82f
Комманды  git log -S 'func providerSource' 
```

## Найдите все коммиты, в которых была изменена функция globalPluginDirs
```
git grep -c 'globalPluginDirs'
git log -s -L :globalPluginDirs:plugins.go --oneline

78b1220558 Remove config.go and update things using its aliases
52dbf94834 keep .terraform.d/plugins for discovery
41ab0aef7a Add missing OS_ARCH dir to global plugin paths
66ebff90cd move some more plugin search path logic to command
8364383c35 Push plugin discovery down into command package
```

## Кто автор функции synchronizedWriters?
```
git log -S 'synchronizedWriters' 
git show 5ac311e2a9 -s --pretty=%an
Martin Atkins
```
