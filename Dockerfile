FROM mozilla/sops
ARG TF_VERSION=0.12.20

RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
	  yq \
	  jq \
	  vim \
	  unzip \
	  expect \
	  gnupg-agent \
    curl \
    gnupg \
    lsb-release && \
	  wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${TF_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin && \
    rm terraform_${TF_VERSION}_linux_amd64.zip && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null && \
    AZ_REPO=$(lsb_release -cs) && \
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && \
    apt-get install -y azure-cli && \
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.16.1/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl && \
    ./get_helm.sh && \    
    /usr/local/bin/helm plugin install https://github.com/chartmuseum/helm-push.git && \
    wget https://releases.hashicorp.com/vault/1.4.1/vault_1.4.1_linux_amd64.zip && \
    unzip -d /bin vault_1.4.1_linux_amd64.zip && \
    apt-get clean && \
    apt-get autoremove

ENTRYPOINT ["bash"]
