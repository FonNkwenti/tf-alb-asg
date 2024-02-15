#  create launch template
resource "aws_launch_template" "this" {
  name_prefix            = "tf-alb-asg"
  image_id               = "ami-0323d48d3a525fd18"
  instance_type          = "t2.micro"
  key_name               = "default-eu1"

  vpc_security_group_ids = [aws_security_group.webserver_sg.id]
  user_data = filebase64("${path.module}/webserver.sh")
  monitoring {
    enabled = true
  }
    tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "tf-alb-asg"
    }
  }

}

resource "aws_autoscaling_group" "this" {
  name              = "asg"
  launch_template {
    id              = aws_launch_template.this.id
    version         = "$Latest"
  }
  min_size          = 2
  max_size          = 4
  desired_capacity  = 2
  vpc_zone_identifier = [aws_subnet.private_sn_az1.id, aws_subnet.private_sn_az2.id]
  target_group_arns = [aws_lb_target_group.this.arn]
  health_check_type = "ELB"


}

# create autoscaling policy
resource "aws_autoscaling_policy" "cpu_scaling_policy" {
  name                   = "cpu-scaling-policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.this.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50
  }
}