FROM scratch


ADD rootfs.tar.gz /

ENV JAVA_HOME=/opt/jre          \
    PATH="$PATH:/opt/jre/bin"   \
    LANG=C.UTF-8                \
    LC_ALL=C

CMD ["/bin/bash"]
