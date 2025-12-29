variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "subnet_id" {
  type = string
}

variable "environment" {
  type = string
}

variable "iam_instance_profile" {
  description = "IAM Instance Profile to attach to EC2"
  type        = string
  default     = null
}
