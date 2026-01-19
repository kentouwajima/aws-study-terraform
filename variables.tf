variable "alert_email" {
  description = "Email address for alarm notifications"
  type        = string
  default     = "u.kento6366@gmail.com" 
}

variable "db_password" {
  description = "RDS database master password. Must be provided via terraform.tfvars or environment variable TF_VAR_db_password"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Database password must be at least 8 characters long."
  }
}