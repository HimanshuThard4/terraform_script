variable "instance_type" { 
    description = "instance type for ec2" 
    default     =  "t2.micro" 
}

variable "ami_id" {
    description = "AMI for your Ec2 instance"
    default     = "ami-0e6329e222e662a52"
}

variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "key_name" { 
    description = " SSH keys to connect to ec2 instance" 
    default     =  "jenkins" 
}



