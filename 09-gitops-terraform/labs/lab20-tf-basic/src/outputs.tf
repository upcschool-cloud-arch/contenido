output "generated_plain" {
  description = "The random plain resource name."
  value       = local.generated_plain
}

output "generated_sensitive" {
  description = "The random sensitive resource name."
  value       = local.generated_sensitive
  sensitive   = true
}

