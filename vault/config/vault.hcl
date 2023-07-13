ui = true

storage "file" {
  path = "/vault/file"
}

listener "tcp" {
  address = "localhost:8200"
  tls_disable = true
}

listener "tcp" {
  address = "10.0.0.2:8200"
  tls_disable = true
}
