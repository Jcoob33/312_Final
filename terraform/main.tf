provider "aws" {
  region = "us-west-2"  # Replace with your preferred region
}

data "aws_vpc" "existing_vpc" {
  id = "vpc-04b337a28e503db49"  # Replace with your VPC ID
}

data "aws_subnet" "existing_subnet" {
  id = "subnet-08c4caa771128b5e4"  # Replace with your existing subnet ID
}

data "aws_security_group" "existing_minecraft_sg" {
  id = "sg-048cb1a8dce05d110" 
}

resource "aws_instance" "minecraft" {
  ami                      = "ami-05a6dba9ac2da60cb"  # Replace with the appropriate AMI ID for your region
  instance_type            = "t4g.small"
  subnet_id                = data.aws_subnet.existing_subnet.id
  vpc_security_group_ids   = [data.aws_security_group.existing_minecraft_sg.id]
  associate_public_ip_address = true
  tags = {
    Name = "Minecraft3.0 Server"
  }

  key_name = "Minecraft"  # Replace with your key pair name

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y docker
    sudo service docker start
    sudo usermod -a -G docker ec2-user
    sudo docker run -d -p 25565:25565 --name minecraft-server itzg/minecraft-server
    echo "Docker container started" > /tmp/user_data.log
  EOF
}
