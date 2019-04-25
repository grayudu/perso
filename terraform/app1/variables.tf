#Security Group
variable "name" {
  type        = "string"
  description = "describe your variable"
  default     = "ganga-sg"
}

variable "desc" {
  type        = "string"
  description = "describe your variable"
  default     = "app1 security group"
}

# variable "from_port" {
#   description = "from_port"
#   default     = 80
# }

# variable "to_port" {
#   description = "describe from_port"
#   default     = 80
# }

# variable "protocol" {
#   description = "describe protocol"
#   default     = "tcp"
# }

# variable "cidr_blocks" {
#   description = "describe cidr_blocks"
#   default     = ["0.0.0.0/0"]
# }

# ELB
variable "listener" {
  description = "ELB litener details"

  default = [{
    instance_port = 80

    instance_protocol = "http"

    lb_port = 80

    lb_protocol = "http"
  },
    {
      instance_port = 8090

      instance_protocol = "http"

      lb_port = 8090

      lb_protocol = "http"
    },
  ]
}

variable "health_check" {
  description = "health_check details for ELB"

  default = [
    {
      target              = "TCP:80"
      interval            = 30
      healthy_threshold   = 2
      unhealthy_threshold = 2
      timeout             = 5
    },
  ]
}
