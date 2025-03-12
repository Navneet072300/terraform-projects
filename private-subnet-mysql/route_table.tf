// Create a public route table named "tutorial_public_rt"
resource "aws_route_table" "tutorial_public_rt" {
  vpc_id = aws_vpc.tutorial_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tutorial_igw.id
  }
}


// Here we are going to add the public subnets to the 
// "tutorial_public_rt" route table
resource "aws_route_table_association" "public" {
  count          = var.subnet_count.public
  route_table_id = aws_route_table.tutorial_public_rt.id
  subnet_id      = 	aws_subnet.tutorial_public_subnet[count.index].id
}


// Create a private route table named "tutorial_private_rt"
resource "aws_route_table" "tutorial_private_rt" {
  vpc_id = aws_vpc.tutorial_vpc.id
}


// Here we are going to add the private subnets to the
// route table "tutorial_private_rt"
resource "aws_route_table_association" "private" {
  count          = var.subnet_count.private
  route_table_id = aws_route_table.tutorial_private_rt.id
  subnet_id      = aws_subnet.tutorial_private_subnet[count.index].id
}