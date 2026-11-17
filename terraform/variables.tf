variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "Project name used in AWS resource tags and naming."
  type        = string
  default     = "investigaite"
}

variable "environment" {
  description = "Deployment environment name."
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the base VPC."
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
  default     = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "allowed_ingress_cidrs" {
  description = "CIDR ranges allowed to reach the application and SSH endpoints. Replace with the real operational network ranges before production use."
  type        = list(string)
  default     = ["203.0.113.0/24"]
}

variable "app_port" {
  description = "Port exposed by the Streamlit application."
  type        = number
  default     = 8501
}

variable "ec2_instance_type" {
  description = "EC2 instance type for the application host."
  type        = string
  default     = "t3.medium"
}

variable "ec2_ami_id" {
  description = "Optional EC2 AMI ID override. If empty, the latest Amazon Linux 2023 AMI is used."
  type        = string
  default     = ""
}

variable "enable_alb" {
  description = "Whether to create an Application Load Balancer in front of the EC2 instance."
  type        = bool
  default     = false
}

variable "create_artifacts_bucket" {
  description = "Whether to create a dedicated S3 bucket for app artifacts and report staging."
  type        = bool
  default     = true
}

variable "artifact_bucket_name" {
  description = "Name for the optional artifact bucket. Must be globally unique when enabled."
  type        = string
  default     = "investigaite-artifacts"
}

variable "alb_certificate_arn" {
  description = "Optional ACM certificate ARN for ALB HTTPS termination. If empty, the load balancer uses HTTP mode only."
  type        = string
  default     = ""
}

variable "arcos_lambda_name" {
  description = "Name of the ARCOS Lambda handler used by the application."
  type        = string
  default     = "arcos-nl-sql-handler"
}

variable "dea6_lambda_name" {
  description = "Name of the DEA-6 Lambda handler used by the application."
  type        = string
  default     = "dea6-bedrock-kb-handler"
}

variable "intent_model_id" {
  description = "Bedrock model ID used for intent routing."
  type        = string
  default     = "us.anthropic.claude-sonnet-4-6"
}

variable "explain_model_id" {
  description = "Bedrock model ID used for SQL explanation."
  type        = string
  default     = "us.anthropic.claude-sonnet-4-6"
}

variable "report_model_id" {
  description = "Bedrock model ID used for report synthesis."
  type        = string
  default     = "us.anthropic.claude-sonnet-4-6"
}
