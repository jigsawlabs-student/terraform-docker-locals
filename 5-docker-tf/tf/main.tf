provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "backend_server" {
  ami           = "ami-0d7a109bf30624c99"
  instance_type = "t2.micro"
  key_name = "example"
  
  vpc_security_group_ids = [aws_security_group.http_backend_security.id,
   aws_security_group.ssh_backend_security.id]
  
  
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y 
              sudo yum install docker -y
              sudo systemctl start docker
              sudo docker pull jek2141/foursquare_backend -y
              sudo docker run --platform=linux/amd64 -p 80:80 jek2141/foursquare_backend
              EOF
  
  tags = {
      Name = "backend server"
  }
}

resource "aws_security_group" "http_backend_security" {
  name = "new backend security"
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh_backend_security" {
    name = "ssh security"
    
    ingress {
        cidr_blocks = [
          "0.0.0.0/0"
        ]
    from_port = 22
        to_port = 22
        protocol = "tcp"
      }
    
      egress {
       from_port = 0
       to_port = 0
       protocol = "-1"
       cidr_blocks = ["0.0.0.0/0"]
     }
}

output "connection_instructions" {
  value = "ssh with the following: ssh -i ${aws_instance.backend_server.key_name}.pem ec2-user@${aws_instance.backend_server.public_dns}" 
}
