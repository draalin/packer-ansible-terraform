output "ssh" {
  value = "ssh -i ${aws_key_pair.key.key_name} ubuntu@${aws_instance.ec2.public_ip}"
}

output "public_ip" {
  value = aws_instance.ec2.public_ip
}
