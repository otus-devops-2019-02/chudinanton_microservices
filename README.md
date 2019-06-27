# chudinanton_microservices
chudinanton microservices repository
## ДЗ№18
## В процессе сделано:
- Основное задание.

Ссылка на докер хаб:
https://hub.docker.com/u/chudinanton

## ДЗ№17
## В процессе сделано:
- Основное задание по развертыванию prometheus и мониторингу сервисов.

Ссылка на докер хаб:
https://hub.docker.com/u/chudinanton

## ДЗ№16
## В процессе сделано:
- Gitlab поднят через terraform. Сделано два модуля, установка выполняется через провиженеры.
- Выполнено основное задание по построению pipiline'ов.

## ДЗ№15
## В процессе сделано:
- Выполнил:  docker run -ti --rm --network none joffotron/docker-net-tools -c ifconfig
<pre>
lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
</pre>
- Выполнил: docker-machine ssh docker-host ifconfig
<pre>
docker0   Link encap:Ethernet  HWaddr 02:42:bf:be:5d:1e  
          inet addr:172.17.0.1  Bcast:172.17.255.255  Mask:255.255.0.0
          UP BROADCAST MULTICAST  MTU:1500  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

ens4      Link encap:Ethernet  HWaddr 42:01:0a:84:00:03  
          inet addr:10.132.0.3  Bcast:10.132.0.3  Mask:255.255.255.255
          inet6 addr: fe80::4001:aff:fe84:3/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1460  Metric:1
          RX packets:4157 errors:0 dropped:0 overruns:0 frame:0
          TX packets:3283 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:72983681 (72.9 MB)  TX bytes:358736 (358.7 KB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)
</pre>
- Выполнил docker run --network host -d nginx

Запускается только 1 контейнер ввиду того что порт занят.

<pre>
Остановить все контейнеры:
docker kill $(docker ps -q)
</pre>

Для инфо:
<pre>
На docker-host машине выполните команду:
> sudo ln -s /var/run/docker/netns /var/run/netns
Теперь вы можете просматривать существующие в данный
момент net-namespaces с помощью команды:
> sudo ip netns
Задание:
Повторите запуски контейнеров с использованием драйверов
none и host и посмотрите, как меняется список namespace-ов.
Примечание: ip netns exec <namespace> <command> - позволит выполнять
команды в выбранном namespace
</pre>

- Выполнил запуск контейнеров из ранее созданных образов загруженных на докерхаб.
<pre>
#Сначала создали сеть.
docker network create reddit --driver bridge 
#Далее все как обычно
docker run -d --network=reddit mongo:latest
docker run -d --network=reddit chudinanton/post:1.0
docker run -d --network=reddit chudinanton/comment:1.0
docker run -d --network=reddit -p 9292:9292 chudinanton/ui:1.0 
</pre>

Проблема:
<pre>
На самом деле, наши сервисы ссылаются друг на друга по dnsименам, прописанным в ENV-переменных (см Dockerfile). В текущей
инсталляции встроенный DNS docker не знает ничего об этих
именах.
Решением проблемы будет присвоение контейнерам имен или
сетевых алиасов при старте:
--name <name> (можно задать только 1 имя)
--network-alias <alias-name> (можно задать множество алиасов)
</pre>
- Делаем
<pre>
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post chudinanton/post:1.0
docker run -d --network=reddit --network-alias=comment chudinanton/comment:1.0
docker run -d --network=reddit -p 9292:9292 chudinanton/ui:1.0
Проверяем:
http://35.195.15.180:9292/
После успешного теста прибиваем контейнеры:
docker kill $(docker ps -q)
</pre>
- Тестирование двух bridge сетей.
Инфо:
<pre>
Давайте запустим наш проект в 2-х bridge сетях. Так , чтобы сервис ui
не имел доступа к базе данных в соответствии со схемой ниже. Commenrt и post контейнеры находятся в двух сетях сразу.
</pre>
- Создаем докер сети:
<pre>
docker network create back_net --subnet=10.0.2.0/24
docker network create front_net --subnet=10.0.1.0/24
</pre>
- Запускаем контейнеры:
<pre>
docker run -d --network=front_net -p 9292:9292 --name ui chudinanton/ui:1.0
docker run -d --network=back_net --name comment chudinanton/comment:1.0
docker run -d --network=back_net --name post chudinanton/post:1.0
docker run -d --network=back_net --name mongo_db --network-alias=post_db --network-alias=comment_db mongo:latest 
</pre>
При проверке сервиса появляется ошибка ввиду:
<pre>
Docker при инициализации контейнера может подключить к нему только 1
сеть.
При этом контейнеры из соседних сетей не будут доступны как в DNS, так
и для взаимодействия по сети.
Поэтому нужно поместить контейнеры post и comment в обе сети.
Дополнительные сети подключаются командой:
docker network connect "network" "container"
</pre>
- Подключим контейнеры ко второй сети
<pre>
docker network connect front_net post
docker network connect front_net comment 
Проверяем:
http://35.195.15.180:9292/
все ок
</pre>
- Просмотр бриджей на докер ноде
<pre>
Входим на докер машину:
docker-machine ssh docker-host
Ставим нужную утилиту:
sudo apt-get update && sudo apt-get install bridge-utils
Смотрим сети:
docker network ls
Смотрим бриджи:
ifconfig | grep br
Выберите любой из bridge-интерфейсов и выполните команду. Ниже
пример вывода:
brctl show <interface>
Отображаемые veth-интерфейсы - это те части виртуальных пар
интерфейсов (2 на схеме), которые лежат в сетевом пространстве хоста и
также отображаются в ifconfig. Вторые их части лежат внутри контейнеров
</pre>
- docker-compose
<pre>
Остановим контейнеры, запущенные на предыдущих шагах
docker kill $(docker ps -q)
Выполнил:
export USERNAME=chudinanton
docker-compose up -d
docker-compose ps
Проверил работу сервиса, все ок.
</pre>
- Изменен docker-compose под кейс с множеством сетей, сетевых алиасов (стр 18). 
- Параметризован порт публикации сервиса ui и версии сервисов
-  Параметризованные параметры записаны в отдельный файл c расширением .env он внесен в игнор и создан example.
- Задано базовое имя проекта. Двумя способами:
1. Через переменную в env файле - COMPOSE_PROJECT_NAME=project_name
2. Через командную строку с ключем -p: docker-compose -p project_name up -d


