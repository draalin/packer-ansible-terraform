#!/bin/bash
sudo apt-get remove -y --purge ansible
sudo apt-add-repository --remove ppa:ansible/ansible
sudo apt-get autoremove -y
sudo apt-get update -y