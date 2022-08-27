# k8s-personal
playground

## hw info
- OS: Arch Linux x86_64 
- Host: B365 M AORUS ELITE 
- Kernel: 5.18.13-arch1-1 
- Packages: 648 (pacman) 
- Shell: bash 5.1.16 
- CPU: Intel i7-9700K (8) @ 4.900GHz 
- GPU: NVIDIA GeForce GTX 1660 SUPER 
- Memory: 15943MiB

## k8s info
- version: 1.24(latest release if it's possible)

## targets
- k8s auto install on bare-metal [x]
  - need to test on fresh arch linux machine someday [ ]
- kubectl to master from my laptop at anywhere [ ]
  - k8s api-server: advertise public ip too
  - (router) port forwarding
  - simple: copy ~/.kube/config into laptop [ ]
  - advance: master RBAC & create user or role for laptop [ ]
- PaaS(ex. Azure functions)
  - simple: request --> pod1(nginx) --> pod2(router --> function call (single container)) --> response [ ]
  - advance: request --> pod1(nginx) --> pod2(router --> function process w/ socket (2 containers)) --> response [ ]
- multi node support [ ]
  - using virtualbox vm
  - NatNetwork
- auto-scaling
  - targets: nginx, function pods
  - function call rate per minute [ ]
  - cpu/mem w/ monitoring [ ]
  - req/res latency [ ]
- monitoring [ ]
  - stack: prometheus, grafana
  - monitoring targets
    - cpu/mem consumed by each pod [ ]
    - req/res latency [ ]
