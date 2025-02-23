#!/bin/bash

echo "🔄 Updating system..."
sudo apt update -y && sudo apt upgrade -y

echo "🛠️ Fixing Neo4j repository..."
wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
echo 'deb https://debian.neo4j.com stable latest' | sudo tee /etc/apt/sources.list.d/neo4j.list
sudo apt-get update

echo "🗑️ Removing any old versions of Neo4j..."
sudo apt remove --purge -y neo4j
sudo apt autoremove -y

echo "📦 Installing Neo4j..."
sudo apt install -y neo4j openjdk-21-jre-headless cypher-shell

echo "🚀 Enabling and starting Neo4j..."
sudo systemctl enable neo4j
sudo systemctl start neo4j

echo "🔑 Setting Neo4j password for BloodHound..."
cypher-shell -u neo4j -p neo4j "ALTER USER neo4j SET PASSWORD 'bloodhound'" || echo "Password change failed, might need to change manually."

echo "⬇️ Downloading BloodHound Community Edition..."
wget -O BloodHound-linux-x64.zip https://github.com/SpecterOps/BloodHound-Legacy/releases/latest/download/BloodHound-linux-x64.zip

echo "📂 Extracting BloodHound..."
unzip BloodHound-linux-x64.zip -d bloodhound-ce

echo "📌 Setting executable permissions..."
chmod +x bloodhound-ce/BloodHound-linux-x64/BloodHound

echo "🦊 Launching BloodHound..."
cd bloodhound-ce/BloodHound-linux-x64
./BloodHound
