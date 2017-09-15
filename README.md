# This is an infrastructure repository

# Home work #6 BRANCH "config-scripts"
# Add bash scripts to install Ruby, MomgoDB and deploy (Commit "Add .sh files")

# Add Startup.sh script contains install and deploy lines (Commit Add Statrup.sh & 'gcloud compute instances create')
# Use command:
# gcloud compute instances create --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b --metadata-from-file=startup-script="Startup.sh" reddit-app
# To add firewall rule and open 9292 port use command:
#gcloud compute firewall-rules create allow-to-puma-servers --target-tags=puma-server --allow tcp:9292

# Home work #7 BRANCH "base-os-parker"

# Create ubuntu16.json file include "provisioners" install Ruby & MongoDB (Commit Add Packer template ubuntu16.json + install_ruby.sh&install_mongodb.sh):

# 1.parameterize the created template ubuntu16.json using custom variables (Commit Parameterize the created template ubuntu16.json):
#   machine_type
#   source_image (required)
#   project_id (required)
#
# Use packer build -var-file=variables.json ubuntu16.json are packer build -var 'project_id=<My project_id>' -var 'source_image=ubuntu-1604-xenial-v20170815a' ubuntu16.json
# 2. Add options to ubuntu16.json (Commit Add new options to ubintu16.json)
#    disk_size,
#    disk_type,
#    network,
#    image_description

# Homework 8 (BRANCH TERRAFORM-1):
# Создали директорию terraform в репозитории infra.
# Определили секцию Provider в нашем главном конфигурационном файле main.tf
# Добавили в main.tf ресурсы (resource) для создания инстанса на основе ранее созданного нами образа reddit-base-1505214895
# Добавили в main.tf определение для открытого SSH ключа (metadata)
# Создадим файл outputs.rf для выходных переменных
# Добавим в main.tf правило firewall
# Добавили tags в описание нашего инстанаса, чтобы к нему применялось правило firewall
# Добавили Provisioner (это делается для того, чтобы на созданном инстансе запустилась puma в видел службы). Также мы добавили файлы puma.service и deploy.sh
# Определили параметры подключения provisioner к VM, добавив секцию connection d main.tf
# Определим входны меременные. Создадим для этого файл variables.tf
# Настроим использование пользовательских input переменных в main.tf, используя синтаксис “${var.var_name}”
# Определим пользовательские переменные в файле terraform.tfvars (такие файлы по соображениям безопасности находятся в .gitignore)
###
# Самостоятельное задание:
###
# 1. Определим еще одну пользовательскую переменную - приватный ключ (private_key) внесем соответствующие строки в main.tf, variables.tf и terraform.tfvars
#
# 2. Отформатировать конфигурационные файлы используя terraform fmt

# Homework 9

~/infra/packer/db.json - шаблон для сбора VM с установленной MongoDB
~/infra/packer/app.json - шаблон для сбора VM с установленной Ruby
