FROM registry.access.redhat.com/ubi8:latest

RUN ls -lrt /etc/pki

RUN ls -lrt /etc/pki/entitlement

CMD ["bash", "-c", "dnf search kernel-devel --showduplicates | tail -n2"]
