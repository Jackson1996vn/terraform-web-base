resource "aws_vpc" "web_base_system_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "web_base_system_subnet1" {
  vpc_id = aws_vpc.web_base_system_vpc.id
  cidr_block = "10.0.16.0/24"
  depends_on = [
    aws_vpc.web_base_system_vpc
  ]
}

resource "aws_subnet" "web_base_system_subnet2" {
  vpc_id = aws_vpc.web_base_system_vpc.id
  cidr_block = "10.0.32.0/24"
  depends_on = [
    aws_vpc.web_base_system_vpc
  ]
}

resource "aws_subnet" "web_base_system_subnet3" {
  vpc_id = aws_vpc.web_base_system_vpc.id
  cidr_block = "10.0.48.0/24"
  depends_on = [
    aws_vpc.web_base_system_vpc
  ]
}

resource "aws_security_group" "web_base_security_group" {
  name = "web_base_security_group_${terraform.workspace}"
  description = "Web base security group access for all ips in vpc"
  vpc_id = aws_vpc.web_base_system_vpc.id
  revoke_rules_on_delete = true
  lifecycle {
    create_before_destroy = true
    prevent_destroy = false
  }
  depends_on = [
    aws_vpc.web_base_system_vpc
  ]
}

resource "aws_security_group_rule" "web_base_security_group_inbound_rule" {
  from_port         = 22
  protocol          = "TCP"
  security_group_id = aws_security_group.web_base_security_group.id
  to_port           = 22
  type              = "ingress"
  cidr_blocks = [
    "10.0.0.0/16"
  ]
  depends_on = [
    aws_security_group.web_base_security_group
  ]
}

resource "aws_security_group_rule" "web_base_security_group_outbound_rule_https" {
  from_port         = 443
  protocol          = "TCP"
  security_group_id = aws_security_group.web_base_security_group.id
  to_port           = 443
  type              = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  depends_on = [
    aws_security_group.web_base_security_group
  ]
}

resource "aws_security_group_rule" "web_base_security_group_outbound_rule_http" {
  from_port         = 80
  protocol          = "TCP"
  security_group_id = aws_security_group.web_base_security_group.id
  to_port           = 80
  type              = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  depends_on = [
    aws_security_group.web_base_security_group
  ]
}

resource "aws_security_group_rule" "web_base_security_group_outbound_rule_all_icmp" {
  from_port         = -1
  protocol          = "ICMP"
  security_group_id = aws_security_group.web_base_security_group.id
  to_port           = -1
  type              = "egress"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  depends_on = [
    aws_security_group.web_base_security_group
  ]
}