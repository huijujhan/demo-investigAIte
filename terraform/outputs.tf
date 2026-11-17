output "vpc_id" {
  description = "VPC ID for the deployed environment."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = aws_subnet.private[*].id
}

output "ec2_instance_id" {
  description = "EC2 instance ID for the Streamlit app host."
  value       = aws_instance.app.id
}

output "ec2_public_ip" {
  description = "EC2 public IP address, if present."
  value       = aws_instance.app.public_ip
}

output "instance_profile_name" {
  description = "IAM role profile used by the EC2 application host."
  value       = aws_iam_instance_profile.ec2_app_profile.name
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group for application logs."
  value       = aws_cloudwatch_log_group.application.name
}

output "artifact_bucket" {
  description = "Optional S3 artifact bucket name."
  value       = var.create_artifacts_bucket ? aws_s3_bucket.artifacts[0].bucket : null
}

output "alb_dns_name" {
  description = "DNS name for the ALB if enabled."
  value       = var.enable_alb ? aws_lb.app[0].dns_name : null
}
