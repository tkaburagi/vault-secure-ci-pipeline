path "auth/approle/role/+/secret-id" {
  capabilities = [ "create", "update" ]
}

path "auth/token/lookup" {
  capabilities = [ "create", "update", "list", "read" ]
}

path "auth/approle/role/aws-read" {
  capabilities = [ "read" ]
}