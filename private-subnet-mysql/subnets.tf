//Create Public Subnet
resource "aws_subnet" "tutorial_public_subnet" { 
  count             = var.subnet_count.public  
  vpc_id            = aws_vpc.tutorial_vpc.id   
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "tutorial_public_subnet_${count.index}"
  }
}

//Create Private Subnet
resource "aws_subnet" "tutorial_private_subnet" {
  count             = var.subnet_count.private
  vpc_id            = aws_vpc.tutorial_vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "tutorial_private_subnet_${count.index}"
  }
}