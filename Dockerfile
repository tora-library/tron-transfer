FROM centos:7

ENV JDK_TAR="jdk-8u202-linux-x64.tar.gz"
ENV JDK_DIR="jdk1.8.0_202"
ENV JDK_MD5="0029351f7a946f6c05b582100c7d45b7"
ENV BASE_DIR="/java-ts"

RUN set -o errexit -o nounset \
    && yum -y install git wget \
    && yum -y install which \
    && wget -P /usr/local https://github.com/frekele/oracle-java/releases/download/8u202-b08/$JDK_TAR \
    && echo "$JDK_MD5 /usr/local/$JDK_TAR" | md5sum -c \
    && tar -zxf /usr/local/$JDK_TAR -C /usr/local\
    && rm /usr/local/$JDK_TAR \
    && export JAVA_HOME=/usr/local/$JDK_DIR \
    && export CLASSPATH=$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar \
    && export PATH=$PATH:$JAVA_HOME/bin \
    && mv $JAVA_HOME/jre /usr/local \
    && rm -rf $JAVA_HOME \
    && yum clean all

ENV JAVA_HOME="/usr/local/java/jdk1.8.0_202"
ENV PATH=$PATH:$JAVA_HOME/bin

WORKDIR $BASE_DIR

COPY ./java-ts $BASE_DIR/

ENTRYPOINT ["./entrypoint.sh"]
