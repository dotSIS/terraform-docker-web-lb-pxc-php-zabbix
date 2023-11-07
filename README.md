<div class="info">
    <p align='center'>
        <img src="https://raw.githubusercontent.com/dotSIS/terraform-docker-web-lb-pxc-php-upkuma/main/media/terra_network.jpg">
    </p>
</div>

# My terraformed docker network.

## Network specs:
- Load balancer:    Nginx
- Server:           2 Nginx reverse proxy servers + 2 Nginx custom PHP-FPM servers
- Database:         3 PXC custom images
- Monitor:          Uptime Kuma

## Requirements:
Click the links for the instructions on how to install each of the tools on your machine.
- Virtualization:   [`Docker`](https://docs.docker.com/get-docker/)
- CMT:              [`Terraform`](https://developer.hashicorp.com/terraform/downloads)

## Clone
- `git clone https://github.com/dotSIS/terraform-docker-web-lb-pxc-php-upkuma.git`
## Installation & Deployment
  ### Part 1 - Deploy load balancer, reverse proxy, php servers, database bootstrap, & monitor
  - `terraform init`
  - `terraform apply`
  ### Part 2 - Deploy joiner databases
  - Uncomment last resource on `main.tf`
  - `terraform apply`
  ### Part 3 - Web
  - Visit `http://localhost:8080` on your browser.
  ### Part 4 - Monitor
  - Visit `http://localhost:3001` on your browser.
  ### Part 5 - Undeploy
  - `terraform destroy`
