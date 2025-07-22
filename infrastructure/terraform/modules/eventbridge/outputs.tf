output "event_bus_name" {
  description = "Custom EventBridge bus name"
  value       = aws_cloudwatch_event_bus.custom_event_bus.name
}

output "event_bus_arn" {
  description = "Custom EventBridge bus ARN"
  value       = aws_cloudwatch_event_bus.custom_event_bus.arn
}

output "custom_event_bus_arn" {
  description = "Custom EventBridge bus ARN"
  value       = aws_cloudwatch_event_bus.custom_event_bus.arn
}