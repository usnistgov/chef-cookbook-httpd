case node["platform_family"]
when "debian", "ubuntu"
  default['packages']['webserver'] = "apache2"
  default['packages']['php'] = "php5"
when "redhat", "centos", "fedora"
  default['packages']['webserver'] = "httpd"
  default['packages']['php'] = "php"
end

case node["platform"]
when "debian"
	default['svcusers']['webserver'] = "www-data"
	default['svcgrp']['webserver'] = "www-data"
when "rhel"
	default['svcusers']['webserver'] = "apache"
	default['svcugrp']['webserver'] = "apache"
else
	default['svcusers']['webserver'] = "nobody"
	default['svcgrp']['webserver'] = "nobody"
end