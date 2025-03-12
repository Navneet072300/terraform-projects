// Create an Elastic IP named "tutorial_web_eip" for each
// EC2 instance
resource "aws_eip" "tutorial_web_eip" {
  count    = var.settings.web_app.count
  instance = aws_instance.tutorial_web[count.index].id
  tags = {
    Name = "tutorial_web_eip_${count.index}"
  }
}