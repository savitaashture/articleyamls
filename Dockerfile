FROM registry.access.redhat.com/ubi9:latest

RUN ls -lrt /etc/pki/

RUN ls -lrt /etc/pki/entitlement

RUN dnf list kernel-devel

RUN yum update -y

RUN yum install --enablerepo="rhocp-4.14-for-rhel-8-x86_64-rpms" openshift-clients

CMD ["bash", "-c", "dnf search kernel-devel --showduplicates | tail -n2"]
