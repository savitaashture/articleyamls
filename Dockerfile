FROM registry.access.redhat.com/ubi9:latest

# RUN ls -lrt /etc/pki/

RUN ls -lrt /etc/pki/entitlement

RUN dnf search kernel-devel --showduplicates | tail -n2

# listing in order to know which repo to be enabled in the next step
RUN subscription-manager repos --list

RUN subscription-manager repos --enable rhocp-4.13-for-rhel-9-x86_64-rpms

RUN yum -y update
RUN yum install -y openshift-clients.x86_64

RUN oc --help

CMD ["bash", "-c", "dnf search kernel-devel --showduplicates | tail -n2"]
