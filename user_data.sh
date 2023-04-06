#!/bin/bash
apt-get -y update
cat > /tmp/subscript.sh << EOF
# START ec2-user USERSPACE
echo "Setting up NodeJS Environment"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash
echo 'export NVM_DIR="/home/ec2-user/.nvm"' >> /home/ec2-user/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> /home/ec2-user/.bashrc
# Dot source the files to ensure that variables are available within the current shell
. /home/ec2-user/.nvm/nvm.sh
. /home/ec2-user/.profile
. /home/ec2-user/.bashrc
# Install NVM, NPM, Node.JS & Grunt
nvm install node
sudo yum install git -y
git clone https://github.com/sumant-mishra/node-app.git
cd node-app
npm install
node index.js
EOF

chown ec2-user:ec2-user /tmp/subscript.sh && chmod a+x /tmp/subscript.sh
sleep 1; su - ec2-user -c "/tmp/subscript.sh"