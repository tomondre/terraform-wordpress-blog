resource "random_password" "db_password" {
  length = 10
}

resource "aws_security_group" "db_security_group" {
  name = "db-security-group"
  ingress {
    from_port = 3306
    protocol  = "TCP"
    to_port   = 3306
    security_groups = [aws_security_group.asg_security_group.id]
  }
  vpc_id = var.vpc_id
}

resource "aws_db_instance" "rds" {
  instance_class = "db.t3.micro"
  engine = "mysql"
  engine_version = "8.0.28"
  password = random_password.db_password.result
  username = "tomondre"
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  allocated_storage = 200
}