# Secure CI Pipeline by Vault
![](concourse.png)

**Some resources are fake for the demo :)**

## Setup

Next is ...

1. Replacing `tkaburagi/vault-role-id` to your image name for each file.
2. Replacing `tkaburagi:tkaburagi` to your `username:password` in `docker-compose.yml`.
3. Replacing `CONCOURSE_WORK_DIR` and `CONCOURSE_EXTERNAL_URL` to your local environemts in `docker-compose.yml`.
4. Replacing `VTOKEN` and `VADDR` to your environments in `Dockerfile`.
5. Replcaing `https://github.com/tkaburagi/vault-secure-ci-pipeline.git` to your cloned repo in `pipeline.yml`.

* Vault AWS Setting
```shell script
$ vault secrets enable aws
$ vault write aws/config/root \
    access_key=*** \
    secret_key=*** \
    region=ap-northeast-1
$ vault write aws/config/lease lease=10m lease_max=10m
$ vault write aws/roles/tf-handson-role \  
    credential_type=iam_user \
    policy_document=-<<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Sid": "VisualEditor0",
                "Effect": "Allow",
                "Action": [
                    "rds:*",
                    "ec2:*",
                    "elasticloadbalancing:*"
                ],
                "Resource": "*"
            }
        ]
    }
    EOF
```

* Vault AppRole Setting
```shell script
$ vault auth enable approle
$ vault write auth/approle/role/aws-read \
    policies="aws" \
    secret_id_num_uses=1 \
    secret_id_ttl="600" \
    token_num_uses=3 \
    token_ttl="600" \
    token_max_ttl="1200"
$ vault read -format=json /auth/approle/role/aws-read/role-id | jq -r '.data.role_id'
```

* Vault ACL Setting
```shell script
$ vault policy write kv-concourse kv-concourse.hcl
$ vault policy write pull-secret-id pull-secret-id.hcl
$ vault policy write aws aws.hcl
$ vault policy write revoke-aws revoke-aws.hcl
$ vault token create -policy kv-concourse -no-default-policy
$ vault token create -policy pull-secret-id -no-default-policy
$ vault token create -policy revoke-aws -no-default-policy
```

* Vault EGP Setting (Enterprise Only)
```shell script
$ vault write sys/policies/egp/validate-cidr-ci-demo \
    policy=$(base64 validate-cidr.sentinel) \
    enforcement_level="hard-mandatory" \
    paths='sys/internal/ui/mounts/kv/aws-keys-concourse','sys/internal/ui/mounts/kv/secret-id-concourse', 'auth/approle/role/aws-read/secret-id'
$ vault read sys/policies/egp/validate-cidr-ci-demo
```

* Concourse Setting
```shell script
$ docker build -t <<IMAGE_NAME>> .
$ cat << EOF > ci/vars.yml
    vault_addr: http://192.168.100.101:8200
    vault_kv_token: <<TOKEN-1>>
    vault_init_token: <<TOKEN-2>>
    vault_revoke_token: <<TOKEN-3>>
    EOF
```

Then create the pipeline!

* Start Concourse
```shell script
$ docker-compose up
$ fly -t localhost login -c http://127.0.0.1
$ fly -t localhost set-pipeline -p snapshots-demo -c ci/pipeline.yml ci/vars.yml
$ fly -t localhost unpause-pipeline --pipeline snapshots-demo
```

## To-Do
* ~~use_limit & TTL for each secret~~
* ~~ACL & Sentinel for KV~~
* ~~Dockerfile~~
* ~~Replace Role-id for the Docker image~~
* ~~Revoke the key~~
* ~~E2E test~~
* ~~Webhook~~

## Slide & Demo
* [Slide](https://docs.google.com/presentation/d/1oWaj9dpbG3zbwmtW-_DMvyZuR2flju-DtrNNG775jYA/edit?usp=sharing)
* [Demo]()