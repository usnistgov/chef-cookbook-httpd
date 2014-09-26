#
# Cookbook Name:: httpd
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package node['pkgs']['webserver'] do
	action :install
end

package "acl" do
	action :install
end

service node['pkgs']['webserver'] do
	supports :status => true, :restart => true, :reload => true
	action [ :enable, :start ]
end

directory "/var/www/html" do
	owner node['svcusers']['webserver']
	group node['svcgrp']['webserver']
	mode "0755"
	action :create
end

node['web']['admins'].each do |userid|
	execute "acl" do
		command "setfacl -m \"user:#{userid}:rwx\",\"d:u:#{userid}:rwx\" /var/www/html"
		action :run
		ignore_failure true
	end
end

template "/var/www/html/index.html" do
	source "index.erb"
	owner node['svcusers']['webserver']
	group node['svcgrp']['webserver']
	mode "0644"
	notifies :restart, "service[#{node['pkgs']['webserver']}]"
end

template "/etc/apache2/envvars" do
	source "envvars.erb"
	owner node['svcusers']['webserver']
	group node['svcgrp']['webserver']
	mode "0644"
	notifies :restart, "service[#{node['pkgs']['webserver']}]"
end


template "/etc/apache2/sites-available/000-default.conf" do
	source "000-default.conf.erb"
	owner node['svcusers']['webserver']
	group node['svcgrp']['webserver']
	mode "0644"
	notifies :restart, "service[#{node['pkgs']['webserver']}]"
end

link "/etc/apache2/sites-enabled/000-default" do
  action :delete
  only_if "test -L /etc/apache2/sites-enabled/000-default"
  notifies :restart, "service[#{node[:pkgs][:webserver]}]"
end

execute "enable default site" do
	command "a2ensite 000-default.conf"
	creates "/etc/apache2/sites-enabled/000-default.conf"
	action :run
	notifies :restart, "service[#{node[:pkgs][:webserver]}]"
end