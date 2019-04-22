# Use an official centos7 image
FROM centos:7

RUN localedef -i fr_FR -c -f UTF-8 -A /usr/share/locale/locale.alias fr_FR.UTF-8
ENV LANG fr_FR.utf8
ENV LC_CTYPE="fr_FR.UTF-8"
# gcc because we need regex and pyldap
# openldap-devel because we need pyldap
RUN yum update -y \
    && yum install -y https://centos7.iuscommunity.org/ius-release.rpm \
    && yum install -y python36u python36u-libs python36u-devel python36u-pip \
    && yum install -y which gcc \
    && yum install -y openldap-devel

# pipenv installation
RUN pip3.6 install pipenv
RUN ln -s /usr/bin/pip3.6 /bin/pip
RUN rm /usr/bin/python
# python must be pointing to python3.6
RUN ln -s /usr/bin/python3.6 /usr/bin/python

WORKDIR /opt/intranet


# pipenv install django --python `which python3.6` --system
# pipenv install --python `which python3.6` --system
# copy the Pipfile to the working directory
COPY Pipfile /opt/intranet/
# This is useful for Docker containers, and deployment infrastructure (e.g. Heroku does this)
# explicit is better than implicit
RUN pipenv install --python `which python3.6` --system