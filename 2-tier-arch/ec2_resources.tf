# Create ec2 instances
resource "aws_instance" "web1" {
  ami           = ""
  instance_type = "t2.micro"
  key_name        = ""
  availability_zone = "ap-south-1a"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  subnet_id                   = aws_subnet.public_1.id
  associate_public_ip_address = true
  tags = {
    Name = "web1_instance"
  }
}

resource "aws_instance" "web2" {
  ami           = ""
  instance_type = ""
  key_name        = "mykey"
  availability_zone = "ap-south-1b"
  vpc_security_group_ids      = [aws_security_group.public_sg.id]
  subnet_id                   = aws_subnet.public_2.id
  associate_public_ip_address = true
  tags = {
    Name = "web2_instance"
  }
}