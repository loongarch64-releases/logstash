FROM lcr.loongnix.cn/openeuler/openeuler:24.03-LTS-SP2

RUN dnf install -y git wget jq java-17-openjdk-devel \
                   java-11-openjdk-devel java-1.8.0-openjdk-devel && \
    dnf clean all

WORKDIR /workspace

CMD ["/bin/bash"]

