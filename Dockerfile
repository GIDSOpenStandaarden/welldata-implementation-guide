FROM openjdk:24-jdk-bookworm
LABEL maintainer="roland@headease.nl"
## https://docs.docker.com/reference/dockerfile/#automatic-platform-args-in-the-global-scope
ARG TARGETVARIANT

# Install native compilation dependencies.
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y gcc g++ make apt-utils wget \
    libgtk-3-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils \
    libatspi2.0-0 libsecret-1-0

# Install Node from NodeSource.
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install -y nodejs

RUN wget  -nv https://github.com/jgraph/drawio-desktop/releases/download/v26.0.16/drawio-${TARGETVARIANT}-26.0.16.deb
RUN dpkg -i drawio-${TARGETVARIANT}-26.0.16.deb

# Install Jekyll for Ubuntu/Debian: https://jekyllrb.com/docs/installation/ubuntu/
RUN apt-get install -y ruby-full build-essential zlib1g-dev
RUN gem install -N jekyll bundler

RUN mkdir /app
WORKDIR /app

# Install the FHIR Shorthand transfiler:
RUN npm i -g fsh-sushi

# Download the IG publisher.
COPY ./_updatePublisher.sh .
RUN bash ./_updatePublisher.sh -y
RUN chmod +x *.sh *.bat

ADD ig.ini .
ADD sushi-config.yaml .

CMD ["bash", "_genonce.sh"]
