#  create launch template
resource "aws_launch_template" "this" {
  name_prefix            = "tf-alb-asg"
  image_id               = "ami-0cf10cdf9fcd62d37"
  instance_type          = "t2.micro"
  key_name               = "default-ue1"
#   iam_instance_profile {
#     name = ""
#   }
  
  vpc_security_group_ids = [aws_security_group.alb_ingress.id]
#   user_data            = filebase64("${path.module}/webserver.sh")
  user_data              =  "IyEvYmluL2Jhc2gNCnN1ZG8geXVtIHVwZGF0ZSAteQ0Kc3VkbyB5dW0gaW5zdGFsbCAteSBodHRwZA0Kc3VkbyBzeXN0ZW1jdGwgc3RhcnQgaHR0cGQNCnN1ZG8gc3lzdGVtY3RsIGVuYWJsZSBodHRwZA0Kc3VkbyB1c2VybW9kIC1hIC1HIGFwYWNoZSBlYzItdXNlcg0Kc3VkbyBjaG93biAtUiBlYzItdXNlcjphcGFjaGUgL3Zhci93d3cNCnN1ZG8gY2htb2QgMjc3NSAvdmFyL3d3dw0Kc3VkbyBmaW5kIC92YXIvd3d3IC10eXBlIGQgLWV4ZWMgY2htb2QgMjc3NSB7fSBcOw0Kc3VkbyBmaW5kIC92YXIvd3d3IC10eXBlIGYgLWV4ZWMgY2htb2QgMDY2NCB7fSBcOw0Kc3VkbyBlY2hvICI8P3BocCBwaHBpbmZvKCk7ID8+IiA+IC92YXIvd3d3L2h0bWwvcGhwaW5mby5waHA="
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
  vpc_zone_identifier = [aws_subnet.private_sn_1.id, aws_subnet.private_sn_2.id]
  target_group_arns = [aws_lb_target_group.this.arn]
  health_check_type = "ELB"


}

# create autoscaling policy
resource "aws_autoscaling_policy" "cpu_scaling_policy" {
  name                   = "cpu-scaling-policy"
  policy_type            = "TargetTrackingScaling"
#   estimated_instance_warmup = var.instance_warmup_time
  autoscaling_group_name = aws_autoscaling_group.this.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 50
  }
}