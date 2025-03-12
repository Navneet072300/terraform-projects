resource "aws_db_instance" "tutorial_database" {
 allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  username = "admin"
  password = "admin12345678"
  db_name                = "tutorial"
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.tutorial_db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.tutorial_db_sg.id]
}