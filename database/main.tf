provider "aws" {
  region = "us-east-1"  # Change as needed
}

resource "aws_db_instance" "postgres" {
  identifier             = "my-postgres-db"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                = "postgres"
  engine_version        = "15.4"  # Use latest version available
  instance_class        = "db.t3.micro"
  username             = ""   # Change as needed
  password             = ""  # Change as needed
  publicly_accessible   = true  # Set to false for private access
  skip_final_snapshot   = true
  db_subnet_group_name  = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
}

# Create a DB subnet group for RDS
resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "postgres-subnet-group"
  subnet_ids = ["subnet-xxxxxxx", "subnet-yyyyyyy"] # Replace with your subnet IDs
}

# Security Group for PostgreSQL
resource "aws_security_group" "postgres_sg" {
  name_prefix = "postgres-sg"

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change to a specific IP for better security
  }
}

output "rds_endpoint" {
  value = aws_db_instance.postgres.endpoint
}
