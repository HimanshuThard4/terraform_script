variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ExampleAppServerInstance"
}

variable "key_name" { 
    description = " SSH keys to connect to ec2 instance" 
    default     =  "jenkins" 
}

