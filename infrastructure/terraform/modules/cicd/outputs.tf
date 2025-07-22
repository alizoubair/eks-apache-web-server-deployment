output "instance_public_ip" {
  value       = ""                                          # The actual value to be outputted
  description = "The public IP address of the EC2 instance" # Description of what this output represents
}

output "codepipeline_name" {
  value       = aws_codepipeline.codepipeline.name
  description = "The name of the CodePipeline"
}

output "github_connection_arn" {
  value       = aws_codestarconnections_connection.github.arn
  description = "The ARN of the CodeStar Connection for GitHub"
}