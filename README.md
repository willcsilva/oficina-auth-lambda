# FIAP - Post Tech: Software Architecture (SOAT)
## Projeto Oficina Mecânica - Fase 3 (SOAT/FIAP)

**Autor:** William Crispin da Silva  
**Contato:** [willcsilva15@gmail.com] | Discord: `@Crispin - RM369067` | `will1515` 
**Grupo:** Grupo 40

---

## 📋 Cenário e Problema
Com a expansão da oficina para múltiplas unidades e o aumento
constante na base de clientes, tornou-se necessário garantir segurança,
escalabilidade e alta disponibilidade, além de obter visibilidade total sobre o
funcionamento do sistema

🎯 Soluções e Arquitetura
Para atender às novas exigências da direção, o sistema foi redesenhado entregando as seguintes capacidades:

🔐 Segurança e Autenticação Serverless: Implementação de um fluxo de autenticação robusto utilizando Amazon API Gateway e AWS Lambda (Node.js). A validação das credenciais dos clientes (via CPF) é feita conectando a Lambda diretamente ao Amazon RDS de forma criptografada (SSL), gerando um token JWT. A API principal (Spring Boot) valida a assinatura deste JWT, protegendo os endpoints de acessos indevidos.

📈 Monitoramento e Observabilidade: Centralização dos logs e telemetria através do Amazon CloudWatch. O ambiente é monitorado em tempo real, permitindo a detecção rápida de gargalos, rastreamento de erros nas funções Serverless e visibilidade total sobre a saúde da infraestrutura.

✉️ Comunicação Assíncrona: Adoção de arquitetura orientada a eventos utilizando Amazon SNS (Simple Notification Service) para o disparo de notificações e atualizações de Ordens de Serviço, desacoplando essa responsabilidade da aplicação principal.

⚙️ Infraestrutura como Código e CI/CD (GitOps): Segregação total de responsabilidades em múltiplos repositórios (API EKS, Banco de Dados RDS, Auth Lambda e SNS). O provisionamento foi 100% automatizado utilizando Terraform e GitHub Actions. As esteiras (Pipelines) garantem integração e entrega contínuas com etapas de plan, criação automática de Pull Requests (Auto-PR) e travas de aprovação manual para o ambiente de produção.

🗄️ Evolução e Consistência de Dados: Melhoria na modelagem do banco de dados relacional (PostgreSQL no Amazon RDS). A evolução do esquema de dados foi alinhada com as entidades de domínio da aplicação (como a inclusão e validação do CPF), garantindo a integridade referencial e a performance necessária para a escala do negócio.

---

## 🔗 Repositórios e Artefatos

* **Código Fonte (GitHub):**

* **Localstack Oficina Mecanica (GitHub):** https://github.com/willcsilva/localstack
* **VPC Infra Network Oficina Mecanica (GitHub):** https://github.com/willcsilva/oficina-network-infra
* **EKS Cluster Kubernetes Oficina Mecanica (GitHub):** https://github.com/willcsilva/oficina-k8s-cluster
* **APP Lambda + API Gateway (GitHub):** https://github.com/willcsilva/oficina-auth-lambda
* **RDS DB Oficina Mecanica (GitHub):** https://github.com/willcsilva/oficina-db-infra
* **SNS Notificacao Oficina Mecanica (GitHub):** https://github.com/willcsilva/oficina-sns
* **APP Oficina Mecanica (GitHub):** https://github.com/willcsilva/oficina-app

