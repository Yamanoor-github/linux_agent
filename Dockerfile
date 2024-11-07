FROM node:20.14.0-slim

RUN apt update
RUN apt upgrade -y
RUN apt install curl git jq libicu-dev buildah -y
RUN apt install azure-cli -y
RUN npm install -g @azure/static-web-apps-cli
RUN apt install podman -y

RUN curl -LO https://get.helm.sh/helm-v3.15.1-linux-amd64.tar.gz \
 && tar -xzf helm-v3.15.1-linux-amd64.tar.gz \
 && mv linux-amd64/helm /usr/local/bin \
 && rm -rf helm-v3.15.1-linux-amd64.tar.gz linux-amd64

RUN helm plugin install https://github.com/chartmuseum/helm-push

# Also can be "linux-arm", "linux-arm64".
ENV TARGETARCH="linux-x64"

WORKDIR /azp/

COPY ./start.sh ./
RUN chmod +x ./start.sh

# Create agent user and set up home directory
RUN useradd -m -d /home/agent agent
RUN chown -R agent:agent /azp /home/agent

#USER agent
# Another option is to run the agent as root.
ENV AGENT_ALLOW_RUNASROOT="true"

ENTRYPOINT [ "./start.sh" ]