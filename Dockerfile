FROM jenkins/jenkins

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

COPY groovy/* /usr/share/jenkins/ref/init.groovy.d/
COPY id_rsa /var/jenkins_home/.ssh/id_rsa

USER root
RUN apt-get update -y ;apt-get install maven ssh software-properties-common -y
RUN chown -R 1000:1000 /var/jenkins_home
USER jenkins
