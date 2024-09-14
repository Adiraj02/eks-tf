aws_region               = "us-west-2"
env                      = "Dev"
owner                    = "Aditya"
vpc_cidr_range           = "10.191.0.0/16"
public_subnet_cidrs      = ["10.191.192.0/20", "10.191.208.0/20", "10.191.224.0/20"]
app_private_subnet_cidrs = ["10.191.0.0/18", "10.191.64.0/18", "10.191.128.0/18"]
db_private_subnet_cidrs  = ["10.191.240.0/22", "10.191.244.0/22", "10.191.248.0/22"]
azs                      = ["us-west-2a", "us-west-2b", "us-west-2c"]