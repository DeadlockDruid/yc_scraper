# Use an official Ruby runtime as a parent image
FROM ruby:3.3.4

# Set the working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install any needed packages specified in Gemfile
RUN bundle install

# Currently ARM64 version of Chrome is not available
# we are relying on chromium

# Install necessary packages to fetch and run Chromium
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  nano \
  chromium \
  chromium-driver \
  ca-certificates \
  fonts-liberation \
  libappindicator3-1 \
  libasound2 \
  libatk-bridge2.0-0 \
  libatk1.0-0 \
  libc6 \
  libcairo2 \
  libcups2 \
  libdbus-1-3 \
  libexpat1 \
  libfontconfig1 \
  libgbm1 \
  libgcc1 \
  libglib2.0-0 \
  libgtk-3-0 \
  libnspr4 \
  libnss3 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libstdc++6 \
  libx11-6 \
  libx11-xcb1 \
  libxcb1 \
  libxcomposite1 \
  libxcursor1 \
  libxdamage1 \
  libxext6 \
  libxfixes3 \
  libxi6 \
  libxrandr2 \
  libxrender1 \
  libxss1 \
  libxtst6 \
  lsb-release \
  wget \
  xdg-utils && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*


# Set environment variables
ENV CHROME_DRIVER_PATH="/usr/bin/chromedriver"
ENV CHROME_BINARY_PATH="/usr/bin/chromium"

# Run main.rb when the container launches
CMD ["ruby", "main.rb"]
