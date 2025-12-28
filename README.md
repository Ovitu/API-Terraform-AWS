# 🚀 AWS Serverless Architecture: IaC com Terraform & CI/CD

Este projeto demonstra a implementação de uma infraestrutura robusta, escalável e automatizada na AWS para hospedar uma API Node.js. O foco principal é a utilização de **Terraform** para garantir que 100% da infraestrutura seja tratada como código (IaC), permitindo deploys rápidos e consistentes.

## 🏗️ Arquitetura da Solução

A arquitetura foi desenhada seguindo as melhores práticas de isolamento de rede e resiliência:

* **VPC (Virtual Private Cloud):** Rede customizada segmentada em subnets públicas e privadas para segurança dos dados.
* **ECS Fargate:** Orquestração de containers em modo serverless, eliminando a necessidade de gerenciar servidores físicos ou instâncias EC2.
* **Application Load Balancer (ALB):** Gerenciamento inteligente de tráfego e ponto de entrada único para a API.
* **Security Groups:** Camadas de firewall granulares protegendo a comunicação entre o Load Balancer, os containers e o banco de dados.
* **Amazon RDS (Postgres):** Banco de dados relacional isolado em rede privada, preparado para conexões seguras via SSL.
* **NAT Gateways:** Permitem que os containers na rede privada realizem atualizações e acessem serviços externos de forma segura.



## 🛠️ Tecnologias Utilizadas

* **Infraestrutura:** Terraform (HashiCorp)
* **Aplicação:** Node.js (Express)
* **Containerização:** Docker
* **Nuvem:** Amazon Web Services (AWS)
* **CI/CD:** AWS CodeBuild & GitHub Webhooks

## 🔄 Fluxo de Deploy Automatizado (CI/CD)

O projeto conta com um pipeline de integração contínua:
1.  O desenvolvedor realiza o **Push** do código para o GitHub.
2.  O **AWS CodeBuild** é acionado via Webhook, realiza o build da imagem Docker e a envia para o **Amazon ECR**.
3.  O **Amazon ECS** atualiza o serviço automaticamente, realizando um *Rolling Update* sem downtime.



## 🚀 Como Executar

### 1. Provisionamento da Infraestrutura
Certifique-se de ter o Terraform instalado e as credenciais AWS configuradas no terminal:
```bash
terraform init
terraform plan
terraform apply -auto-approve
