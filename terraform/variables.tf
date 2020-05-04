
variable region {
  description = "Region"
  default     = "us-east-1"
}

variable "project" {
  description = "Project name"
  default     = "web"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDRs"
  type        = "list"
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "sg_source" {
  default     = ["0.0.0.0/0"]
  description = "Allow incoming IP range"
  type        = "list"
}

variable "port_number" {
  description = "Ports to allow access"
  default     = ["22", "80"]
  type        = "list"
}

variable "instances" {
  default     = 1
  description = "How many instances"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.micro"
}

variable "ssh_key" {
  default     = "~/.ssh/id_rsa.pub"
  description = "SSH key to access instance"
}
