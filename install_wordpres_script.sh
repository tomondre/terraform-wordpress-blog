#Reference: https://medium.com/@babettelandmesser/install-wordpress-in-aws-ec2-instance-ada5b2db06d2
sudo yum update -y
sudo amazon-linux-extras install -y php7.4
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
#Depending on the user, change the last argument
sudo usermod -a -G apache ssm-user
sudo chown -R ssm-user:apache /var/www
#
sudo chmod 2775 /var/www && find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
cd ~
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
sudo mv wp-cli.phar /usr/local/bin/wp
cd /var/www/html/
wp core download