FROM nginx:latest

# Installing needed software
RUN apt update
RUN apt install -y sudo nano openssh-server cron ncat net-tools

# Adding users
RUN useradd -m gleb
RUN useradd -m rebeca

# Adding passwords
RUN echo "gleb:36bfX1mATPcFyVzWX2y0cRf930k=" | chpasswd
RUN echo rebeca:$(openssl rand -base64 20) | chpasswd

# for ssh
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
ADD ./.ssh.tar /home/rebeca/
RUN chmod 700 -R /home/rebeca/.ssh && chown rebeca:rebeca -R /home/rebeca/.ssh

# .bash_history > /dev/null
RUN ln -sf /dev/null /home/gleb/.bash_history
RUN ln -sf /dev/null /home/rebeca/.bash_history
RUN ln -sf /dev/null /root/.bash_history

# FLAGS
COPY --chown=gleb:gleb --chmod=600 ./flags/gleb.txt /home/gleb/gleb.txt
COPY --chown=rebeca:rebeca --chmod=600 ./flags/rebeca.txt /home/rebeca/rebeca.txt
COPY --chown=root:root --chmod=600 ./flags/docker-root.txt /root/docker-root.txt

# figure out yourself)))
COPY ./default.conf /etc/nginx/conf.d/default.conf
COPY ./html /home/gleb/html
COPY --chmod=644 ./crontab /etc/crontab
COPY --chmod=644 ./demotivation /root/demotivation
RUN crontab /etc/crontab
COPY --chown=root:root --chmod=440 ./sudoers /etc/sudoers

RUN chown rebeca:root /usr/bin/find
RUN chmod u+s /usr/bin/find

RUN chown gleb:gleb -R /home/gleb/html
RUN chown root:root /home/gleb/html/logs && chmod 777 /home/gleb/html/logs

EXPOSE 8080
EXPOSE 22

CMD service ssh start && nginx -g 'daemon off;' && service cron start
# cron doesn't run anyway, I need to run it explicitly every time container starts.. 
