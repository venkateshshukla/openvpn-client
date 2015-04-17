#!/bin/bash
set -e

ROOT=$PWD
RSA_ROOT="$ROOT/easy-rsa/easyrsa3"

PKI_DIR="$ROOT/pki"
DH_PEM="$PKI_DIR/dh.pem"
CA_CRT="$PKI_DIR/ca.crt"

EASYRSA="./easyrsa --pki-dir=$PKI_DIR"
INIT_PKI="init-pki"
BUILD_CA="build-ca"
GEN_DH="gen-dh"

COMMON_NAME="perceptron"

pushd $RSA_ROOT

if [ ! -d $PKI_DIR ];
then
    echo "no" | $EASYRSA $INIT_PKI
fi

if [ ! -f $CA_CRT ];
then
    echo $COMMON_NAME | $EASYRSA $BUILD_CA
fi

if [ ! -f $DH_PEM ];
then
    $EASYRSA $GEN_DH
fi

popd
