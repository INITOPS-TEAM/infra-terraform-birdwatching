#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y ca-certificates curl gnupg

sudo install -m 0755 -d /etc/apt/keyrings

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | \
  sudo gpg --dearmor -o /etc/apt/keyrings/jenkins.gpg

sudo chmod a+r /etc/apt/keyrings/jenkins.gpg

echo "deb [signed-by=/etc/apt/keyrings/jenkins.gpg] https://pkg.jenkins.io/debian-stable binary/" | \
  sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install -y openjdk-17-jre jenkins

sudo systemctl enable jenkins
sudo systemctl start jenkins
