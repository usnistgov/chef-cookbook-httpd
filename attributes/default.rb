case node["platform"]
when "debian", "ubuntu"
  default['packages']['webserver'] = "apache2"
when "redhat", "centos", "fedora"
  default['packages']['webserver'] = "httpd"
end