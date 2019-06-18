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

