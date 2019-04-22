
FROM esthervidal78/jenkins-dev-ds-infra-042019:latest
USER root
RUN yum -y install zip unzip

USER ${user}
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
COPY install-plugins.sh /usr/local/bin/install-plugins.sh
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

ADD ../backup /var/jenkins_home/data/
RUN ls -la /var/jenkins_home

RUN ls -la /var/jenkins_home/data/
