PRIVATE_KEY=~/.ssh/id_rsa
# SWARM_IP=178.62.232.38:8000
CA_CERTS_DIR=certs/ca
CONSUL_CERTS_DIR=certs/consul
DOCKER_CERTS_DIR=certs/docker

run:
	@(ansible-playbook -i inventory main.yml)

ping:
	@(ansible all -i inventory -m ping)

tasks:
	@(ansible-playbook -i inventory main.yml --list-tasks)

hosts:
	@(ansible-playbook -i inventory main.yml --list-hosts)

gen-ca:
	@(mkdir -p $(CA_CERTS_DIR))
	@(openssl genrsa -aes256 -out $(CA_CERTS_DIR)/ca-key.pem 4096)
	@(openssl req -new -x509 -days 365 -key $(CA_CERTS_DIR)/ca-key.pem -sha256 -out $(CA_CERTS_DIR)/ca.pem)

gen-consul-certs:
	@(touch $(CONSUL_CERTS_DIR)/certindex)
	@(touch $(CONSUL_CERTS_DIR)/certindex.attr)
	@(cd $(CONSUL_CERTS_DIR) && openssl req -x509 -newkey rsa:2048 -days 3650 -nodes -out ca.cert)
	@(cd $(CONSUL_CERTS_DIR) && openssl req -newkey rsa:1024 -nodes -out consul.csr -keyout consul.key)
	@(cd $(CONSUL_CERTS_DIR) && openssl ca -batch -config myca.conf -notext -in consul.csr -out consul.cert)


swarm:
	@(docker -H tcp://$(SWARM_IP) --tlsverify=true --tlscacert=$(CA_CERTS_DIR)/ca.pem --tlscert=$(DOCKER_CERTS_DIR)/cert.pem --tlskey=$(DOCKER_CERTS_DIR)/key.pem info)
