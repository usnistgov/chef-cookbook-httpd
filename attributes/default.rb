case node["platform_family"]
when "debian"
	default['pkgs']['webserver'] = "apache2"
	default['pkgs']['php'] = "php5"
	default['svcusers']['webserver'] = "www-data"
	default['svcgrp']['webserver'] = "www-data"
	default['web']['docroot'] = "/var/www/html"
	default['pkgs']['awstats'] = ['awstats','libnet-ip-perl', 'libnet-dns-perl', 'libgeo-ip-perl']
when "rhel", "fedora"
	default['pkgs']['webserver'] = "httpd"
	default['pkgs']['php'] = "php"
	default['svcusers']['webserver'] = "apache"
	default['svcugrp']['webserver'] = "apache"
	default['web']['docroot'] = "/var/www/html"
else
	default['svcusers']['webserver'] = "nobody"
	default['svcgrp']['webserver'] = "nobody"
	default['web']['docroot'] = "/var/www/html"
end

default['web']['admins'] = "chef"
default['web']['group'] = "chef"
