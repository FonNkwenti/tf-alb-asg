

resource "aws_instance" "ec2-client" {
  ami             = "ami-0cf10cdf9fcd62d37" 
  instance_type   = "t2.micro"  
  subnet_id       = aws_subnet.public_sn.id
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]
  key_name        = "default-ue1"  
#   iam_instance_profile = aws_iam_instance_profile.lattice_ec2_client_profile.name
  user_data_replace_on_change = true
  user_data_base64 = "IyEvYmluL2Jhc2gNCnN1ZG8geXVtIHVwZGF0ZSAteQ0Kc3VkbyB5dW0gaW5zdGFsbCAteSBodHRwZA0Kc3VkbyBzeXN0ZW1jdGwgc3RhcnQgaHR0cGQNCnN1ZG8gc3lzdGVtY3RsIGVuYWJsZSBodHRwZA0Kc3VkbyB1c2VybW9kIC1hIC1HIGFwYWNoZSBlYzItdXNlcg0Kc3VkbyBjaG93biAtUiBlYzItdXNlcjphcGFjaGUgL3Zhci93d3cNCnN1ZG8gY2htb2QgMjc3NSAvdmFyL3d3dw0Kc3VkbyBmaW5kIC92YXIvd3d3IC10eXBlIGQgLWV4ZWMgY2htb2QgMjc3NSB7fSBcOw0Kc3VkbyBmaW5kIC92YXIvd3d3IC10eXBlIGYgLWV4ZWMgY2htb2QgMDY2NCB7fSBcOw0Kc3VkbyBlY2hvICI8P3BocCBwaHBpbmZvKCk7ID8+IiA+IC92YXIvd3d3L2h0bWwvcGhwaW5mby5waHA="

  tags = {
    Name = "ec2-client"
  }
}

output "instance_private_ip" {
  value = aws_instance.ec2-client.private_ip
}
output "instance_public_ip" {
  value = aws_instance.ec2-client.public_ip
}
