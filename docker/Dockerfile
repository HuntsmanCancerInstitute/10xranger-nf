# Based on
FROM centos:7

# Install some utilities
RUN yum install -y \
    file \
    which \
    wget \
    unzip

COPY cellranger-7.0.0.tar.gz /tmp
COPY cellranger-atac-2.1.0.tar.gz /tmp
COPY cellranger-arc-2.0.1.tar.gz /tmp
COPY spaceranger-1.3.1.tar.gz /tmp

# Install cellranger
RUN cd /tmp/ && \
    mv cellranger-7.0.0.tar.gz /opt/ && \
    cd /opt/ && \
    tar -xzvf cellranger-7.0.0.tar.gz && \
    rm -f cellranger-7.0.0.tar.gz

# Install cellranger-atac
RUN cd /tmp/ && \
    mv cellranger-atac-2.1.0.tar.gz /opt/ && \
    cd /opt/ && \
    tar -xzvf cellranger-atac-2.1.0.tar.gz && \
    rm -f cellranger-atac-2.1.0.tar.gz

# Install cellranger-arc
RUN cd /tmp/ && \
    mv cellranger-arc-2.0.1.tar.gz /opt/ && \
    cd /opt/ && \
    tar -xzvf cellranger-arc-2.0.1.tar.gz && \
    rm -f cellranger-arc-2.0.1.tar.gz


# Install spaceranger
RUN cd /tmp/ && \
    mv spaceranger-1.3.1.tar.gz /opt/ && \
    cd /opt/ && \
    tar -xzvf spaceranger-1.3.1.tar.gz && \
    rm -f spaceranger-1.3.1.tar.gz



# path
ENV PATH /opt/cellranger-atac-2.1.0:$PATH
ENV PATH /opt/cellranger-7.0.0:$PATH
ENV PATH /opt/cellranger-arc-2.0.1:$PATH
ENV PATH /opt/spaceranger-1.3.1:$PATH
