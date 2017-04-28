#!/bin/bash

# create stack
echo "Deploying the stack"
openstack stack create -e hot/parameters.yaml -t hot/kuryr_heat_template.yml heat_openshift

# wait for the hook to stop stack deployment
echo "Waiting for the hook"
while true
do
    hooks=`openstack stack hook poll heat_openshift | grep worker_nodes | wc -l`
    if [ $hooks -eq 1 ]
    then
        break
    fi
    sleep 5
    echo "Pooling hooks"
done

# create trunk ports
echo "creating trunks"
openstack port list | grep heat_openshift-trunk_ports | awk '{print "openstack network trunk create --parent-port "$2 " trunk-"$2}' | sh

# clear hook to allow heat deployment to continue
echo "Continue with the stack deployment"
openstack stack hook clear --pre-create heat_openshift worker_nodes

echo "enabling dhcp at service subnet"
service_subnet_id=`openstack stack show heat_openshift | grep service_subnet -A1 | tail -1 | xargs | cut -d" " -f4`
openstack subnet set --dhcp $service_subnet_id

