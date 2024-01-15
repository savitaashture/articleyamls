FROM registry.access.redhat.com/ubi9:latest

RUN dnf list kernel-devel

CMD ["bash", "-c", "dnf search kernel-devel --showduplicates | tail -n2"]
