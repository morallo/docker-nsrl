FROM debian:wheezy
MAINTAINER blacktop, https://github.com/blacktop

#Prevent daemon start during install
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && \
    chmod +x /usr/sbin/policy-rc.d

# Install dependencies
RUN \
  apt-get -qq update && \
  apt-get install -yq python-bloomfilter \
                      unzip \
                      curl  --no-install-recommends && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add scripts
ADD /scripts /nsrl/
RUN chmod 755 /nsrl/*

# Grab NSRL Database and convert to bloomfilter
RUN /nsrl/shrink_nsrl.sh

WORKDIR /nsrl

ENTRYPOINT ["/nsrl/search.py"]

CMD ["-h"]
