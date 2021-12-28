# Vic Viper

## Overview
* coriky project
* mongodb on k8s (3 replicas) using nfs volume
* NATS for adding new files
* BE API not exposed
* FE only exposed to viper proxy

### K8s cluster
* nodes have to have visible ip on internal net (unsing vagrant bridge)
* networking
* network policies
* auth / rbac
* volumes (nfs server)
* ingress via ext
* ingress via node port + ext rproxy
* calico / cilium
* API server only exposed on internal net
* prometeus!
* log aggreagator

## Infra
* VM for vault
* VM for NFS
* VM for NATS

## Proxy
* DMZ
* Raspberry pi
* TLS Termination
* http proxy into K8s

## NATS
* Only accessed by K8s Ip range

## NFS
* For volumes

