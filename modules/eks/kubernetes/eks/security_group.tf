resource "aws_security_group" "all_worker_mgmt" {
  name_prefix = "all_worker_management"
  vpc_id      = var.vpc

  ingress {
    description = "Management"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"

    cidr_blocks = [
      "172.16.0.0/12",
      "10.10.0.0/16"
    ]
  }

}