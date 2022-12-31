module "vpc" {
  source = "../VPC-Networking_module"
}

module "nginxwebserver" {
  source = "../Nginx-webserver"
  depends_on = [
    module.vpc
  ]
}