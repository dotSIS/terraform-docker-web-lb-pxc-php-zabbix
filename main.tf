# PROVIDERS
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# DOCKER HOST
provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# NETWORK
resource "docker_network" "terra_network" {
  name = "terra_network"
}

# IMAGES + MY CUSTOM IMAGES
resource "docker_image" "nginx" {
  name          = "nginx:latest"
  keep_locally  = false
}

resource "docker_image" "php_fpm" {
  name         = "zhy7ne/8.1-fpm-alpine-z:2.0"
  keep_locally = false
}

resource "docker_image" "pxc0" {
  name          = "zhy7ne/pxc_node0:3.0"
  keep_locally  = false
}

resource "docker_image" "pxc1" {
  name          = "percona/percona-xtradb-cluster:5.7"
  keep_locally  = false
}

# LOAD BALANCER
resource "docker_container" "load_balancer" {
  image = docker_image.nginx.image_id
  name  = "lb"
  volumes {
    host_path      = "/home/zhy7ne/Projects/Fligno/Terraform/docker/web-lb-pxc-php/custom-configs/load-balancer.conf"
    container_path = "/etc/nginx/conf.d/default.conf"
  }
  ports {
    internal = 80
    external = 8080
  }
  networks_advanced {
    name = docker_network.terra_network.name
  }
}

# NGINX SERVERS
resource "docker_container" "server" {
  count = 2
  name  = "server${count.index + 1}"
  image = docker_image.nginx.image_id
  volumes {
    host_path      = "/home/zhy7ne/Projects/Fligno/Terraform/docker/web-lb-pxc-php/custom-configs/server${count.index + 1}-php.conf"
    container_path = "/etc/nginx/conf.d/default.conf"
  }
  ports {
    internal = 80
    external = 8081 + count.index
  }
  networks_advanced {
    name = docker_network.terra_network.name
  }
  depends_on = [docker_image.php_fpm, docker_image.nginx]
}

# PHP-FPM
resource "docker_container" "php_fpm" {
  count = 2
  name  = "php_fpm${count.index + 1}"
  image = docker_image.php_fpm.image_id
  volumes {
    host_path      = "/home/zhy7ne/Projects/Fligno/Terraform/docker/web-lb-pxc-php/server-pages/im-pit/"
    container_path = "/var/www/html/"
  }
  volumes {
    host_path      = "/home/zhy7ne/Projects/Fligno/Terraform/docker/web-lb-pxc-php/server-pages/im-pit/index${count.index + 1}.php"
    container_path = "/var/www/html/index.php"
  }
  ports {
    internal = 9000
    external = 9001 + count.index
  }
  networks_advanced {
    name = docker_network.terra_network.name
  }
  depends_on = [docker_image.php_fpm]
}

# PXC BOOTSTRAP NODE (Z)
resource "docker_container" "pxc_node0" {
  image = docker_image.pxc0.image_id
  name  = "pxc_node0"
  env = [
    "MYSQL_ALLOW_EMPTY_PASSWORD=yes",
    "MYSQL_ROOT_PASSWORD=password",
    "MYSQL_INITDB_SKIP_TZINFO=yes",
    "XTRABACKUP_PASSWORD=password",
    "PXC_ENCRYPT_CLUSTER_TRAFFIC=0",
  ]
  ports {
    internal = 3306
    external = 33060
  }
  network_mode = docker_network.terra_network.name
}

# PXC JOINER NODE(S), uncomment below after starting the bootstrap node
# resource "docker_container" "pxc_node1" {
#   count = 2
#   image = docker_image.pxc1.image_id
#   name  = "pxc_node${count.index + 1}"
#   env = [
#     "MYSQL_ALLOW_EMPTY_PASSWORD=yes",
#     "MYSQL_ROOT_PASSWORD=password",
#     "MYSQL_INITDB_SKIP_TZINFO=yes",
#     "XTRABACKUP_PASSWORD=password",
#     "CLUSTER_NAME=terracluster",
#     "CLUSTER_JOIN=pxc_node0",
#     "name=pxc_node${count.index + 1}",
#     "net=terra_network",
#     "PXC_ENCRYPT_CLUSTER_TRAFFIC=0",
#   ]
#   ports {
#     internal = 3306
#     external = 33061 + count.index
#   }
#   network_mode = docker_network.terra_network.name
# }
