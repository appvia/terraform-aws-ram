
provider "aws" {
  region = "eu-west-2"
}

provider "aws" {
  alias  = "accepter"
  region = "eu-west-2"
  assume_role {
    role_arn = "arn:aws:iam::101987654321:role/cross-account-role"
  }
}
