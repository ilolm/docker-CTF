FROM ubuntu:latest

RUN apt update && apt install -y docker.io docker-compose-v2 openssh-server nano

# Setup docker env
RUN mkdir -p /var/lib/docker

# SSH installation
RUN mkdir -p /run/sshd && \
    sed -i "s/#PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config && \
    sed -i "s/#PasswordAuthentication.*/PasswordAuthentication yes/" /etc/ssh/sshd_config && \
    ssh-keygen -A

# Adding user king
RUN useradd -m king && echo -n "king:Password12345" | chpasswd
RUN chmod 0700 /home/king && userdel ubuntu

# Setting up bash
RUN sed -i 's#/bin/sh#/bin/bash#' /etc/passwd

# Linking .bash_history to /dev/null
RUN ln -sf /dev/null /root/.bash_history
RUN ln -sf /dev/null /home/king/.bash_history

# flags
COPY ./main_flags/root.txt /root/root.txt
COPY ./main_flags/user.txt /home/king/user.txt
RUN chmod 0400 /root/root.txt
RUN chmod 0400 /home/king/user.txt && chown king:king /home/king/user.txt

# Copying main files
COPY ./docker-web /home/king/docker-web
RUN chmod 0755 /home/king/docker-web

EXPOSE 22
EXPOSE 23
EXPOSE 3306
EXPOSE 8080

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh