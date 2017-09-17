terraform {
  backend "gcs" {
    bucket  = "tf-main"
    path    = "terraform.tfstate"
    project = "infra"
  }
}
