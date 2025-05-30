output "vpc_id" {
  value = aws_vpc.this.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "igw_id" {
  value = aws_internet_gateway.this.id
}
