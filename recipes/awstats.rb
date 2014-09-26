node.default['pkgs']['awstats'].each do |pkg|
	package pkg do
		action :install
	end
end

template "/etc/awstats/awstats.conf" do
	source "awstats.conf.erb"
	owner "root"
	group "root"
	mode "0644"
end

directory "/var/www/html/awstats" do
	owner node['svcusers']['webserver']
	group node['svcgrp']['webserver']
	mode "0755"
	action :create
end

link "/var/www/html/awstats/icon" do
	to "/usr/share/awstats/icon"
end

cookbook_file "/etc/apache2/sites-available/awstats.conf" do
	action :create
	owner node['svcusers']['webserver']
	group node['svcgrp']['webserver']
	mode "0644"
end

directory File.dirname(node['awstats']['LogFile']) do
	owner node['svcusers']['webserver']
	group node['svcgrp']['webserver']
	mode "0755"
	action :create
end

file node['awstats']['LogFile'] do
	action :create
	owner node['svcusers']['webserver']
	group node['svcgrp']['webserver']
	mode "0644"
end

execute "enable cgi mod" do
	command "a2enmod cgi"
	creates "/etc/apache2/mods-enabled/cgi.load"
	action :run
	notifies :restart, "service[#{node[:pkgs][:webserver]}]"
end

execute "enable awstats site" do
	command "a2ensite awstats.conf"
	creates "/etc/apache2/sites-enabled/awstats.conf"
	action :run
	notifies :restart, "service[#{node[:pkgs][:webserver]}]"
end

directory "/usr/lib/cgi-bin" do
	owner node['svcusers']['webserver']
	group node['svcgrp']['webserver']
	mode "0755"
	action :create
end

if node['svcusers']['webserver'] == 'www-data'
	user node['svcusers']['webserver'] do
	  supports :manage_home => true
	  gid node.default['users']['gid']
	  home "/var/www"
	  shell "/bin/bash"
	  password node.default['users']['password']
	end
end	

execute "initial awstats report generation" do
	command "/usr/lib/cgi-bin/awstats.pl -config=apache2 -update; /usr/lib/cgi-bin/awstats.pl -config=apache2 -output -staticlink > /usr/lib/cgi-bin/index.php"
	creates "/usr/lib/cgi-bin/index.php"
	action :run
	user node['svcusers']['webserver']
end

cron "set cron to generate awstats reports and HTML" do
	hour "*"
	minute "0"
	command "/usr/lib/cgi-bin/awstats.pl -config=apache2 -update; /usr/lib/cgi-bin/awstats.pl -config=apache2 -output -staticlink > /usr/lib/cgi-bin/index.php"
	user node['svcusers']['webserver']
end