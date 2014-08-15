case node["platform_family"]
when "debian"
	default['packages']['webserver'] = "apache2"
	default['packages']['php'] = "php5"
	default['svcusers']['webserver'] = "www-data"
	default['svcgrp']['webserver'] = "www-data"
	default['web']['docroot'] = "/var/www/html"
when "rhel", "fedora"
	default['packages']['webserver'] = "httpd"
	default['packages']['php'] = "php"
	default['svcusers']['webserver'] = "apache"
	default['svcugrp']['webserver'] = "apache"
	default['web']['docroot'] = "/var/www/html"
else
	default['svcusers']['webserver'] = "nobody"
	default['svcgrp']['webserver'] = "nobody"
	default['web']['docroot'] = "/var/www/html"
end

default['web']['admins'] = "nobody"
default['web']['group'] = "nobody"