FROM eclipse-temurin:11-jdk-focal

ENV CLOJURE_VERSION=1.11.1.1155

WORKDIR /tmp
RUN \
echo "nameserver 8.8.8.8" | tee /etc/resolv.conf > /dev/null && \
apt-get update && \
apt-get install -y curl make rlwrap wget && \
rm -rf /var/lib/apt/lists/* && \
wget https://download.clojure.org/install/linux-install-$CLOJURE_VERSION.sh && \
sha256sum linux-install-$CLOJURE_VERSION.sh && \
echo "28b1652686426cdf856f83551b8ca01ff949b03bc9a533d270204d6511a8ca9d *linux-install-$CLOJURE_VERSION.sh" | sha256sum -c - && \
chmod +x linux-install-$CLOJURE_VERSION.sh && \
./linux-install-$CLOJURE_VERSION.sh
RUN \
su vscode -c "clojure -e '(clojure-version)'" && \
rm ./linux-install-$CLOJURE_VERSION.sh

# Install Spacevim
RUN curl -sLf https://spacevim.org/install.sh | bash


# Install Lein
RUN \
wget https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein -O /bin/lein && \
chmod uog+x /bin/lein
RUN su vscode -c "/bin/lein"

# Cleanup
RUN apt-get purge -y --auto-remove curl wget

# ...
