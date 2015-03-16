FROM adelton/freeipa-client:fedora-21

MAINTAINER Nathan Kinder

# Install Ipsilon packages
RUN yum install -y ipsilon ipsilon-tools ipsilon-authkrb ipsilon-infosssd \
        ipsilon-tools-ipa ipsilon-saml2 ipsilon-authfas ipsilon-authldap \
        ipsilon-authform mod_ssl && yum clean all

# Add a script to configure and start ipsilon
ADD ipsilon-server-configure-first /usr/sbin/ipsilon-server-configure-first
RUN chmod -v +x /usr/sbin/ipsilon-server-configure-first

# Add a script to allow us to create services in IPA
ADD ipsilon-service-add /usr/sbin/ipsilon-service-add

EXPOSE 80 443

ENTRYPOINT /usr/sbin/ipsilon-server-configure-first
