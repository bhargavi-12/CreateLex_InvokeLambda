variable "aws_region" {
  default = "eu-central-1"
}

variable "aws_profile" {
  default= "bhargavi"
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}