## ДЗ№14
## В процессе сделано:
- Скачан и распакован архив. Каталог переименован в src.
- Скачаны Dockerfil'ы.
- Выполнены:
<pre>
docker pull mongo:latest
docker build -t chudinanton/post:1.0 ./post-py
docker build -t chudinanton/comment:1.0 ./comment
docker build -t chudinanton/ui:1.0 ./ui
</pre>

В первом случае добавлены:
<pre>
apk update && apk add --no-cache musl-dev gcc && \
pip install --upgrade pip && \
</pre>
Во втором и третьем:
<pre>
sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list \ 
&& 
</pre>

- Создал спец сеть и запустил контейнеры:
<pre>
docker network create reddit
docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db mongo:latest
docker run -d --network=reddit --network-alias=post chudinanton/post:1.0
docker run -d --network=reddit --network-alias=comment chudinanton/comment:1.0
docker run -d --network=reddit -p 9292:9292 chudinanton/ui:1.0
</pre>
ui взлетел на с первого раза т.к. порт был занят. Остановил старый конейнер и запустил еще раз новый.
- Проверил работоспособность (создал ссылку).

<pre>
Для инфо:
Что мы сделали?
Создали bridge-сеть для контейнеров, так как сетевые алиасы не
работают в сети по умолчанию (о сетях в Docker мы поговорим
на следующем занятии)
Запустили наши контейнеры в этой сети
Добавили сетевые алиасы контейнерам
Сетевые алиасы могут быть использованы для сетевых
соединений, как доменные имена
</pre>

## ДЗ№13
## В процессе сделано:
- Связал утилиту управления gcloud с проектом в облаке.
- Создал докер машину в облаке.
<pre>
docker-machine create --driver google \
--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
--google-machine-type n1-standard-1 \
--google-zone europe-west1-b docker-host
</pre>
Переключение на эту машину:
<pre>
eval $(docker-machine env docker-host)
</pre>
- Повторение практики из демо на лекции.
<pre>
Изоляция (процессы хостовой системы будут не видны):
docker run --rm -it tehbilly/htop
Чтобы были видны процессы из контейнера (например для мониторинга):
docker run --rm -it --pid host tehbilly/htop
Docker-in-Docker (воспользовался готовым образом):
docker run --privileged --rm -it jpetazzo/dind
docker inspect id контейенера - просмотреть подробное инфо о конейнере
</pre>
- Создал докер образ:
<pre>
docker build -t reddit:latest .
Точка в конце обязательна, она указывает на путь до
Docker-контекста
Флаг -t задает тег для собранного образа
</pre>
- Запустил созданный контейнер
<pre>
docker run --name reddit -d --network=host reddit:latest 
</pre>
- Создал правило:
<pre>
 gcloud compute firewall-rules create reddit-app \
 --allow tcp:9292 \
 --target-tags=docker-machine \
 --description="Allow PUMA connections" \
 --direction=INGRESS 
</pre>
-  Зарегистрировал учетку в докер хаб и загрузил туда образ.
<pre>
docker login
docker tag reddit:latest chudinanton/otus-reddit:1.0
docker push chudinanton/otus-reddit:1.0
Проверка:
eval $(docker-machine env --unset)
docker run --name reddit -d -p 9292:9292 chudinanton/otus-reddit:1.0
http://localhost:9292/ - тест пройден.
</pre>
Изучить логи контейнера:
<pre>
docker logs reddit -f
</pre>
Зайти в выполняемый контейнер, посмотреть список процессов, вызвать остановку контейнера:
<pre>
docker exec -it reddit bash
• ps aux
• killall5 1 
</pre>
Запустить его повторно:
<pre>
docker start reddit
</pre>
Остановить и удалить:
<pre>
docker stop reddit && docker rm reddit
</pre>
Запустить контейнер без запуска приложения и посмотреть процессы: 
<pre>
docker run --name reddit --rm -it chudinanton/otus-reddit:1.0 bash
ps aux
exit
</pre>
C помощью следующих команд можно посмотреть подробную информацию о
образе
<pre>
docker inspect chudinanton/otus-reddit:1.0
</pre>
Вывести только определенный фрагмент информации:
<pre>
docker inspect chudinanton/otus-reddit:1.0 -f '{{.ContainerConfig.Cmd}}' 
</pre>
Запустить приложение и добавить/удалить папки и посмотреть дифф:
<pre>
docker run --name reddit -d -p 9292:9292 chudinanton/otus-reddit:1.0
docker exec -it reddit bash
• mkdir /test1234
• touch /test1234/testfile
• rmdir /opt
• exit
docker diff reddit
docker stop reddit && docker rm reddit  
</pre>
Проверить что после остановки и удаления контейнера никаких изменений не останется:
<pre>
docker run --name reddit --rm -it chudinanton/otus-reddit:1.0 bash
</pre>

## ДЗ№12
## В процессе сделано:
- Освоены базовые команды работы с Docker
- Настроена интеграция с Travis + чат слак
- Доп. задание: описано основное отличие контейнера от образа.

