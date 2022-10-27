variable "vpc_id" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "private_domain_key" {
  type = string
}

variable "certificate_body" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}