# vim: ft=sh:

@test "block-storage registered with etcd" {
  curl http://127.0.0.1:4001/v1/keys/volume-api/members
}

@test "block-storage is running" {
  netstat -tan | grep 8776
}
