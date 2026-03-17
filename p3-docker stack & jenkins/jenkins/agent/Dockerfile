FROM docker:29.1.5

# Instalacja narzędzi
RUN apk add --no-cache \
    openjdk21 \
    git \
    bash \
    openssh-client \
    curl \
    shadow \
    sudo \
    tar \
    grep \
    sed \
    coreutils

# 1. Tworzenie grupy i użytkownika jenkins (wymagane w Alpine)
RUN addgroup -S jenkins && adduser -S jenkins -G jenkins

# 2. Tworzenie workspace i nadanie uprawnień
WORKDIR /workspace
RUN chown -R jenkins:jenkins /workspace

# Przełączenie na użytkownika jenkins
# USER jenkins problem z uprawnieniami do dockera na agencie