path "auth/approle/role/+/secret-id" {
  capabilities = [ "create", "update" ]
}

path "auth/token/lookup" {
  capabilities = [ "create", "update", "list", "read" ]
}

path "kv/secret-id-concourse" {
  capabilities = ["create", "update", "read", "list"]
}