* **Imagem Docker (Docker Hub):** [willcsilva/oficina-api](https://hub.docker.com/repository/docker/willcsilva/oficina-api/general)

* **Vídeo Demonstrativo:** [Assistir no Youtube](https://www.youtube.com/watch?v=yjOY-9_u99I)

---

## 🚀 Arquitetura da Solução

A aplicação foi refatorada seguindo os princípios da **Arquitetura Hexagonal**, isolando o domínio de negócio das tecnologias externas (banco de dados, mensageria ,frameworks e infraestrutura).

### Desenho da Infraestrutura Proposta

![Arquitetura da Solução](FIAP-13-SOAT/Desenho/Arch-App.png)

----

![Clean Architecture](FIAP-13-SOAT/Desenho/Clean Arch.png)




# Projeto Oficina Mecânica - Fase 3 (SOAT/FIAP)

Este repositório contém a solução completa para o sistema de gestão de ordens de serviço, focada em alta disponibilidade, escalabilidade e automação em ambiente AWS Cloud Serveless

---

## 🔗 Repositórios e Artefatos

* **Localstack Oficina Mecanica (GitHub):** https://github.com/willcsilva/localstack
* **VPC Infra Network Oficina Mecanica (GitHub):** https://github.com/willcsilva/oficina-network-infra
* **EKS Cluster Kubernetes Oficina Mecanica (GitHub):** https://github.com/willcsilva/oficina-k8s-cluster
* **APP Lambda + API Gateway (GitHub):** https://github.com/willcsilva/oficina-auth-lambda
* **RDS DB Oficina Mecanica (GitHub):** https://github.com/willcsilva/oficina-db-infra
* **SNS Notificacao Oficina Mecanica (GitHub):** https://github.com/willcsilva/oficina-sns
* **APP Oficina Mecanica (GitHub):** https://github.com/willcsilva/oficina-app

* **Imagem Docker (Docker Hub):** [willcsilva/oficina-api](https://www.youtube.com/watch?v=yjOY-9_u99I)

---

## 🚀 Arquitetura da Solução

A solução utiliza uma arquitetura hexagonal (Clean Architecture) e é orquestrada no Amazon EKS, garantindo que o sistema seja resiliente a falhas e capaz de escalar conforme a demanda,Segurança e Autenticação Serverless, Monitoramento e Observabilidade,Comunicação Assíncrona,Infraestrutura como Código e CI/CD separados e Evolução e Consistência de Dados.
### Componentes de Infraestrutura:
* **Orquestração**: Amazon EKS (Elastic Kubernetes Service).
* **Banco de Dados**: Amazon RDS PostgreSQL (Instância gerenciada para persistência segura).
* **Mensageria**: Amazon SNS (Notificações de status e envio de recibos por e-mail).
* **Rede**: VPC customizada com Subnets Públicas e Privadas, NAT Gateway e Internet Gateway.
* **Escalabilidade**: HPA (Horizontal Pod Autoscaler) baseado em consumo de CPU.


## 🛠️ Pré-requisitos para a Banca

Para executar os workflows de automação, as seguintes credenciais devem estar configuradas no **GitHub Secrets** do repositório:

| Secret | Descrição |
| :--- | :--- |
| `AWS_ACCESS_KEY_ID` | Chave de acesso AWS. |
| `AWS_SECRET_ACCESS_KEY` | Chave secreta AWS. |
| `RDS_PASSWORD` | Senha master para a instância do PostgreSQL no RDS. |
| `DB_USER` | Nome de usuário para o banco de dados. |
| `DB_PASS` | Senha de conexão da aplicação com o banco. |
| `DOCKERHUB_USERNAME` | Usuário do Docker Hub para push da imagem. |
| `DOCKERHUB_TOKEN` | Access Token (ou senha) do Docker Hub. |

---

## ⚙️ Fluxo de Operação (GitHub Actions)

O projeto é 100% automatizado através de workflows do GitHub Actions. Não é necessária nenhuma intervenção manual via CLI para o deploy.

### 1. Provisionamento e Deploy (Apply)
Para subir toda a infraestrutura e a aplicação:
1. Vá até a aba **Actions** do repositório.
2. Selecione o workflow **"Terraform-Apply-Infra-Cloud"**.
3. Clique em **Run workflow**.
3.1. O deploy esta automatizado. Ao atualizar qualquer parte do codigo e comita-lo, 'e possivel visualizar o deploy automatico via esteira CI/CD

**O que este workflow faz:**
* Cria a VPC e o Cluster EKS.
* Provisiona o Banco de Dados RDS e o Tópico SNS.
* Compila a aplicação Java, executa testes unitários e gera a imagem Docker.
* Realiza o push da imagem para o **Docker Hub**.
* Realiza o deploy dos manifestos K8s (Deployment, Service, HPA).

### 2. Destruição da Infraestrutura (Destroy)
Para limpar todos os recursos e evitar faturamento residual:
1. Selecione o workflow **"Terraform-Destroy-Infra-Cloud"**.
2. Clique em **Run workflow**.

---

### Acesso ao cluster e gerenciamento

Utilize o comando abaixo para gerenciar o cluster EKS

aws eks update-kubeconfig --name <<Nome do cluster>> --region us-east-2

---


## 📖 Guia de Uso da API

Após o término do deploy bem-sucedido, a URL do Load Balancer será exibida nos logs da Action no passo "Get Application Endpoint". A documentação interativa pode ser acessada em:
`http://<LB-DNS-URL>/swagger-ui.html`

Obs: Usuario: admin  |  Senha: admin123

Sera mostrado o has da senha para autenticacao. Copie o valor e clique em "Authorize" para desbloquear o acesso a API
---

### Endpoints Principais (Requisitos da Fase 3):

🧪 Como Testar a Autenticação (Fim a Fim)
O fluxo de segurança da aplicação garante que apenas usuários válidos recebam um Token JWT gerado por uma função Serverless (AWS Lambda) e que a API principal (Spring Boot no EKS) valide criptograficamente esse token antes de liberar o acesso.

Siga os passos abaixo para validar o fluxo End-to-End:

## Passo 1: Cadastrar um Cliente na Base de Dados
Como o banco de dados é recriado nas esteiras de CI/CD, primeiro precisamos garantir que existe um usuário válido no PostgreSQL (RDS).
Você pode fazer isso via Swagger ou executando o comando abaixo para a API principal (Load Balancer do EKS):

Codigo: Execute via Swagger ou via Terminal.

curl -X POST http://ENDERECO-DO-LOAD-BALANCER/api/clientes \
     -H "Content-Type: application/json" \
     -d '{
           "nome": "Willian Teste FIAP",
           "email": "willian.fase3@fiap.com.br",
           "telefone": "11999999999",
           "cpf": "11122233344"
         }'
Aguarde o retorno de sucesso (200 OK ou 201 Created).

## Passo 2: Gerar o Token JWT (Serverless Auth)
Com o cliente na base, vamos solicitar a autenticação na nossa AWS Lambda através do API Gateway. A Lambda irá se conectar ao RDS de forma segura (SSL), validar o CPF e, se encontrado, assinar e devolver um Token JWT.

curl -X POST https://ENDERECO-DO-API-GW/apiuth \
     -H "Content-Type: application/json" \
     -d '{"cpf": "11122233344"}'

## Passo 3: Consumir uma Rota Protegida (EKS)
Agora, vamos tentar acessar uma rota protegida da aplicação Spring Boot passando o token gerado. O Spring Security interceptará a chamada, decodificará a assinatura do JWT (usando a mesma Secret da Lambda em Base64) e liberará o acesso aos dados.

curl -X GET http://oficina-alb-1075787379.us-east-2.elb.amazonaws.com/api/clientes \
     -H "Authorization: Bearer <COLE_O_SEU_TOKEN_AQUI>"

O sistema retornará HTTP 200 OK com a lista de clientes, comprovando a eficácia do controle de acesso e a comunicação perfeita entre a borda (API Gateway/Lambda) e o core da aplicação (EKS/RDS).


## A Escolha do Banco de Dados: Amazon RDS (PostgreSQL)
Para suportar o crescimento da rede de oficinas e o volume crescente de Ordens de Serviço (OS) e transações financeiras, a camada de persistência precisava ser robusta, segura e livre de gargalos operacionais. A escolha arquitetural foi a adoção do PostgreSQL gerenciado pelo Amazon RDS (Relational Database Service).

Os principais motivadores e benefícios dessa escolha para o projeto foram:

Integridade e Consistência (ACID): Como o sistema lida com dados críticos (dados de clientes, veículos, peças e faturamento), a natureza relacional do PostgreSQL garante que a modelagem de dados mantenha a consistência através de chaves estrangeiras e transações seguras, prevenindo anomalias no banco.

Redução de Carga Operacional (Managed Service): Sendo um serviço gerenciado (PaaS), o Amazon RDS remove a complexidade de administrar a infraestrutura do banco. Rotinas de backups automatizados, atualizações de patch e manutenção do sistema operacional ficam a cargo da AWS, permitindo que a equipe foque 100% no desenvolvimento das regras de negócio.

Segurança e Isolamento de Rede: O banco de dados foi provisionado dentro de uma sub-rede privada na VPC, blindando-o contra acessos externos diretos. Toda a comunicação com o cluster EKS (Spring Boot) e com a AWS Lambda (Node.js) ocorre internamente e é estritamente criptografada via SSL, atendendo aos mais altos requisitos de segurança e conformidade.

Performance e Escalabilidade: O PostgreSQL é amplamente reconhecido por sua alta performance em consultas complexas (essencial para a geração de relatórios de peças e OS). Além disso, o RDS permite escalar o poder computacional (CPU/RAM) ou o armazenamento verticalmente com poucos cliques, ou adicionar réplicas de leitura (Read Replicas) futuramente para absorver o aumento de tráfego das novas unidades da oficina.

Compatibilidade e Ecossistema: A integração nativa e fluida do PostgreSQL com frameworks modernos de mercado, como o Hibernate/Spring Data JPA no ecossistema Java e a biblioteca pg no Node.js, acelerou o desenvolvimento e a confiabilidade das esteiras de deploy da aplicação.

---


## 📘 Documentação da Arquitetura

- [Diagrama de Entidades JPA](docs/auto-entidades.md)
- [Diagrama de Mappers](docs/auto-mappers.md)
- [Diagrama de Services](docs/auto-services.md)
- [Diagrama de Controllers](docs/auto-controllers.md)
- [Arquitetura Geral](docs/auto-arquitetura.md)

---

## Diagrama Geral da Arquitetura

```mermaid
flowchart TD
   Controller --> Service --> Repository --> Entity
   Entity --> Mapper --> DTO --> Controller
```
---

# Arquitetura Geral da Aplicação

Este diagrama mostra como os módulos Controller → Mapper → DTO → Repository → Entity se relacionam.

```mermaid
flowchart LR
    subgraph Controllers
        OS[OrdemServicoController]
        PC[PecaController]
        CC[ClienteController]
    end

    subgraph Mappers
        OM[OrdemServicoMapper]
        IM[ItemOrdemServicoMapper]
        PM[PecaMapper]
        CM[ClienteMapper]
    end

    subgraph DTOs
        OSDTO[OrdemServicoResponseDTO]
        ItemDTO[ItemOrdemServicoDTO]
        PecaDTO[PecaDTO]
        ClienteDTO[ClienteDTO]
    end

    subgraph Persistence
        OSRepo[OrdemServicoRepository]
        PecaRepo[PecaRepository]
        ClienteRepo[ClienteRepository]
    end

    subgraph Entities
        OSE[OrdemServicoEntity]
        IOSE[ItemOrdemServicoEntity]
        PE[PecaEntity]
        CE[ClienteEntity]
    end

    OS --> OM
    PC --> PM
    CC --> CM

    OM --> OSDTO
    IM --> ItemDTO
    PM --> PecaDTO
    CM --> ClienteDTO

    OS --> OSRepo
    PC --> PecaRepo
    CC --> ClienteRepo

    OSRepo --> OSE
    PecaRepo --> PE
    ClienteRepo --> CE

    OSE --> IOSE
    IOSE --> PE
    OSE --> CE