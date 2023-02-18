FROM scratch


ADD rootfs.tar.gz /

ENV JAVA_HOME=/opt/jre          \
    PATH="$PATH:/opt/jre/bin"   \
    LANG=en_EN.UTF-8            \
    LC_ALL=en_EN.UTF-8

CMD ["/bin/sh"]
