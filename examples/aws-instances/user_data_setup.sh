#!/bin/bash

# user_data can be accessed thus, from within the instance:
#     curl -sL http://169.254.169.254/latest/user-data
# user_data can be deleted thus, from outside the instance:
#     aws ec2 modify-instance-attribute --instance-id <your-instance-id> --user-data ":"

#### echo "<html ><head><title>Server is UP</title></head>  <body><h1>Welcome - Server is UP</h1></body> </html>" > index.html
#### nohup busybox httpd -f -p "${var.webserver_port}" &

exec > /tmp/user_data.op 2>&1

sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl python3-pip python3-venv tmux tmate

set -x

[ -d /home/student ] && deluser student --remove-home
[ -d /home/student ] && rm -rf /home/student

#sed -i.bak -e 's/^%sudo.*/%sudo ALL=(ALL:ALL) ALL:NOPASSWD/' /etc/sudoers
sed -i.bak -e 's/^%sudo.*/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/' /etc/sudoers

adduser -gecos 'User student' student --disabled-password 2>&1 | tee /tmp/adduser.op

#mkdir /home/student/.ssh
cp -a /home/ubuntu/.ssh/ /home/student/.ssh/

# Substiture YOUR public key here:
cat >> /home/student/.ssh/authorized_keys <<SSH_EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC70DnMokEbNZPjzOgLxUYWjSJeNktc5XjU6RTY0KRv2V7y22xSp/s+4qQju+HUZym2KrmVofIZYiTvZLYduTAN3Yg2x81v0GRpgAnu7kxcQA+uBVonpURO4AFu/NW9Z1OPYdz2UjyrU3BXYD2F/+N+JI74t2o5QUWPsy2jWqZap06y9C1p/I2A4pEHxt0oNhBBPCmnOu2d8fBG6WKN1qawvanpaP5aJl3H+VLrKBwsU3C+X8eA+SPYYSDqrAM1MVOdgfUT6tty4w9khhgdNSXgbXaHLFB752J1nj+/WmYrZRfIfBi/ssbYIbt6H5jk3wORmNtfMshoK+2aNGG1OiUJ mjb@carbon
SSH_EOF

chown -R student:student /home/student/

usermod -aG sudo student
ls -al /home/student/.ssh/


