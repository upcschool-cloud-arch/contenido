output "username" {
  value = var.github_user
}

output "public_ip" {
  value = aws_eip.this.public_ip
}

output "ssh_cmd" {
  value = format(
    "ssh -A %s@%s", var.system_user, aws_eip.this.public_ip
  )
}
