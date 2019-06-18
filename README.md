# chudinanton_microservices
chudinanton microservices repository
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

## ДЗ№12
## В процессе сделано:
- Освоены базовые команды работы с Docker
- Настроена интеграция с Travis + чат слак
- Доп. задание: описано основное отличие контейнера от образа.

