FROM eclipse-temurin:21-jdk-jammy

ARG PUBLISHER_VERSION=2.0.15

RUN apt-get update && apt-get install -y make jq python3 graphviz ruby-full build-essential wget curl ca-certificates gnupg

# Install Node.js 20.x from NodeSource
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install -y nodejs

RUN gem install jekyll bundler

RUN npm install -g fsh-sushi

RUN mkdir "/src"
WORKDIR /src

RUN curl -L https://github.com/HL7/fhir-ig-publisher/releases/download/${PUBLISHER_VERSION}/publisher.jar -o /usr/local/publisher.jar

ENV saxonPath=/root/.ant/lib/
RUN mkdir -p ${saxonPath}
RUN wget https://repo1.maven.org/maven2/net/sf/saxon/Saxon-HE/11.4/Saxon-HE-11.4.jar -O ${saxonPath}/saxon-he-11.4.jar
RUN wget https://repo1.maven.org/maven2/org/xmlresolver/xmlresolver/5.3.0/xmlresolver-5.3.0.jar -O ${saxonPath}/xmlresolver-5.3.0.jar

ENV DEBUG=1

# Copy entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
