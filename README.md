# This is an infrastructure repository

# Home work #6 BRANCH "config-scripts"
# Add bash scripts to install Ruby, MomgoDB and deploy (Commit "Add .sh files")

# Add Startup.sh script contains install and deploy lines (Commit Add Statrup.sh & 'gcloud compute instances create')
# Use command:
# gcloud compute instances create --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b --metadata-from-file=startup-script="Startup.sh" reddit-app

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
