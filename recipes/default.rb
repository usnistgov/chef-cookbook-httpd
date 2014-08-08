#
# Cookbook Name:: httpd
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node[:packages].each do |name, pkg|
	package node[:packages][name] do
		action :install
	end
end

package "acl" do
	action :install
end

service node[:packages][:webserver] do
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
	notifies :restart, "service[#{node[:packages][:webserver]}]"
end
