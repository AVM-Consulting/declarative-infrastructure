#!/usr/bin/env bash

# Install Terrafrom and Kops in Ubuntu 18.04

# Install Jq

sudo apt-get --yes update \
&& sudo apt-get --yes install jq \
&& sudo apt-get --yes install unzip || log "ERROR: Failed update" $?

KOPS_FLAVOR="kops-linux-amd64"
KOPS_VERSION=$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)
KOPS_URL="https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/${KOPS_FLAVOR}"

KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
KUBECTL_URL="https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"

TERRAFORM_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"

log()
{
         exit_code=$2
		 if [ -z $2 ]; then
		    exit_code=0
		 fi

		 echo "[`date '+%Y-%m-%d %T'`]:" $1
		 if [ ${exit_code} -ne "0" ]; then
		   exit ${exit_code}
		 fi
}

# Download and setup Kops

kops_setup(){

    log "INFO: Start Kops Download  -> Version : ${KOPS_VERSION} and Flavor: ${KOPS_FLAVOR}"
    curl -sLO ${KOPS_URL} || log  "ERROR: Downlaod failed"  $?
    log "INFO: Download Complete"

    #give executable permision

    chmod +x ${KOPS_FLAVOR} || log "ERROR: Cant set the executable permission" $?

    if [ -d '/usr/local/bin' ]; then

        sudo mv kops-linux-amd64 /usr/local/bin/kops
    else
        log "ERROR: /usr/local/bin Directory Not found"
    fi

    log "INFO: Kops setup done -> Version : ${KOPS_VERSION} and Flavor: ${KOPS_FLAVOR}"

    echo "======================================================================================"
    kubectl_setup

}

kubectl_setup(){

    log "INFO: Start Kubectl Download"
    curl -sLO ${KUBECTL_URL} || log  "ERROR: Downlaod failed" $?
    log "INFO: Download Complete"

    #give executable permision

    chmod +x kubectl || log "ERROR: Cant set the executable permission" $?

    if [ -d '/usr/local/bin' ]; then

        sudo mv kubectl /usr/local/bin/kubectl || log "ERROR: Moving Kubectl Failed" $?
    else

        log "ERROR: /usr/local/bin Directory Not found"
    fi

    log "INFO: Kubectl setup done ->  Version : ${KUBECTL_VERSION}"

}


#Download and Setup Terraform
terraform_setup(){

    log "INFO: Download Terraform -> Version ${TERRAFORM_VERSION}"
    curl -sLO ${TERRAFORM_URL} || log  "ERROR: Downlaod failed" $?
    log "INFO: Download Complete"

    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip || log "ERROR: Unzipping terraform_${TERRAFORM_VERSION}_linux_amd64.zip" $?

    chmod +x terraform || log "ERROR: Cant set the executable permission" $?

    if [ -d '/usr/local/bin' ]; then

        sudo mv terraform /usr/local/bin/terraform || log "ERROR: Moving Terraform Failed"  $?

    else

        log "ERROR: /usr/local/bin Directory Not found"

    fi
}

verify_install(){

    log "INFO: VERIFY KOPS"

    export PATH=${PATH}:/usr/local/bin/

    kops --help  >/dev/null 2>&1 || log "ERROR: kops verification failed" $?

    log "INFO: VERIFY KUBECTL"

    kubectl --help >/dev/null 2>&1 || log "ERROR: kubectl verification failed" $?

    log "INFO: VERIFY TERRAFORM"

    terraform --version || log "ERROR: terraform verification failed" $?

    log "INFO: Validation Successful !!!"

    rm -f terraform_0.11.13_linux_amd64.zip || log "ERROR: terraform zip Cleanup failed" $?

}


echo "======================================================================================"
kops_setup
sleep 2
echo "======================================================================================"
terraform_setup
sleep 2
echo "======================================================================================"
verify_install
echo "======================================================================================"