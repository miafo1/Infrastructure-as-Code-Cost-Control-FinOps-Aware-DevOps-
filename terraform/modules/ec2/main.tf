data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["033677994240"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
  }

  user_data = <<-EOF
              #!/bin/bash
              echo "FinOps aware instance started"
              EOF

  # FinOps Check
  lifecycle {
    precondition {
      condition     = contains(["t3.micro", "t2.micro"], var.instance_type)
      error_message = "ERROR: Only t2.micro or t3.micro are allowed to maintain Free Tier eligibility."
    }
  }

  tags = {
    Name = "${var.environment}-app-server"
  }
}
