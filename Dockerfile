FROM ubuntu:20.04
# Chrome needs a timezone/locale specific to know which version to set
ENV TZ=America/New_York
RUN echo "Preparing geographic area ..."
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update -y
RUN apt-get install -y curl wget gnupg ca-certificates procps libxss1 git
# Rather than loading up all the dependencies needed for puppeteer 
# just installing chrome will automatically load all the neccessary dependencies
# even though this chrome version is not used by puppeteer
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list
RUN apt-get update && apt-get -y install google-chrome-stable

# Install Node v14
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

# Install global packages to enable shortcutting in github action
RUN npm install -g yarn
RUN npm install -g lerna

# Install Puppeteer under /node_modules so it's available system-wide
ADD package.json yarn.lock /
RUN yarn