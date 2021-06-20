################################################################################################
####                              Fetches the Public Subnet                          ###########
################################################################################################

data "aws_subnet" "subnet" {
  vpc_id      = "${var.vpc_id}"
  tags = {
    Network = "Public-*"
    Name = "Public"
  }
}
output "subnet" {
  value = data.aws_subnet.subnet
}


###############################################################################################
####    Creates Security Group for the MediaWiki instance with ingress and egress   ###########
###############################################################################################
resource "aws_security_group" "security_group" {
  name        = lower("${var.application_name}-${var.application_environment}-rds-sg-test")
  description = lower("${var.application_name}-${var.application_environment}-rds")
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags= {
    Name = "mediawiki-sg1"
    Project = "mediawiki"
  }
}

###############################################################################################
######             Fetches the Latest CENTOS AMI from Amazon Market Place           ###########
###############################################################################################

data "aws_ami" "centos" {
owners      = ["aws-marketplace"]
most_recent = true

  filter {
      name   = "name"
      values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
      name   = "architecture"
      values = ["x86_64"]
  }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
  }
}


###############################################################################################
######       Creates the MediaWiki Instance with given instance type and keypair    ###########
###############################################################################################


resource "aws_instance" "mediwiki" {
  ami = "${data.aws_ami.centos.id}"
  instance_type = "${var.ec2_instance_type}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = ["${aws_security_group.security_group.id}"]
  subnet_id = "${data.aws_subnet.subnet.id}"

  tags={
    Name = "mediawiki-instance1"
    Project = "mediawiki"
  }
}
