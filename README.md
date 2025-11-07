# API na AWS - Projeto de Infraestrutura

## O que é este projeto?

Este é um projeto onde coloquei uma API (aplicação) para rodar na nuvem da Amazon (AWS).

A API consegue:
- Receber requisições da internet
- Se conectar a um banco de dados PostgreSQL
- Responder com informações

## Como funciona?
```
Internet → Load Balancer → Aplicação (Container) → Banco de Dados
```

1. **Alguém acessa** a URL da API
2. O **Load Balancer** recebe a requisição
3. O **Container** (aplicação) processa
4. O **Banco de Dados** guarda/busca informações
5. A resposta volta para quem pediu

## O que usei para construir isso?

### Na AWS (Amazon):
- **VPC**: Rede isolada na nuvem
- **ECS Fargate**: Roda a aplicação em containers
- **RDS PostgreSQL**: Banco de dados gerenciado
- **CodeBuild**: Cria a imagem da aplicação automaticamente
- **ECR**: Guarda as imagens Docker
- **CloudWatch**: Mostra os logs (registros) da aplicação

### Tecnologias:
- **Node.js**: Linguagem da aplicação
- **Docker**: Empacota a aplicação
- **PostgreSQL**: Banco de dados

## Como testar?

A API tem 2 rotas que você pode testar:

**Rota 1 - Verificar se está funcionando:**
```
http://[IP-DA-APLICACAO]:3000
- Desativada por custos da nuvem
```

**Rota 2 - Testar conexão com banco:**
```
http://[IP-DA-APLICACAO]:3000/connect
- Desativada por custos da nuvem
```

## O que eu fiz?

Neste projeto eu aprendi:

✅ criei infraestrutura na nuvem (AWS)
✅ usei containers (Docker)
✅ conectei aplicação com banco de dados
✅ fiz deploy simples automatizado (CI/CD)
✅ configurar segurança (firewalls, SSL)

## Segurança

O projeto tem segurança em várias camadas:

- Banco de dados em rede privada (ninguém de fora acessa direto)
- Comunicação com SSL/TLS (criptografada)
- Firewall (Security Groups) controlando o acesso

## Custos

O projeto custa aproximadamente:
- **$0-9/mês** se ficar ligado 24 horas
- **$0/mês** se desligar quando não usar

Para economizar, os recusos da AWS estão desligados.

-------------------------------------------------------------------------------------------------------------------------------------------------





# simple-api

## Descrição
Uma API em Node.js utilizando o Express Framework que realiza a conexão com um banco de dados PostgreSQL.

## Como utilizar
O comando para iniciar a API é **npm run start**

## Rotas
| Rota | Método | Descrição |
| --- | --- | --- |
/ | GET | Retorna uma mensagem estática.
/connect | GET | Realiza a conexão com o banco e retorna a versão da engine.


## Variáveis de Ambiente
| Nome | Description  | Padrão |
| --- |  --- |  --- |
API_PORT | Port da API Node | 3000
DB_DATABASE | Database do banco de dados | 
DB_HOST | Endereço do banco de dados | 
DB_PORT | Port do banco de dados | 5432
DB_USER | Usuário do banco de dados | 
DB_PASSWORD | Senha do banco de dados | 









## Autor

Vagner Vitor de Oliveira Melo
