FROM adelton/freeipa-client:fedora-21

MAINTAINER Nathan Kinder

# Install Ipsilon packages
RUN yum install -y ipsilon ipsilon-authkrb mod_ssl && yum clean all

# Re-install Ipsilon packages from Copr
RUN yum install -y yum-plugin-copr && \
    yum copr enable -y puiterwijk/Ipsilon-master && \
    yum erase -y ipsilon-* && \
    yum --disablerepo="*" --enablerepo="*Ipsilon*" install -y ipsilon ipsilon-authkrb && \
    yum clean all

# Install FreeIPA admin tools to allow a us to get a keytab
RUN yum install -y freeipa-admintools && yum clean all

# Add a script to configure and start ipsilon
ADD ipsilon-server-configure-first /usr/sbin/ipsilon-server-configure-first
RUN chmod -v +x /usr/sbin/ipsilon-server-configure-first

EXPOSE 80 443

ENTRYPOINT /usr/sbin/ipsilon-server-configure-first
