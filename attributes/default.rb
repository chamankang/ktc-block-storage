# Set vip for cinder-volume service and iscsi connection
default['cinder']['services']['volume']['myip'] = ""
default['cinder']['services']['volume']['host'] = "snode"

default['cinder']['services']['volume']['crm_cmd'] = "/usr/sbin/crm"

