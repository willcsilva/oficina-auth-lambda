# ==============================================================================
# VARIÁVEIS DO BANCO DE DADOS (Injetadas via GitHub Secrets)
# ==============================================================================

variable "db_name" {
  description = "Nome do banco de dados PostgreSQL"
  type        = string
  default     = "oficina_db" # Pode ter um valor padrão se não for sensível
}

variable "db_username" {
  description = "Usuário master do banco de dados RDS"
  type        = string
  sensitive   = true # Evita que o valor apareça nos logs do Terraform
}

variable "db_password" {
  description = "Senha master do banco de dados RDS"
  type        = string
  sensitive   = true # Evita que o valor apareça nos logs do Terraform
}

# ==============================================================================
# VARIÁVEIS DE SEGURANÇA E JWT
# ==============================================================================

variable "jwt_secret" {
  description = "Chave secreta forte para assinar os tokens JWT"
  type        = string
  sensitive   = true # Super crítico: nunca deixe isso exposto!
}
