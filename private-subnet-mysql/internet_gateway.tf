resource "aws_internet_gateway" "tutorial_igw" {
  vpc_id = aws_vpc.tutorial_vpc.id
  tags = {
    Name = "tutorial_igw"
  }
}