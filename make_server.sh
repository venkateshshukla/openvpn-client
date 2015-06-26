#!/bin/bash
set -e

if [ $# -ne 1 ];
then
    echo "Requires client name as an argument."
    exit 1
fi

ROOT=$PWD
RSA_ROOT="${ROOT}/easy-rsa/easyrsa3"
PKI_DIR="${ROOT}/pki"
OUT_DIR="${ROOT}/out"

CA_CRT="${PKI_DIR}/ca.crt"
DH_PEM="${PKI_DIR}/dh.pem"

EASYRSA="./easyrsa --pki-dir=$PKI_DIR"
BUILD_SERVER="build-server-full"

SERVER_KEY="${PKI_DIR}/private/${1}.key"
SERVER_CERT="${PKI_DIR}/issued/${1}.crt"
SERVER_CONF="${ROOT}/sample/server.conf"

TMP_OUT_FILE="${OUT_DIR}/${1}.conf.tmp"
OUT_FILE="${OUT_DIR}/${1}.conf"

if [ ! -d $PKI_DIR ];
then
    echo "No pki directory. Run ./init.sh first."
    exit 2
fi

if [ ! -e $DH_PEM ];
then
    echo "No pki/dh.pem file. Run ./init.sh first."
    exit 3
fi

if [ ! -e $CA_CRT ];
then
    echo "No pki/ca.crt file. Run ./init.sh first."
    exit 4
fi


pushd $RSA_ROOT
$EASYRSA $BUILD_SERVER $1
popd
