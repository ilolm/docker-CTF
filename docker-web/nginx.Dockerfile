FROM nginx:1.27.2-perl

# Installing needed software
RUN apt-get update && \
    apt-get install -y sudo nano openssh-server cron ncat net-tools

# Adding users | passwords | .bash_history > /dev/null
RUN useradd -m gleb && useradd -m rebeca && \
    echo "gleb:36bfX1mATPcFyVzWX2y0cRf930k=" | chpasswd && \
    echo rebeca:$(openssl rand -base64 20) | chpasswd && \
    ln -sf /dev/null /home/gleb/.bash_history && \
    ln -sf /dev/null /home/rebeca/.bash_history && \
    ln -sf /dev/null /root/.bash_history

# for ssh
ADD ./.ssh.tar /home/rebeca/
RUN mkdir -p /var/run/sshd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    chmod 700 -R /home/rebeca/.ssh && chown rebeca:rebeca -R /home/rebeca/.ssh

# FLAGS
COPY --chown=gleb:gleb --chmod=600 ./flags/gleb.txt /home/gleb/gleb.txt
COPY --chown=rebeca:rebeca --chmod=600 ./flags/rebeca.txt /home/rebeca/rebeca.txt
COPY --chown=root:root --chmod=600 ./flags/docker-root.txt /root/docker-root.txt

# figure out yourself)))
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./html /home/gleb/html
COPY --chmod=644 ./crontab /etc/crontab
COPY --chmod=644 ./demotivation /root/demotivation
COPY --chown=root:root --chmod=440 ./sudoers /etc/sudoers

RUN crontab /etc/crontab && \
    chown rebeca:root /usr/bin/find && \
    chmod u+s /usr/bin/find && \
    chown gleb:gleb -R /home/gleb/html && \
    chown root:root /home/gleb/html/logs && chmod 777 /home/gleb/html/logs

EXPOSE 8080 22

# cron doesn't run anyway, I need to run it explicitly every time container starts..
CMD service ssh start && nginx -g 'daemon off;' && service cron start
