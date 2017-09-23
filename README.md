# This is an infrastructure repository

# Home work 6 (BRANCH "config-scripts")

Необходимо:
- наличие установленного и инициализированного **gcloud** (Инструкция https://cloud.google.com/sdk/docs/)

- создать SSH ключ для пользователя appuser и добавить его в GCP
- $ ssh-keygen -t rsa -f ~/.ssh/appuser -C appuser -P ""

- создать инстанс для проверки  CLI после настройки:
- gcloud compute instances create --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b --metadata-from-file=startup-script="Startup.sh" reddit-app

- создать правилов firewall в GCP для серверов с тегами puma-server и портом <port>
- gcloud compute firewall-rules create allow-to-puma-servers --target-tags=puma-server --allow tcp:9292

### Использумые скрипты:
- ~/infra/install_ruby.sh - скрипт установки **Ruby**
- ~/infra/install_mongodb.sh - скрипт установки **MongoDB** и **bundler**
- ~/infra/deploy.sh - скрипт деплоя приложения (приложение находится по адресу https://github.com/Artemmkin/reddit)
- ~/infra/Startup.sh - скрипт содержит установку Ruby, MongoDB и deploy (используется при создании инстанса с уже установленным приложением)


Проверить установку:
- $ ruby -v
- $ gem -v bundler
- $ ps aux | grep puma

Проверить установку приложения:
- <external_ip>:<port>


# Home work 7 (BRANCH "base-os-parker")

Необходимо:
- Установить версию **Packer** (ссылка на дистрибутив https://www.packer.io/downloads.html)

- Если не работаем с GCP через браузерную консоль, то предоставить **credentials** для аутентификации
- $ gcloud auth application-default login

- ~/infra/packer - рабочая директория
- ~/infra/packer/ubuntu16.json - packer-шаблон содержащий описание образа VM
- ~/infra/packer/variables.json - описание переменных
- reddit-base-1505214895 - имя созданного нами образа VM
- скрипты используемые провижинерами ubuntu16.json:
- ~/infra/packer/scripts/install_ruby.sh
- ~/infra/packer/scripts/install.mongodb.sh

### Используемые команды:
- $ packer validate ./ubuntu16.json - проверить на наличие ошибок при создании шаблона
- $ packer build ubuntu16.json - создание шаблона

- $ packer build -var-file=variables.json ubuntu16.json or packer build -var 'project_id=<My project_id>' -var 'source_image=ubuntu-1604-xenial-v20170815a' ubuntu16.json - при использовании переменных


# Homework 8 (BRANCH TERRAFORM-1):

Необходимо:
- Установить **terraform** (https://www.terraform.io/downloads.html)
- наличие ~/infra/.gitignore

- ~/infra/terraform/main.tf - содержит декларативно описание инфраструктуры
- ~/infra/terraform/terraform.tfstate - Terraform хранит в этом файле состояние управляемых им ресурсов (создается при выполнении команды apply)
- ~/infra/terraform/outputs.rf - файл для выходных переменных
- ~/infra/terraform/files/puma.service - файл для копирования на удаленный хост (используется для запуска сервера приложения, используя команду systemctl start puma)
- ~/infra/terraform/files/deploy.sh - скрипт, который следует запустить на созданной VM
- ~/infra/terraform/variables.tf - файл с входными переменными для параметризации конфигурационных файлов
- ~/infra/terraform/terraform.tfvars - для определения переменных

### Используемые команды:
- $ terraform init
- $ terraform plan
- $ terraform apply
- $ terraform destroy
- $ terraform show | grep assigned_nat_ip
- $ terraform refresh - чтобы выходная переменная приняла значение
- $ terraform output - посмотреть значение выходных переменных
- $ terraform taint - позволяет пометить ресурс, который terraform должен пересоздать, при следующем запуске terraform appy. ($ terraform taint google_compute_instance.app)

# Homework 9 (BRANCH TERRAFORM-2)
### (в этой конфигурации из-за того, что опущена настройка revisioner, после старта сервера приложения, само прилоежние у нас не доступно!)

## Создание двух VM (разбивка исходной конфигурации по файлам):

- ~/infra/packer/db.json - шаблон для сбора VM с установленной MongoDB
- ~/infra/packer/app.json - шаблон для сбора VM с установленной Ruby
- ~/infra/terraform/app.tf - содержит конфигурацию для VM с приложением
- ~/infra/terraform/db.tf - содержит конфигурацию для VM с БД
- ~/infra/terraform/vpc.tf - содержит правило  firewall для SSH, которе применимо для всех инстансов нашей сети.
- ~/infra/terraform/backend.tf - хранение нашего terraform.tfstate файла в облаке, для возможности совместного доступа к нему участниками проекта. (возможно создание для каждого terraform)
- Для для переноса terraform.tfstate в облачное хранилище необходимо создать bucket (GCP -> Storage) и выполнить **teraform init**

Для того чтобы посмотреть переменные шаблона используем команду:
- $ packer inspect <путь_до_шаблона>
Соберем образ для приложения, используя шаблон app.json.
Для начала определим требуемые переменные в файле variables.json.
Создадим образ, выполнив команду:
- $ packer build -var-file variables.json app.json
Для создания хостов используем команды:
- $ terraform plan
- $ terraform apply
или
- $ terraform apply -auto-approve=false

## Используем модули

Используются директории (необходимо удалить или переименовать db.tf и app.tf в директории terraform):
- ~/infra/terraform/modules/db/  # содержит модуль базы данных
- ~/infra/terraform/modules/app/ # содержит модуль приложения
- ~/infra/terraform/modules/vpc/ # содержит модуль настройки файрвола в рамках сети.
- .tf_old файлы от разбивки исходной конфигурации по файлам (не используются)

Используемые команды:
- $ terraform get      # для загрузки модулей
- $ tree .terraform    # убедились, что модули загрузились в .terraform
- $ terraform plan
- $ terraform apply

## Создание инфраструктуры для двух окружений (stage и  prod)

- ~/infra/terraform/prod  # окружение prod
- ~/infra/terraform/stage # окружение stage

Каждая директория содержит файлы main.tf, variables.tf,
outputs.tf, terraform.tfvars, скопированные из директории terraform. Заменены пути к модулям в main.tf на "../modules/xxx" вместо "modules/
xxx".

Инфраструктура в обоих окружениях идентична. Однако в prod открыт SSH доступ только с моего  IP (myip.ru - можно узнать свой  IP), в stage открыт SSH доступ для всех IP.

- Для возможности работы в важдом окружении необходимо выполнить **terraform init**.

Используемые команды:
- $ terraform plan
- $ terraform apply
- $ terraform destroy


# Homework 10 (branch homework_10)

Цель: дополним provision в
Packer, заменим bash скрипты Ansible
плейбуками и будем двигаться в сторону
конфигурации образа при помощи Ansible.

- Для выполнения работ понадобится установленный **python 2.7**
- Рекомендуется поставить пакетные менеджеры **easy_install** или **pip**
- Установка **ansible** осуществляется:
- easy_install `cat requirements.txt` или
- pip install -r requirements.txt
- $ ansible --version

- ~/infra/ansible/requirements.txt - файл для установки ansible
- ~/infra/ansible/packer_reddit_app.yml - playbook установки ruby and rubygems для нашего приложения
- ~/infra/ansible/packer_reddir_db.yaml - playbook установки MongoDB для нашего приложения
- ~/infra/packer/app.json - шаблон для создания образа VM с установленной **ruby** и **bundler** c интегрированным ansible
- ~/infra/packer/dd.json -  шаблон для создания образа  VM с установленной **MondoDB** с интегрированным  ansible
- /infra/packer/variables.json - файл с параметрами для создания VM

Запустить выполнение playbook относительно созданного инстанса (инстанс можно создать произвольный):
- ansible-playbook -u ubuntu -i <GCE_IP>, reddit_app.yml
- ansible-playbook -u ubuntu -i <GCE_IP>, reddit_db.yml
##### Не забываем сгенерировать пару ключей для пользователя ubuntu и поместить открытый ключ в метаданные GCP!

#### Интегрируем Ansible в Packer 
(Заменим секцию Provision в соответствующем образе .json на Ansible):

##### для создания образов используем команды:
- packer build -var-file=variables.json <имя_шаблона>.json или 
- packer build -var 'project_id=<My project_id>' var 'source_image=<My_image_name>' <имя_шаблона>.json
- Для проверки вместо build использовать validate

##### Для проверки:
На запущенных инстансах, созданных на основе наших образов, должны быть установлены ruby и bundle - для app инстанса и сервис mongodb - для инстанса db
- $ ruby -v
- $ bundler -v
- $ systemctl status mongod

# Homework 11 (branch ansible-2)

### Необходимо:
- Для управления хостами при помощи Ansible на них также должен быть установлен Python 2.X


- добавить в файл .gitignore следующую строку:
- *.retry
- Поднять инфрастурктуру, описанную в окружении stage (выполнить terraform apply в директории stage)

- ~/infra/terraform/modules/db/outputs.tf - описаны выходные переменные для db хоста
- ~/infra/ansible/hosts - инвентори файл (описаны хосты и группы хостов, которыми Ansible должен
управлять. ansible_ssh_host=130.211.75.255 - адрес нашего севера приложения)
- ~/infra/ansible/config.cfg - конфигурационный файл ansible (позволяет уменьшить количество информации в hosts)
- ~/infra/ansible/reddit_app.yml - плайбук управления конфигурацией и деплоя нашего приложения.
- ~/infra/ansible/templates/mongo.conf.j2 - параметризованный конфиг для MongoDB (расширение j2 будет напоминать нам, что данный файл является шаблоном)

### Команды:
- $ ansible appserver -i ./hosts -m ping - ping до appserver или
- $ ansible app -m ping - если группа [app] описана в hosts
- $ ansible dbserver -i ./hosts -m ping - ping до dbserver или
- $ ansible db -m ping - если группа [db] описана в hosts
- $ ansible all -m ping - проверить все группы, описанные в hosts
- $ ansible dbserver -m command -a uptime - проверка времени работы инстанса
__PLAYBOOKS__
- $ ansible-playbook reddit_app.yml --check --limit db - Применение описания плейбука к хостам (--check - проводит "пробный прогон")
- $ ansible-playbook reddit_app.yml --limit db - применить плайбук