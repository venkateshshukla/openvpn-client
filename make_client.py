#!/usr/bin/env python

import os
import subprocess

class cd:
    """Context manager for changing the current working directory"""
    def __init__(self, newPath):
        self.newPath = os.path.expanduser(newPath)

    def __enter__(self):
        self.savedPath = os.getcwd()
        os.chdir(self.newPath)

    def __exit__(self, etype, value, traceback):
        os.chdir(self.savedPath)

def init_pki(rsa_root):
    """Change directory to rsa_root and execute ./easyrsa init-pki"""
    if not os.path.isdir(rsa_root):
        return False
    imp_files = ["easyrsa", "openssl-1.0.cnf"]
    for p in imp_files:
        if not os.path.isfile(os.path.join(rsa_root, p)):
            return False
    easyrsa = "./easyrsa"
    init_pki = "init-pki"
    with cd(rsa_root):
        print easyrsa, init_pki
        proc = subprocess.Popen([easyrsa, init_pki], stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        (out, err) = proc.communicate(None)
        if proc.returncode == 0:
            print out
            return True
        else:
            print out
            print err
            return False

def build_ca(rsa_root):
    """Change directory to rsa_root and execute ./easyrsa build-ca"""
    if not os.path.isdir(rsa_root):
        return False

    imp_files = ["easyrsa", "openssl-1.0.cnf"]
    for f in imp_files:
        if not os.path.isfile(os.path.join(rsa_root, f)):
            return False

    imp_dirs = ["pki"]
    for d in imp_dirs:
        if not os.path.isdir(os.path.join(rsa_root, d)):
            return False

    easyrsa = "./easyrsa"
    build_ca = "build-ca"
    org_name = "perceptron"
    with cd(rsa_root):
        print easyrsa, build_ca
        proc = subprocess.Popen([easyrsa, build_ca], stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        (out, err) = proc.communicate(org_name)

        if proc.returncode == 0:
            print out
            return True
        else:
            print out
            print err
            return False

def gen_dh(rsa_root):
    """Change directory to rsa_root and execute ./easyrsa gen-dh"""
    if not os.path.isdir(rsa_root):
             return False

    imp_files = ["easyrsa", "openssl-1.0.cnf"]
    for f in imp_files:
        if not os.path.isfile(os.path.join(rsa_root, f)):
            return False

    imp_dirs = ["pki"]
    for d in imp_dirs:
        if not os.path.isdir(os.path.join(rsa_root, d)):
            return False

    dh_path = "pki/dh.pem"
    if os.path.isfile(os.path.join(rsa_root, dh_path)):
        return False

    easyrsa = "./easyrsa"
    gen_dh = "gen-dh"
    with cd(rsa_root):
        print easyrsa, gen-dh
        proc = subprocess.Popen([easyrsa, gen_dh], stdin=subprocess.PIPE,
                stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        (out, err) = proc.communicate(None)

        if proc.returncode == 0:
            print out
            return True
        else:
            print out
            print err
            return False


home_dir = os.path.dirname(os.path.realpath(__file__))
rsa_dir = home_dir + "/easy-rsa/easyrsa3"

print "="*80
print init_pki(rsa_dir)
print "="*80

print "="*80
print build_ca(rsa_dir)
print "="*80

print "="*80
print gen_dh(rsa_dir)
print "="*80
