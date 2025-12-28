# 🚀 AWS Serverless Architecture: IaC com Terraform & CI/CD

Este projeto demonstra a implementação de uma infraestrutura robusta, escalável e automatizada na AWS para hospedar uma API Node.js. O foco principal é a utilização de **Terraform** para garantir que 100% da infraestrutura seja tratada como código (IaC), permitindo deploys mais rápidos.

## 🏗️ Arquitetura da Solução

A arquitetura foi desenhada seguindo as melhores práticas de isolamento de rede e resiliência:

* **VPC (Virtual Private Cloud):** Rede customizada segmentada em subnets públicas e privadas para segurança dos dados.
* **ECS Fargate:** Orquestração de containers serverless, eliminando a necessidade de gerenciar servidores físicos ou instâncias EC2.
* **Application Load Balancer (ALB):** Gerenciamento inteligente de tráfego e ponto de entrada único para a API.
* **Security Groups:** Camadas de firewall protegendo a comunicação entre o Load Balancer, os containers e o banco de dados.
* **Amazon RDS (Postgres):** Banco de dados relacional isolado em rede privada, preparado para conexões seguras via SSL.
* **NAT Gateways:** Permitem que os containers na rede privada realizem atualizações e acessem serviços externos de forma segura.



## 🛠️ Tecnologias Utilizadas

* **Infraestrutura:** Terraform
* **Aplicação:** Node.js 
* **Containerização:** Docker
* **Nuvem:** Amazon Web Services (AWS)
* **CI/CD:** AWS CodeBuild & GitHub

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
```

📸 Evidências do Projeto
Abaixo estão as evidências do funcionamento da infraestrutura na AWS no decorrer da sua construção.

1. Aplicação em Execução
Comprovação da API Node.js rodando em containers ECS Fargate e acessível publicamente através do Application Load Balancer (ALB).

<img width="1877" height="1038" alt="Captura de tela 2025-12-27 201641" src="https://github.com/user-attachments/assets/68bd2be7-cef8-400f-a74d-ca8bffcdaa97" />
Retorno JSON da API via DNS do Load Balancer.


2. Automação CI/CD
Evidência do fluxo de Integração Contínua funcionando. O AWS CodeBuild detecta alterações no GitHub, realiza o build da imagem Docker e atualiza o serviço automaticamente.

<img width="1876" height="995" alt="Captura de tela 2025-12-27 202742" src="https://github.com/user-attachments/assets/75f010e7-6141-42e9-ba52-3a5ab9afc2ee" />
Histórico de builds finalizados com sucesso no console da AWS.


3. Infraestrutura como Código (IaC)
Demonstração do ciclo de vida dos recursos gerenciados pelo Terraform, garantindo que a infraestrutura seja replicável e organizada.

[COLOQUE AQUI A IMAGEM: Captura de tela 2025-12-27 182823.png] Legenda: Execução do Terraform para provisionamento dos 28 recursos na AWS.


4. Gestão de Recursos e Custos
Uma das melhores práticas em Cloud é a limpeza de recursos após o uso. Aqui está a evidência da destruição controlada da stack para evitar custos desnecessários.

<img width="1104" height="614" alt="Captura de tela 2025-12-27 204217" src="https://github.com/user-attachments/assets/aace706f-0580-4661-bb14-5edd1ae1c79f" />
Encerramento seguro de toda a infraestrutura via comando terraform destroy.



