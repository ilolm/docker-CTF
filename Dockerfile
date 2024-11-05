FROM ubuntu:24.04

# Base packages for main CTF machine
RUN apt-get update \
    && apt-get install -y docker.io docker-compose-v2 openssh-server nano \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && \

    echo "Setup docker env + ssh env" \
    && mkdir -p /var/lib/docker /run/sshd \
    && sed -i "s/#PermitRootLogin.*/PermitRootLogin no/" /etc/ssh/sshd_config \
    && sed -i "s/#PasswordAuthentication.*/PasswordAuthentication yes/" /etc/ssh/sshd_config \
    && ssh-keygen -A && \

    echo "Adding user king" \
    && useradd -m king \
    && echo -n "king:Password12345" | chpasswd \
    && chmod 0700 /home/king \
    && userdel ubuntu && \

    echo "Bash configuring" \
    && sed -i 's#/bin/sh#/bin/bash#' /etc/passwd && \

    echo "Linking .bash_history to /dev/null" \
    && ln -sf /dev/null /root/.bash_history \
    && ln -sf /dev/null /home/king/.bash_history

# Copying flags + main files
COPY ./main_flags/root.txt /root/root.txt
COPY ./main_flags/user.txt /home/king/user.txt
COPY ./docker-web /home/king/docker-web

# Copying php docker image
COPY ["./docker-images/php-fpm.tar", "/docker-images/"]

RUN echo "Permissions for flags" \
    && chown root:root /root/root.txt && chmod 0400 /root/root.txt \
    && chown king:king /home/king/user.txt && chmod 0400 /home/king/user.txt && \

    echo "Permissions for main files" \
    && chmod 0755 /home/king/docker-web && chown -R root:root /home/king/docker-web \
    && chmod 0700 /home/king/docker-web/.ssh.tar \
    && chmod 0400 -R /home/king/docker-web/flags \
    && chmod 0640 /home/king/docker-web/sudoers \
    && mkdir -p /home/king/docker-web/html/logs && chmod 0777 /home/king/docker-web/html/logs


EXPOSE 22 23 3306 8080

COPY ./entrypoint.sh /entrypoint.sh

ENTRYPOINT /entrypoint.sh
CMD ["docker", "compose", "-f", "/home/king/docker-web/docker-compose.yaml", "up"]
