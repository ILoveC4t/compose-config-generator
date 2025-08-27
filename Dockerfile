FROM alpine:latest

RUN apk add --no-cache gettext bash

RUN mkdir -p /templates /output /scripts

COPY generate-config.sh /scripts/generate-config.sh

RUN chmod +x /scripts/generate-config.sh

ENV TEMPLATES_DIR=/templates
ENV OUTPUT_DIR=/output
ENV TEMPLATE_PATTERN=*.template
ENV KEEP_RUNNING=false

WORKDIR /scripts

CMD ["/scripts/generate-config.sh"]