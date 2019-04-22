FROM centos:7

MAINTAINER "E.Vidal" <esther.vidal@edreamsodigeo.com>
ARG VERSION_SCALA=2.12.8
ARG VERSION_PYTHON=3.6.4
ARG VERSION_MAVEN=3.6.0
ARG VERSION_JAVA=1.8.0
ARG VERSION_SPARK=2.3.3
ARG VERSION_SBT=2.3.3


RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
 && rpm -Uvh https://rpms.remirepo.net/enterprise/remi-release-7.rpm

RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm

# normal updates
RUN yum -y update
# ssh
RUN yum -y install openssh-server passwd zip unzip; yum clean all

# httpd
RUN yum -y install httpd wget git gcc-c++ gcc glibc glibc-common gd gd-devel tee

# python
RUN yum -y install python-setuptools python-devel python36u python36u-libs python36u-devel python36u-pip
# tools
RUN yum -y install epel-release iproute at curl crontabs git make

#sbt
RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo
RUN yum -y install sbt

#jdk
RUN yum -y install java-1.8.0-openjdk.x86_64

RUN export JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk | tee -a /etc/profile
RUN export JRE_HOME=/usr/lib/jvm/jre | tee -a /etc/profile
RUN source /etc/profile
ENV JAVA_HOME=/usr/lib/jvm/jre-1.8.0-openjdk
ENV PATH=$PATH:$JAVA_HOME/bin
#scala
RUN wget http://downloads.lightbend.com/scala/${VERSION_SCALA}/scala-${VERSION_SCALA}.rpm
RUN yum -y install scala-${VERSION_SCALA}.rpm

#Install maven
ARG VERSION_MAVEN=3.6.0
RUN curl -O http://www-eu.apache.org/dist/maven/maven-3/${VERSION_MAVEN}/binaries/apache-maven-${VERSION_MAVEN}-bin.tar.gz
RUN tar xzf apache-maven-${VERSION_MAVEN}-bin.tar.gz
RUN mv apache-maven-${VERSION_MAVEN} /opt/maven
ADD maven.sh /etc/profile.d/maven.sh
RUN source /etc/profile.d/maven.sh

#Install spark
RUN wget http://www-eu.apache.org/dist/spark/spark-${VERSION_SPARK}/spark-${VERSION_SPARK}-bin-hadoop2.7.tgz
RUN tar xzf spark-${VERSION_SPARK}-bin-hadoop2.7.tgz
RUN mkdir /usr/local/spark
RUN cp -r spark-${VERSION_SPARK}-bin-hadoop2.7/* /usr/local/spark
RUN export SPARK_EXAMPLES_JAR=/usr/local/spark/examples/jars/spark-examples_2.11-${VERSION_SPARK}.jar
ENV PATH=$PATH:$HOME/bin:/usr/local/spark/bin

#Error: ResponseItem.ErrorDetail[code=255,message=The command '/bin/sh -c yum-builddep python' returned a non-zero code: 255]
#RUN yum-builddep python

#Download python
RUN wget https://www.python.org/ftp/python/${VERSION_PYTHON}/Python-${VERSION_PYTHON}.tgz
RUN tar xzf Python-${VERSION_PYTHON}.tgz
WORKDIR Python-${VERSION_PYTHON}

#Compile and install python
RUN ./configure --enable-optimizations --enable-shared --prefix='/usr/local'  LDFLAGS='-Wl,--rpath=/usr/local/lib'
RUN make
RUN make install

WORKDIR /
#Install python libraries
RUN yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel python34-setuptools
RUN easy_install pip
RUN pip install --upgrade pip
ADD requirements.txt .
RUN pip install -v -r requirements.txt

#RUN echo $JAVA_HOME
#RUN echo java -version
ENV HOME /root

WORKDIR /root

ENTRYPOINT [ "sh", "-c", "echo $HOME" ]
#echo $JAVA_HOME
#echo java -version
#sbt scalaVersion

#python -V

#spark-submit --version

#sbt scalaVersion



