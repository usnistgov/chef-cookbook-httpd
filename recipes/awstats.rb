package node['packages']['awstats'] do
	action :install
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

file "/etc/apache2/sites-available/awstats" do
	action :create
	owner node['svcusers']['webserver']
	group node['svcgrp']['webserver']
	mode "0644"
end

execute "enable awstats site" do
	command "a2ensite awstats"
	creates "/etc/apache2/sites-enabled/awstats"
	action :run
	notifies :restart, "service[#{node[:packages][:webserver]}]"
end

cron "generate awstats reports and HTML" do
	hour "*"
	minute "0"
	command "/usr/lib/cgi-bin/awstats.pl -config=apache2 -update; /usr/lib/cgi-bin/awstats.pl -config=apache2 -output -staticlink > /var/www/html/awstats/index.php"
	user node['svcusers']['webserver']
end