# Playbook for deploying architecture for NaviMerch

I express great gratitude for the article and the materials provided @vkozlovski on the portal habrahabr
Some of them were used in my implementation

**vkozlovsi**: https://github.com/vkozlovski/ansible-cloud-hosting

**article**: https://habr.com/post/277657/

*Note: This is not a fork or a copy. Everything was rewritten from scratch, I just used the materials that were provided


## Quick start

**Performance was verified only on scaleway on ubuntu 18.04.
Other hosts may not work due to a different interface name**


1. Firstly you need to add server ip to inventory file and set hostname
```
[dc-1]
51.158.77.88 hostname=cw-1 
51.15.228.112 hostname=cw-2 
51.158.75.141 hostname=cw-3 
```

2. Add docker swarm manager ip to dc-1.yml in group_vars folder
```
docker_swarm_manager_ip: '10.14.203.157'
```
*Note: it may be equal to ens2 interface ip

3. Add docker three ip address to cloud.yml in group_vars folder
```
docker_consul_start_join_wan:
  - "{{ hostvars[groups['dc-1'][0]]['ansible_ens2']['ipv4']['address'] }}"
  - "{{ hostvars[groups['dc-1'][1]]['ansible_ens2']['ipv4']['address'] }}"
  - "{{ hostvars[groups['dc-1'][2]]['ansible_ens2']['ipv4']['address'] }}"
```
4. Run ansible-playbook
```
$ ansible-playbook -i inventory main.yml
```
