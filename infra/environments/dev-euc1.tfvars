### Common variable
aws_region  = "eu-central-1"
environment = "development"


### Network
vpc_cidr = "10.0.0.0/20"
public_subnets_config = {
  public_a = {
    name                     = "main-dev-public-a"
    cidr_block               = "10.0.1.0/24"
    availability_zone_letter = "a"
    map_public_ip_on_launch  = true
  }
  public_b = {
    name                     = "main-dev-public-b"
    cidr_block               = "10.0.2.0/24"
    availability_zone_letter = "b"
    map_public_ip_on_launch  = true
  }
  public_c = {
    name                     = "main-dev-public-c"
    cidr_block               = "10.0.3.0/24"
    availability_zone_letter = "c"
    map_public_ip_on_launch  = true
  }
}

private_subnets_config = {
  private_a = {
    name                     = "main-dev-private-a"
    cidr_block               = "10.0.10.0/24"
    availability_zone_letter = "a"
    map_public_ip_on_launch  = false
    nat_key                  = "public_a"
  }
  private_b = {
    name                     = "main-dev-private-b"
    cidr_block               = "10.0.11.0/24"
    availability_zone_letter = "b"
    map_public_ip_on_launch  = false
    nat_key                  = "public_b"
  }
  private_c = {
    name                     = "main-dev-private-c"
    cidr_block               = "10.0.12.0/24"
    availability_zone_letter = "c"
    map_public_ip_on_launch  = false
    nat_key                  = "public_c"
  }
}