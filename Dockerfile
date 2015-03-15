FROM adelton/freeipa-client:fedora-21

MAINTAINER Nathan Kinder

# Install Ipsilon packages
RUN yum install -y ipsilon ipsilon-tools ipsilon-authkrb ipsilon-infosssd \
        ipsilon-tools-ipa ipsilon-saml2 ipsilon-authfas ipsilon-authldap \
        ipsilon-authform mod_ssl && yum clean all

# Install FreeIPA admin tools to allow a us to get a keytab
RUN yum install -y freeipa-admintools && yum clean all

# Add a script to configure and start ipsilon
ADD ipsilon-server-configure-first /usr/sbin/ipsilon-server-configure-first
RUN chmod -v +x /usr/sbin/ipsilon-server-configure-first

EXPOSE 80 443

ENTRYPOINT /usr/sbin/ipsilon-server-configure-first
