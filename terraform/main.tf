#Sets the provider and the region that the instance will be ran from on aws

provider "aws" {
 region = "us-west-2"
}


# The three functions below are going to make a new key pair, useing RSA. It then will put the file in the current
#Directory that you ran the command from.

resource "tls_private_key" "minecraft_key" {
 algorithm = "RSA"
 rsa_bits  = 2048
}


resource "aws_key_pair" "minecraft_key" {
 key_name   = "minecraft-key"
 public_key = tls_private_key.minecraft_key.public_key_openssh
}


resource "local_file" "private_key" {
 content  = tls_private_key.minecraft_key.private_key_pem
 filename = "${path.module}/minecraft-key.pem"
}


# Create the VPC
resource "aws_vpc" "minecraft_vpc" {
 cidr_block = "10.0.0.0/16"
 tags = {
   Name = "MinecraftVPC"
 }
}


# Create a the subnet for minecraft Server

resource "aws_subnet" "minecraft_subnet" {
 vpc_id            = aws_vpc.minecraft_vpc.id
 cidr_block        = "10.0.1.0/24"
 availability_zone = "us-west-2a"
 tags = {
   Name = "MinecraftSubnet"
 }
}


# Create an Internet Gateway
resource "aws_internet_gateway" "minecraft_igw" {
 vpc_id = aws_vpc.minecraft_vpc.id
 tags = {
   Name = "MinecraftIGW"
 }
}


# Creates the routing table directing traffic and allowing internet connection

resource "aws_route_table" "minecraft_route_table" {
 vpc_id = aws_vpc.minecraft_vpc.id


 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.minecraft_igw.id
 }


 tags = {
   Name = "MinecraftRouteTable"
 }
}


# The function below will associate the routing table with the subnet

resource "aws_route_table_association" "minecraft_route_table_association" {
 subnet_id      = aws_subnet.minecraft_subnet.id
 route_table_id = aws_route_table.minecraft_route_table.id
}


# The below code will make the security group that the instance will use. It uses ingress to declear the inbound rules neeeded
# and egress is for the out bound rule. It sets the group name to minecraft_sg

resource "aws_security_group" "minecraft_sg" {
 vpc_id = aws_vpc.minecraft_vpc.id


 ingress {
   from_port   = 22
   to_port     = 22
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }


 ingress {
   from_port   = 25565
   to_port     = 25565
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"]
 }


 egress {
   from_port   = 0
   to_port     = 0
   protocol    = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }


 tags = {
   Name = "MinecraftSecurityGroup"
 }
}


# Creates the ec2 instance called minecraft2.0

resource "aws_instance" "minecraft" {
 ami                        = "ami-05a6dba9ac2da60cb"
 instance_type              = "t4g.small"
 subnet_id                  = aws_subnet.minecraft_subnet.id
 vpc_security_group_ids     = [aws_security_group.minecraft_sg.id]
 
 associate_public_ip_address = true
 key_name                   = aws_key_pair.minecraft_key.key_name
 tags = {
   Name = "Minecraft2.0 Server"
 }


 provisioner "local-exec" {
   command = <<EOT
cat <<EOF > inventory.ini
[minecraft]
${self.public_ip} ansible_user=ec2-user ansible_ssh_private_key_file="${path.module}/minecraft-key.pem"
EOF
EOT
 }
}

