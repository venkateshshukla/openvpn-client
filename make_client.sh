#!/bin/bash

RSA_ROOT="easy-rsa/easyrsa3"
EASYRSA="./easyrsa"
INIT_PKI="init-pki"
BUILD_CA="build-ca"
GEN_DH="gen-dh"
BUILD_CLIENT="build-client-full"
BUILD_SERVER="build-server-full"

PKI_DIR="pki"
DH_PEM="$PKI_DIR/dh.pem"
CA_CRT="$PKI_DIR/ca.crt"

pushd $RSA_ROOT

if [ ! -d $PKI_DIR ];
then
    echo "no" | $EASYRSA $INIT_PKI
fi

if [ ! -f $CA_CRT ];
then
    echo "perceptron" | $EASYRSA $BUILD_CA
fi

if [ ! -f $DH_PEM ];
then
    $EASYRSA $GEN_DH
fi

popd
