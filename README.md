# docker-ipsilon
This repository contains everything needed to build a Docker image for
running the Ipsilon identity provider in a Docker container.

The Ipsilon image is based on the FreeIPA client (adelton/freeipa-client)
docker image, which requires a FreeIPA server.  This allows Ipsilon to be
configured for Kerberos authentication.

# Building the image
To build the Ipsilon docker image, simply run the following in the root
of this repository:

    docker build -t ipsilon .

Ipsilon is still in early development, so the image currently uses regularly
produced developer builds of Ipsilon from Copr.  Fedora 21 is currently used,
but this will be expanded to include other platforms as Ipsilon matures.

# Using the image
The easiest way to quickly set up an Ipsilon container is to create a FreeIPA
server container and link it to an Ipsilon container.  This can be done like
so:

    docker run --name freeipa-server -d -h ipa.example.test -e PASSWORD=<FreeIPA Admin Password> --cap-add=SYS_TIME adelton/freeipa-server:fedora-21
    docker logs -f freeipa-server

You will need to wait until the FreeIPA server configuration is complete
before creating the Ipsilon container.  You can track the progress by using
the "docker logs" command shown above.  When the FreeIPA server configuration
is complete, create the Ipsilon container as follows:

    docker run --name ipsilon -h ipsilon.example.test --link freeipa-server:ipa -e PASSWORD=<FreeIPA Admin Password> ipsilon

If you want to expose the Ipsilon service on your actual network, you will want
to map port 443 to your container host system.  In addition, you will want to
register a reachable IP address for the Ipsilon container in the FreeIPA DNS
server.  This can be accomplished by adding the following options to your
'docker run' command:

    -p 443:443 -e IPSILON_IP_ADDRESS=<ip address>

The FreeIPA server should also use Fedora 21, as the FreeIPA admin commands
used when installing Ipsilon need to match the FreeIPA server version to work
properly.

Ipsilon will be configured for both Kerberos and forms-based authentication,
and the FreeIPA admin user will be set up as the admin of Ipsilon.

If you are using your FreeIPA server container for DNS, Ipsilon will be
available at the following URL:

    https://ipsilon.example.test/idp

# Additional Info
* Ipsilon Project - https://fedorahosted.org/ipsilon/
* FreeIPA Project - http://www.freeipa.org/
* FreeIPA Client Container - https://registry.hub.docker.com/u/adelton/freeipa-client/
* FreeIPA Server Container - https://registry.hub.docker.com/u/adelton/freeipa-server/
