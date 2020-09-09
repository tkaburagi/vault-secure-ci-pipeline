FROM vault:latest
ENV VAULT_TOKEN=s.zTBJe2IgA033w7tPVmQVOYgz
ENV VAULT_ADDR=http://192.168.100.101:8200
RUN apk update
RUN apk add curl
RUN apk add jq
RUN wget https://releases.hashicorp.com/terraform/0.13.0/terraform_0.13.0_linux_amd64.zip
RUN unzip terraform_*.zip
RUN chmod +x terraform
RUN mv terraform /bin/
RUN VAULT_ADDR=$VADDR VAULT_TOKEN=$VTOKEN vault read -format=json auth/approle/role/aws-read/role-id | jq -r '.data.role_id' > /role-id