terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket = "s3-bucket-willow"
    key    = "state/auth-lambda/terraform.tfstate" # Estado exclusivo para a Lambda
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}

# ==============================================================================
# 1. BUSCA DE DADOS (REMOTE STATE)
# ==============================================================================

# Lendo a VPC e Subnets do repositório de rede
data "terraform_remote_state" "network" {
  backend = "s3"
  config = {
    bucket = "s3-bucket-willow"
    key    = "state/network/terraform.tfstate"
    region = "us-east-2"
  }
}

# Lendo o Endpoint do RDS do repositório de banco de dados
data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket = "s3-bucket-willow"
    key    = "state/db/terraform.tfstate"
    region = "us-east-2"
  }
}

# ==============================================================================
# 2. SEGURANÇA (IAM ROLE E SECURITY GROUP)
# ==============================================================================

# Role da Lambda
resource "aws_iam_role" "lambda_role" {
  name = "oficina_auth_lambda_role_prod"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

# Permite que a Lambda escreva logs e acesse a VPC (crucial para falar com o RDS)
resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

# Security Group da Lambda (Permite saída total, necessário para VPC)
resource "aws_security_group" "lambda_sg" {
  name        = "oficina-auth-lambda-sg"
  description = "Security Group para a Lambda de Autenticacao acessar o RDS"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ==============================================================================
# 3. FUNÇÃO LAMBDA
# ==============================================================================

# Criamos um ZIP vazio só pro Terraform conseguir provisionar o recurso inicial.
# O código real será injetado pelo GitHub Actions depois.
data "archive_file" "dummy_zip" {
  type        = "zip"
  output_path = "${path.module}/dummy.zip"
  source {
    content  = "exports.handler = async (event) => { return { statusCode: 200, body: 'Dummy' }; };"
    filename = "index.js"
  }
}

resource "aws_lambda_function" "auth" {
  function_name = "AuthLambdaProd"
  role          = aws_iam_role.lambda_role.arn
  runtime       = "nodejs18.x"
  handler       = "index.handler"
  filename      = data.archive_file.dummy_zip.output_path

  # Isso obriga o Terraform a DESTRUIR o API Gateway ANTES de mexer na Lambda
  depends_on = [
    aws_apigatewayv2_route.auth_route,
    aws_apigatewayv2_integration.lambda_integration,
    aws_apigatewayv2_api.http_api
  ]

  # Coloca a Lambda nas mesmas subnets privadas do banco
  vpc_config {
    subnet_ids         = data.terraform_remote_state.network.outputs.private_subnets
    security_group_ids = [aws_security_group.lambda_sg.id]
  }

  # Variáveis de ambiente dinâmicas
  environment {
    variables = {
      DB_HOST     = data.terraform_remote_state.db.outputs.db_instance_address
      DB_USER     = var.db_username
      DB_PASSWORD = var.db_password
      DB_NAME     = var.db_name
      JWT_SECRET  = var.jwt_secret
    }
  }
}

# ==============================================================================
# 4. API GATEWAY (Gera a URL pública para chamar a Lambda)
# ==============================================================================

resource "aws_apigatewayv2_api" "http_api" {
  name          = "oficina-auth-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id                 = aws_apigatewayv2_api.http_api.id
  integration_type       = "AWS_PROXY"
  integration_method     = "POST"
  integration_uri        = aws_lambda_function.auth.invoke_arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "auth_route" {
  api_id    = aws_apigatewayv2_api.http_api.id
  route_key = "POST /auth"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.http_api.id
  name        = "$default"
  auto_deploy = true
}

resource "aws_lambda_permission" "api_gw_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.auth.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}

# Imprime a URL final no terminal para você usar no Front-end!
output "api_endpoint" {
  value = "${aws_apigatewayv2_api.http_api.api_endpoint}/auth"
}