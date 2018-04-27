FROM maven:3
LABEL maintainer="Tomaer Ma<i@tomaer.com>"

WORKDIR /opt/b3log/solo
ADD . /tmp

RUN cd /tmp && mvn install -Pci && mv target/solo/* /opt/b3log/solo/ \
    && mkdir -p /opt/b3log/backup/ && mkdir -p /opt/b3log/tmp/ \
    && rm -rf /opt/b3log/solo/WEB-INF/classes/local.properties /opt/b3log/solo/WEB-INF/classes/mail.properties /opt/b3log/solo/WEB-INF/classes/latke.properties \
    && rm -rf /tmp/* && rm -rf ~/.m2 && apt-get update && apt-get install mysql-client -y

ADD ./src/main/resources/docker/entrypoint.sh $WORKDIR
ADD ./src/main/resources/docker/local.properties.h2 /opt/b3log/tmp
ADD ./src/main/resources/docker/local.properties.mysql /opt/b3log/tmp
ADD ./src/main/resources/docker/mail.properties /opt/b3log/tmp
ADD ./src/main/resources/docker/latke.properties /opt/b3log/tmp
ENV PINPOINT_AGETN_VERSION="1.7.2"
ENV PINPOINT_AGENT_PATH="/usr/local/pinpoint-agent"
RUN mkdir -pv $PINPOINT_AGENT_PATH \
    && curl -ks https://pkg.goodrain.com/apps/pinpoint/pinpoint-agent-${PINPOINT_AGETN_VERSION}-SNAPSHOT.tar.gz | tar xz -C /usr/local/pinpoint-agent

RUN chmod 777 /opt/b3log/solo/entrypoint.sh

VOLUME ["/opt/b3log/backup/"]

EXPOSE 8080

ENTRYPOINT [ "/opt/b3log/solo/entrypoint.sh" ]
