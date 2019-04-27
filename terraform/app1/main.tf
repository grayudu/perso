provider "aws" {
  region  = "${var.region}"
  profile = "grayudu"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.default.id}"
}

data "aws_security_group" "default" {
  vpc_id = "${data.aws_vpc.default.id}"
  name   = "default"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

module "sg" {
  source = "../modules/sg"

  name        = "${var.name}"
  desc        = "${var.desc}"
  aws_vpc_id  = "${data.aws_vpc.default.id}"
  cidr_blocks = ["0.0.0.0/0"]
}

######
# Launch configuration and autoscaling group
######
module "ganga" {
  source = "../modules/asg"

  name = "ganga-with-ec2"

  # Launch configuration
  #
  # launch_configuration = "my-existing-launch-configuration" # Use the existing launch configuration
  # create_lc = false # disables creation of launch configuration
  lc_name = "ganga-lc"

  image_id                     = "${data.aws_ami.amazon_linux.id}"
  instance_type                = "t2.micro"
  security_groups              = ["${module.sg.this_sg_id}"]
  load_balancers               = ["${module.ganga-elb.this_elb_id}"]
  associate_public_ip_address  = true
  recreate_asg_when_lc_changes = true
  key_name                     = "${var.key_name}"

  user_data = <<-EOF
              #!/bin/bash
              yum install -y docker
              service docker start
              docker run -d -p 80:80 nginx:latest
              EOF

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "8"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size           = "10"
      volume_type           = "gp2"
      delete_on_termination = true
    },
  ]

  # Auto scaling group
  asg_name                  = "ganga-asg"
  vpc_zone_identifier       = ["${data.aws_subnet_ids.all.ids}"]
  health_check_type         = "EC2"
  min_size                  = "${var.min_size}"
  max_size                  = "${var.max_size}"
  desired_capacity          = "${var.desired_capacity}"
  wait_for_capacity_timeout = 0

  tags = [
    {
      key                 = "Environment"
      value               = "${var.env}"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "${var.appName}"
      propagate_at_launch = true
    },
  ]

  tags_as_map = {
    extra_tag1 = "extra_value1"
    extra_tag2 = "extra_value2"
  }
}

module "ganga-elb" {
  source          = "../modules/elb"
  name            = "ganga-elb"
  security_groups = ["${module.sg.this_sg_id}"]
  subnets         = ["${data.aws_subnet_ids.all.ids}"]
  internal        = "false"

  listener = "${var.listener}"

  health_check = "${var.health_check}"
}

# resource "aws_autoscaling_attachment" "asg_attachment_bar" {
#   autoscaling_group_name = "${module.ganga}"
#   elb                    = "${module.ganga-elb}"
# }

