FROM docker.elastic.co/elasticsearch/elasticsearch:7.9.1

RUN echo "xpack.security.enabled: false" >> /usr/share/elasticsearch/config/elasticsearch.yml
RUN echo "discovery.type: single-node" >> /usr/share/elasticsearch/config/elasticsearch.yml
RUN bin/elasticsearch-plugin install -b analysis-icu && \
    bin/elasticsearch-plugin install -b analysis-phonetic

ADD docker-entrypoint.sh /docker-entrypoint.sh

#Fix container start issue
RUN chmod 777 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 9200 9300
