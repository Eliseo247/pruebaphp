FROM ansp/php-73-rhel7:latest
MAINTAINER Joeri van Dooren

#RUN rpm -Uvh http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
#RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
#RUN yum -y install epel-release && yum -y install httpd wget unzip git pwgen supervisor bash-completion psmisc tar mysql
#RUN yum -y install php70 php70-php php70-php-mbstring php70-php-gd php70-php-dom php70-php-pdo php70-php-mysqlnd php70-php-mcrypt php70-php-process php70-php-pear php70-php-cli php70-php-xml php70-php-curl php70-php-phalcon2 && yum --enablerepo=epel -y install ssmtp && yum clean all -y

RUN yum -y install vim && yum clean all -y

ADD http://wordpress.org/latest.tar.gz /opt/app-root/src/

RUN tar xvzf /opt/app-root/src/wordpress.tar.gz

RUN mkdir /opt/app-root/moodldata2
RUN chgrp -R 0 /opt/app-root/moodldata2 && \
    chmod -R g+rwX /opt/app-root/moodldata2
    

VOLUME /opt/app-root/src

USER 997
EXPOSE 8080
RUN exec httpd -D FOREGROUND

# Set labels used in OpenShift to describe the builder images
LABEL io.k8s.description="Wordpress" \
      io.k8s.display-name="wordpress apache centos7 epel" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,wordpress,apache" \
      io.openshift.min-memory="1Gi" \
      io.openshift.min-cpu="1" \
      io.openshift.non-scalable="false"
