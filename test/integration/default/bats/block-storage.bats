# vim: ft=sh:

@test "volume-api service registered with etcd" {
  curl http://127.0.0.1:4001/v1/keys/services/volume-api/members
}

@test "cinder-api is running" {
  ps aux | grep [c]inder-api
}

@test "cinder-scheduler is running" {
  ps aux | grep [c]inder-scheduler
}

@test "cinder-volume is running" {
  ps aux | grep [c]inder-volume
}

@test "cinder-api is listening on port 8776" {
  netstat -tan | grep 8776
}
