## Описание
Это среда для развертывания Laravel и дальнейшей разработки проекта

## Установка
`make init` и следуем инструкциям

## Команды

`make init` - Инициализация проекта  
`make up` - Запуск контейнеров  
`make down`  - Остановить контейнер
`make dump` - делает дамп базы данных, происходит при каждом `make down`  
`make exec` - Войти в контейнер с приложением
`make build` - Пересобрать контейнеры  
`make status` - информация о запущенных контейнерах  

## Директории

`./bin/env` - env файлы `*.prod.env` - продакшен `*.local.env` - локлаьные  
`./docker/` - докер-файлы  
`./docker/dump.sql` - текущий дамп базы