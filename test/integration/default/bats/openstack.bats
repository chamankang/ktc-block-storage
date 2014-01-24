# vim: ft=sh:

@test "create test volume" {
  ip=`ifconfig eth0 | grep "inet addr" | sed 's/ *inet addr:\([0-9]*.[0-9]*.[0-9]*.[0-9]*\).*/\1/'`
  auth="--os-username=admin --os-password=admin --os-tenant-name=admin"
  url="--os-auth-url=http://${ip}:35357/v2.0"
  cinder $auth $url create --display_name test 1
}

@test "show test volume" {
  ip=`ifconfig eth0 | grep "inet addr" | sed 's/ *inet addr:\([0-9]*.[0-9]*.[0-9]*.[0-9]*\).*/\1/'`
  auth="--os-username=admin --os-password=admin --os-tenant-name=admin"
  url="--os-auth-url=http://${ip}:35357/v2.0"
  cinder $auth $url show test
}
