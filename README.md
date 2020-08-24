# Secure CI Pipeline by Vault
![](concourse.png)

**Some resources are fake for the demo :)**

## Setup
* vault write auth/approle/role/aws-read \
policies="aws" \
secret_id_num_uses=1 \
secret_id_ttl="10" \
token_num_uses=1 \
token_ttl="10" \
token_max_ttl="30"

## To-Do
* ~~use_limit & TTL for each secret~~
* ACL & Sentinel for KV

