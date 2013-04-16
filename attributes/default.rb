# Set vip for cinder-volume service and iscsi connection
default['cinder']['services']['volume']['myip'] = "0.0.0.0"
default['cinder']['services']['volume']['host'] = "snode"

