# This is an infrastructure repository

# Home work 6 (BRANCH "config-scripts")
Add bash scripts to install Ruby, MomgoDB and deploy (Commit "Add .sh files")

Add Startup.sh script contains install and deploy lines (Commit Add Statrup.sh & 'gcloud compute instances create')
## Use command:
gcloud compute instances create --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b --metadata-from-file=startup-script="Startup.sh" reddit-app
## To add firewall rule and open 9292 port use command:
gcloud compute firewall-rules create allow-to-puma-servers --target-tags=puma-server --allow tcp:9292

# Home work 7 (BRANCH "base-os-parker")

Create ubuntu16.json file include "provisioners" install Ruby & MongoDB (Commit Add Packer template ubuntu16.json + install_ruby.sh&install_mongodb.sh):

1.parameterize the created template ubuntu16.json using custom variables (Commit Parameterize the created template ubuntu16.json):
   machine_type
   source_image (required)
   project_id (required)

Use packer build -var-file=variables.json ubuntu16.json are packer build -var 'project_id=<My project_id>' -var 'source_image=ubuntu-1604-xenial-v20170815a' ubuntu16.json
2. Add options to ubuntu16.json (Commit Add new options to ubintu16.json)
    disk_size,
    disk_type,
    network,
    image_description

# Homework 8 (BRANCH TERRAFORM-1):

Создали директорию terraform в репозитории infra.
Определили секцию Provider в нашем главном конфигурационном файле main.tf
Добавили в main.tf ресурсы (resource) для создания инстанса на основе ранее созданного нами образа reddit-base-1505214895
Добавили в main.tf определение для открытого SSH ключа (metadata)
Создадим файл outputs.rf для выходных переменных
Добавим в main.tf правило firewall
Добавили tags в описание нашего инстанаса, чтобы к нему применялось правило firewall
Добавили Provisioner (это делается для того, чтобы на созданном инстансе запустилась puma в видел службы). Также мы добавили файлы puma.service и deploy.sh
Определили параметры подключения provisioner к VM, добавив секцию connection d main.tf
Определим входны меременные. Создадим для этого файл variables.tf
Настроим использование пользовательских input переменных в main.tf, используя синтаксис “${var.var_name}”
Определим пользовательские переменные в файле terraform.tfvars (такие файлы по соображениям безопасности находятся в .gitignore)

## Самостоятельное задание:
1. Определим еще одну пользовательскую переменную - приватный ключ (private_key) внесем соответствующие строки в main.tf, variables.tf и terraform.tfvars
2. Отформатировать конфигурационные файлы используя terraform fmt

# Homework 9 (BRANCH TERRAFORM-2)
### (в этой конфигурации из-за того, что опущена настройка revisioner, после старта сервера приложения, само прилоежние у нас не доступно!)

## Создание двух VM (разбивка исходной конфигурации по файлам):

- ~/infra/packer/db.json - шаблон для сбора VM с установленной MongoDB
- ~/infra/packer/app.json - шаблон для сбора VM с установленной Ruby
- ~/infra/terraform/app.tf - содержит конфигурацию для VM с приложением
- ~/infra/terraform/db.tf - содержит конфигурацию для VM с БД
- ~/infra/terraform/vpc.tf - содержит правило  firewall для SSH, которе применимо для всех инстансов нашей сети.

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
