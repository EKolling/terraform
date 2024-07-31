variable "region" {
  description = "define what region the instance will be deployed"
  default     = "us-east-1"

}

variable "name" {
  description = "name of the aplication"
  default     = "server01"
}

variable "env" {
  description = "enviroment  of the aplication"
  default     = "desenvolvimento"

}

variable "ami" {
  description = "AWS AMI to be used"
  default     = "ami-0a0e5d9c7acc336f1"
  
}

variable "instance_type" {
  description = "define the hardware configuration instance type"
  default     = "t2.micro"
}

variable "Repo" {
  description = "repository of the application"
  default     = "https://github.com/caiodelgadonew/terraform-101"
}


