# Based on
FROM centos:7

# Install some utilities
RUN yum install -y \
    file \
    which \
    wget \
    unzip

COPY cellranger-6.0.0.tar.gz /tmp
COPY cellranger-atac-1.2.0.tar.gz /tmp

# Install cellranger
RUN cd /tmp/ && \
    mv cellranger-6.0.0.tar.gz /opt/ && \
    cd /opt/ && \
    tar -xzvf cellranger-6.0.0.tar.gz && \
    rm -f cellranger-6.0.0.tar.gz

# Install cellranger-atac
RUN cd /tmp/ && \
    mv cellranger-atac-1.2.0.tar.gz /opt/ && \
    cd /opt/ && \
    tar -xzvf cellranger-atac-1.2.0.tar.gz && \
    rm -f cellranger-1.2.0.tar.gz

# path
ENV PATH /opt/cellranger-atac-1.2.0:$PATH
ENV PATH /opt/cellranger-6.0.0:$PATH
