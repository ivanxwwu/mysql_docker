# Copyright (c) 2017, Oracle and/or its affiliates. All rights reserved.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
#FROM oraclelinux:7-slim
FROM oraclelinux:7-slim

#ARG MYSQL_SERVER_PACKAGE=mysql-community-server-minimal-5.7.29
ARG MYSQL_SERVER_PACKAGE=mysql-community-server-5.7.29
ARG MYSQL_SHELL_PACKAGE=mysql-shell-8.0.19

ENV GOHOME=/usr/local/go
ENV GOPATH=/root/goworkspace
ENV PATH=$PATH:\${GOHOME}/bin
ENV GOBIN=$GOPATH/bin
ENV PS1="[\u@\h \W] \$ "

# Install server
RUN yum install -y https://repo.mysql.com/mysql-community-release-el7.rpm \
      https://repo.mysql.com/mysql-community-release-el7.rpm \
  && yum-config-manager --enable mysql57-server \
  && yum install -y \
      libaio \
      perl \
      perl-Data-Dumper.x86_64 \
      numactl \
      openssl \
      libpwquality \
      openssh-clients \
      openssh-server \
      vim \
      iputils \
      wget \
      iproute \
      sudo \
      make \
      
  && yum clean all \
  && mkdir /docker-entrypoint-initdb.d


RUN /usr/bin/ssh-keygen -q -t rsa -b 2048 -f /etc/ssh/ssh_host_rsa_key -N ''
RUN /usr/bin/ssh-keygen -q -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N ''
RUN /usr/bin/ssh-keygen -t dsa -f /etc/ssh/ssh_host_ed25519_key -N ''
RUN echo "root:123456" | /usr/sbin/chpasswd

ADD mysql-5.7.27-linux-glibc2.12-x86_64.tar.gz  /usr/local/
RUN ln -s /usr/local/mysql-5.7.27-linux-glibc2.12-x86_64 /usr/local/mysql

RUN mkdir /home/mysql/data -p \
	&& mkdir /home/mysql/temp -p \
	&& mkdir /home/mysql/logs -p

RUN groupadd mysql \
	&& useradd -r -g mysql -s /bin/bash mysql \
	&& chown -R mysql:mysql /home/mysql \
	&& chown -R mysql:mysql /usr/local/mysql \
	&& chown -R mysql:mysql /usr/local/mysql-5.7.27-linux-glibc2.12-x86_64

COPY docker-entrypoint.sh /entrypoint.sh
#COPY healthcheck.sh /healthcheck.sh
COPY sshd_config /etc/ssh/sshd_config
ADD  go1.14.2.linux-amd64.tar.gz /usr/local/
COPY ./init.sh /init.sh

ENV PATH=$PATH:/usr/local/go/bin
ENV PATH=$PATH:/usr/local/mysql/bin

#ENTRYPOINT ["/entrypoint.sh mysqld"]
HEALTHCHECK CMD /healthcheck.sh
EXPOSE 3306 33060 22
#CMD ["mysqld"]
CMD ["/init.sh"]

