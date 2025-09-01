//* Create an EC2 resource
resource "aws_instance" "marlon-ec2" {
    ami            = "ami-00ca32bbc84273381" # Amazon Linux 2023
    instance_type  = "t3.micro"
    subnet_id     = "subnet-091d699430cc1eef4" #"subnet-03756451ef526c87c"
    associate_public_ip_address = true 
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]

    tags = {
        Name = "marlon-ec2"
    }
  }

  resource "aws_security_group" "allow_ssh" { 
  name        = "marlon-security-group"  
  description = "Allow SSH inbound" 
  vpc_id      = "vpc-042a26ae32a664936"  
  
  # Inbound rules
  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# Create a 1GB EBS Volume in the same Availability Zone as the instance
resource "aws_ebs_volume" "additional_volume" {
  availability_zone = aws_instance.marlon-ec2.availability_zone
  size              = 1 # Size in GB

  tags = {
    Name = "Additional1GB"
  }
}

# Attach the EBS Volume to the EC2 instance
resource "aws_volume_attachment" "additional_volume_attachment" {
  device_name = "/dev/sdh" # or /dev/xvdh depending on the OS
  volume_id   = aws_ebs_volume.additional_volume.id
  instance_id = aws_instance.marlon-ec2.id
}
