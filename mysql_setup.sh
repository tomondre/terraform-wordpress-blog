#Reference: https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/hosting-wordpress.html

#Change the password and scope after @ symbol. If wordpress is hosted on the same machine as mysql, use 'localhost'. Otherwise use %
CREATE USER 'wordpress-user'@'%' IDENTIFIED BY '<STRONG_PASSWORD>';
CREATE DATABASE `wordpress-db`;
#Change the scope after @ symbol. If wordpress is hosted on the same machine as mysql, use 'localhost'. Otherwise use %
GRANT ALL PRIVILEGES ON `wordpress-db`.* TO "wordpress-user"@"%";
FLUSH PRIVILEGES;
