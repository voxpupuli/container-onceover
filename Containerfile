ARG BASE_IMAGE=docker.io/library/ruby:3.2-alpine

FROM $BASE_IMAGE AS builder

# Gems have to be ARG and ENV because they are used as reference in the Gemfile
ARG RUBYGEM_BUNDLER
ARG RUBYGEM_ONCEOVER
ARG RUBYGEM_ONCEOVER_CODEQUALITY

ENV RUBYGEM_BUNDLER=${RUBYGEM_BUNDLER:-2.7.2}
ENV RUBYGEM_ONCEOVER=${RUBYGEM_ONCEOVER:-5.0.2}
ENV RUBYGEM_ONCEOVER_CODEQUALITY=${RUBYGEM_ONCEOVER_CODEQUALITY:-1.1.0}

COPY onceover/Gemfile /

RUN apk update \
    && apk upgrade \
    && apk add --no-cache --update alpine-sdk yaml-dev \
    && rm -rf /usr/local/lib/ruby/gems/*/gems/bundler-* \
    && rm -rf /usr/local/lib/ruby/gems/*/specifications/default/bundler-*.gemspec \
    && gem install bundler -v ${RUBYGEM_BUNDLER} \
    && bundle config set path.system true \
    && bundle config set jobs $(nproc) \
    && bundle install --gemfile=/Gemfile \
    && bundle clean --force \
    && rm -rf /usr/local/lib/ruby/gems/*/cache/* \
    && rm -rf /usr/local/lib/ruby/gems/*/gems/cgi-* \
    && rm -rf /usr/local/lib/ruby/gems/*/specifications/default/cgi-*.gemspec \
    && rm -rf /usr/local/lib/ruby/gems/*/gems/stringio-* \
    && rm -rf /usr/local/lib/ruby/gems/*/specifications/default/stringio-*.gemspec \
    && rm -rf /usr/local/lib/ruby/gems/*/gems/rdoc-* \
    && rm -rf /usr/local/lib/ruby/gems/*/specifications/default/rdoc-*.gemspec \
    && rm -rf /usr/local/lib/ruby/gems/*/gems/rexml-* \
    && rm -rf /usr/local/lib/ruby/gems/*/specifications/rexml-*.gemspec \
    && rm -rf /usr/local/lib/ruby/gems/*/gems/racc-* \
    && rm -rf /usr/local/lib/ruby/gems/*/specifications/default/racc-*.gemspec \
    && rm -rf /usr/local/lib/ruby/gems/*/gems/drb-* \
    && rm -rf /usr/local/lib/ruby/gems/*/specifications/default/drb-*.gemspec \
    && rm -rf /usr/local/lib/ruby/gems/*/gems/csv-* \
    && rm -rf /usr/local/lib/ruby/gems/*/specifications/default/csv-*.gemspec \
    && rm -rf /usr/local/lib/ruby/gems/*/gems/minitest-* \
    && rm -rf /usr/local/lib/ruby/gems/*/specifications/minitest-*.gemspec

###############################################################################

FROM $BASE_IMAGE AS final

LABEL org.label-schema.maintainer="Voxpupuli Team <voxpupuli@groups.io>" \
      org.label-schema.vendor="Voxpupuli" \
      org.label-schema.url="https://github.com/voxpupuli/container-onceover" \
      org.label-schema.name="Vox Pupuli Onceover" \
      org.label-schema.license="AGPL-3.0-or-later" \
      org.label-schema.vcs-url="https://github.com/voxpupuli/container-onceover" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.dockerfile="/Containerfile"

RUN apk update \
    && apk upgrade \
    && apk add --no-cache jq \
    && apk add --no-cache git \
    && apk add --no-cache curl \
    && apk add --no-cache py3-yaml \
    && rm -rf /usr/local/lib/ruby/gems

COPY --from=builder /usr/local/lib/ruby/gems /usr/local/lib/ruby/gems
COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /Gemfile.lock /Gemfile.lock
COPY Containerfile /
COPY onceover/Rakefile /
COPY onceover/Gemfile /

WORKDIR /repo

ENTRYPOINT [ "onceover" ]
CMD [ "-h" ]
