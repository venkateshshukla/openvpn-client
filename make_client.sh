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
DH_PEM="$PKI_DIR/dh.pem"

EASYRSA="./easyrsa --pki-dir=${PKI_DIR}"
BUILD_CLIENT="build-client-full"

CLIENT_KEY="${PKI_DIR}/private/${1}.key"
CLIENT_CERT="${PKI_DIR}/issued/${1}.crt"
CLIENT_CONF="${ROOT}/sample/client.conf"

TMP_OUT_FILE="${OUT_DIR}/${1}.ovpn.tmp"
OUT_FILE="${OUT_DIR}/${1}.ovpn"

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

if [ -e $OUT_FILE ];
then
    echo "Client ${OUT_FILE} is already present. Give a different name."
    exit 5
fi

pushd $RSA_ROOT
$EASYRSA $BUILD_CLIENT $1
popd

mkdir -p $OUT_DIR

cat $CLIENT_CONF > $TMP_OUT_FILE
echo "<ca>" >> $TMP_OUT_FILE
cat $CA_CRT >> $TMP_OUT_FILE
echo "</ca>" >> $TMP_OUT_FILE
echo "<cert>" >> $TMP_OUT_FILE
cat $CLIENT_CERT >> $TMP_OUT_FILE
echo "</cert>" >> $TMP_OUT_FILE
echo "<key>" >> $TMP_OUT_FILE
cat $CLIENT_KEY >> $TMP_OUT_FILE
echo "</key>" >> $TMP_OUT_FILE
cat $TMP_OUT_FILE > $OUT_FILE

rm $TMP_OUT_FILE
