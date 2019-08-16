variable "aws_region" { default = "ap-south-1" } 
provider "aws" {
    region = "${var.aws_region}"
    access_key = ""
    secret_key = ""
}
variable "ami" {default = ""}
variable "key_name" {default = ""}
data "aws_availability_zones" "all" {}
resource "aws_elb" "elb-test" {
  name = "terraform-asg-example"
  security_groups = [""]
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    interval = 30
    target = "HTTP:80/"
  }
  listener {
    lb_port = 80
    lb_protocol = "http"
    instance_port = "80"
    instance_protocol = "http"
  }
}
resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.launch1.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  min_size = 1
  max_size = 1
  load_balancers = ["${aws_elb.elb-test.name}"]
  health_check_type = "ELB"
  tag {
    key = "Name"
    value = "terraform-asg-example"
    propagate_at_launch = true
  }
}
resource "aws_launch_configuration" "launch1" {
  image_id               = "${var.ami}"
  instance_type          = "t2.micro"
  security_groups        = ["sg-0387a96a"]
  key_name               = "${var.key_name}"
  provisioner "file" {
    source      = "~/hptk/2.sh"
    destination = "~/2.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/2.sh",
      ".~/2.sh",
    ]
  }
  lifecycle {
    create_before_destroy = true
  }
}

