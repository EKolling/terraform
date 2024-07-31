variable "ami" {
  description = "AWS AMI to be used"
  default     = "ami-04a81a99f5ec58529"
  type        = string
}

variable "instance_type" {
  description = "define the hardware configuration instance type"
  default     = "t2.micro"
  type        = string
}

variable "ebs_block_device" {
  description = "SSD de 1 GB"
  default     = {
    device_name = "/dev/sda1"
    volume_type = "gp2"
    volume_size = 10
    encrypted   = true
  }
  type = map(any)
}

variable "name" {
  type    = string
  default = "server1"
}

variable "name2" {
  type    = string
  default = "server2"
}