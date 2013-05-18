# Set vip for cinder-volume service and iscsi connection
default['cinder']['services']['volume']['myip'] = "10.5.2.200"
default['cinder']['services']['volume']['host'] = "snode"

default['cinder']['services']['volume']['register_script'] = "/usr/sbin/crm_register"
default['cinder']['services']['volume']['delete_script'] = "/usr/sbin/crm_delete"

