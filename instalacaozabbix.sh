#!/bin/bash

# Atualizar lista de pacotes
sudo apt-get update

# Instalar pacotes necessários
sudo apt-get install -y wget apache2 mysql-server php libapache2-mod-php php-mysql

# Baixar o pacote do Zabbix
wget https://repo.zabbix.com/zabbix/4.4/debian/pool/main/z/zabbix-release/zabbix-release_4.4-1+buster_all.deb

# Instalar o pacote Zabbix
sudo dpkg -i zabbix-release_4.4-1+buster_all.deb

# Atualizar lista de pacotes
sudo apt-get update

# Instalar o Zabbix Server, Frontend e Agente
sudo apt-get install -y zabbix-server-mysql zabbix-frontend-php zabbix-agent

# Configurar o banco de dados do Zabbix
sudo mysql -uroot -p -e "create database zabbix character set utf8 collate utf8_bin;"
sudo mysql -uroot -p -e "grant all privileges on zabbix.* to zabbix@localhost identified by 'zabbix';"
zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -uzabbix -pzabbix zabbix

# Configurar o PHP para o Zabbix
sudo sed -i 's/# php_value date.timezone Europe\/Riga/php_value date.timezone America\/Sao_Paulo/' /etc/zabbix/apache.conf
sudo a2enconf zabbix
sudo systemctl restart apache2

# Configurar o Zabbix Server
sudo sed -i "s/# DBPassword=.*/DBPassword=zabbix/" /etc/zabbix/zabbix_server.conf
sudo systemctl restart zabbix-server

# Verificar o estado dos serviços do Zabbix
sudo systemctl status zabbix-server
sudo systemctl status zabbix-agent