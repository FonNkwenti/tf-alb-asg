#  create target group
resource "aws_lb_target_group" "this" {
  name     = "target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.this.id
    
  health_check {
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    interval            = 30
    timeout             = 10
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}

# create alb
resource "aws_lb" "this" {
  name               = "alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.http_ingress.id]
  subnets            = [aws_subnet.private_sn_az1.id, aws_subnet.private_sn_az2.id]
    tags = {
    Name = "webserver-load-balancer"
  }
}
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

output "load_balancer_dns_name" {
  value = aws_lb.this.dns_name
}