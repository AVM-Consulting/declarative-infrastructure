#!/usr/bin/env bash

# Install Packer and Ansible in Ubuntu 18.04

# Install Jq
sudo apt-add-repository --yes ppa:ansible/ansible \
&& sudo apt-get --yes update \
&& sudo apt-get --yes install jq software-properties-common \
&& sudo apt-get --yes install unzip  ansible || log "ERROR: Failed update" $?

PACKER_VERSION="1.4.0"
PACKER_URL="https://releases.hashicorp.com/packer/${PACKER_VERSION}/packer_${PACKER_VERSION}_linux_amd64.zip"


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

packer_setup(){
    echo "======================================START PACKER SETUP ================================================"
    log "INFO: Start Packer Download  -> Version : ${PACKER_VERSION} and Flavor: linux_amd64"
    curl -sLO ${PACKER_URL} || log  "ERROR: Downlaod failed"  $?
    log "INFO: Download Complete"

    log "INFO: Unzip the Packer binary"
    unzip packer_${PACKER_VERSION}_linux_amd64.zip || log  "ERROR: Unzip of packer failed"  $?
    log "INFO: Unzip Complete"

    #give executable permision

    chmod +x packer || log "ERROR: Cant set the executable permission" $?

    if [ -d '/usr/local/bin' ]; then

        sudo mv packer /usr/local/bin/packer
    else
        log "ERROR: /usr/local/bin Directory Not found"
    fi

    log "INFO: Packer setup done -> Version : ${PACKER_VERSION} and Flavor: linux_amd64"

    echo "========================================END PACKER SETUP================================================"

}




verify_install(){

    log "INFO: VERIFY PACKER"

    export PATH=${PATH}:/usr/local/bin/

    packer --version || log "ERROR: Packer verification failed" $?

    log "INFO: VERIFY ANSIBLE"

    ansible --version || log "ERROR: ansible verification failed" $?

    log "INFO: Validation Successful !!!"

    rm -f packer_${PACKER_VERSION}_linux_amd64.zip || log "ERROR: Packer zip Cleanup failed" $?

}


packer_setup
sleep 2

echo "==================================Verify START===================================================="
verify_install
echo "==================================Verify END======================================================"