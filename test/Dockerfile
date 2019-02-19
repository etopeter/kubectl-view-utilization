FROM ubuntu:18.04
RUN apt-get update && apt-get install -yq gawk mawk original-awk ruby

# Install Bats
ADD https://github.com/sstephenson/bats/archive/v0.4.0.tar.gz /tmp/v0.4.0.tar.gz

RUN tar -x -z -f "/tmp/v0.4.0.tar.gz" -C /tmp/ && \
    bash "/tmp/bats-0.4.0/install.sh" /usr/local && \
    gem install bashcov codecov && \
    rm -rf /tmp/*

RUN useradd -ms /bin/bash tester
USER tester
ENV PS4="+"
