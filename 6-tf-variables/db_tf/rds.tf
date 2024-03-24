resource "aws_db_instance" "postgres_db" {
  allocated_storage    = 20
  db_name =             "job_scraper"
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "16.1"  
  instance_class       = "db.t3.micro"
  username             = "postgres"
  password             = "password"
  parameter_group_name = "default.postgres16"
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids = [aws_security_group.postgres_access.id]
  tags = { Name = "scraper_db"}
}

resource "aws_security_group" "postgres_access" {
  name = "psql access 1"
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "connection_instructions" {
  value = "psql -d ${aws_db_instance.postgres_db.db_name} -h ${split(":", aws_db_instance.postgres_db.endpoint)[0]} -U ${aws_db_instance.postgres_db.username}"
}

