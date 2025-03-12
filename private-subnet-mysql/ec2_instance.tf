// Create an EC2 instance named "tutorial_web"
resource "aws_instance" "tutorial_web" {
  count = var.settings.web_app.count
  ami                    = ""
  instance_type          = var.settings.web_app.instance_type
  subnet_id              = aws_subnet.tutorial_public_subnet[count.index].id 
  key_name               = ""   
  vpc_security_group_ids = [aws_security_group.tutorial_web_sg.id]
  tags = {
    Name = "tutorial_web_${count.index}"
  }
}