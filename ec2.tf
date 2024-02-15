

resource "aws_instance" "jumphost" {
  ami             = "ami-0323d48d3a525fd18" 
  instance_type   = "t2.micro"  
  subnet_id       = aws_subnet.public_sn_az1.id
  vpc_security_group_ids = [aws_security_group.ssh_sg.id, aws_security_group.jumphost_sg.id]
  key_name        = "default-eu1"  
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
  user_data_replace_on_change = true
  user_data = base64encode(file("webserver.sh")) 
#   user_data_base64 = 
  tags = {
    Name = "jumphost"
  }
}



output "jumphost_private_ip" {
  value = aws_instance.jumphost.private_ip
}
output "jumphost_public_ip" {
  value = aws_instance.jumphost.public_ip
}
