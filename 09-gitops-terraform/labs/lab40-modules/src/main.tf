module "simple_vpc" {
    source = "../../lab30-declarative-solution/src"
    prefix = "mymodulevpc"
    vpc-cidr = "10.1.0.0/16"
}
