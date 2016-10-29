FROM ubuntu:16.04

# make sure we're all up to date and install simple tools for our scripts
RUN apt-get update && apt-get -y upgrade && apt-get -y install gawk bc

# add our demo script
ADD money-changer.sh /usr/local/bin 

# Default command
CMD ["/bin/bash"]
