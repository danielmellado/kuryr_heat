Kuryr Heat Templates
====================

This set of scripts and Heat templates are useful for deploying Pod-in-VM
scenarios. It handles the creation of master and worker nodes that can use trunk
ports.

How to run
~~~~~~~~~~

In order to run it, make sure that you have sourced your openrc file, edited
hot/parameters.yml and then launch with:

./kuryr_heat stack

To delete the deployment

./kuryr_heat unstack
