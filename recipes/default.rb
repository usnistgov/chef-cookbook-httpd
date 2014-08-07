#
# Cookbook Name:: httpd
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package node[:packages][:webserver] do
	action :install
end

template "/var/www/index.html" do
	source "index.erb"
	owner "root"
	group "root"
	mode "0644"
	notifies :restart, "service[apache2]"
end

service node[:packages][:webserver] do
	supports :status => true, :restart => true, :reload => true
	action [ :enable, :start ]
end
