FROM alpine

RUN apk add wget ca-certificates
RUN apk add openjdk8-jre bash git python3 libxslt-dev libxml2-dev openssl-dev musl-dev libffi libffi-dev python3-dev gcc

WORKDIR /tmp

RUN wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool \
    && chmod +x apktool \
    && mv apktool /usr/local/bin/apktool
    
RUN wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.4.0.jar \
    && chmod +x apktool_2.4.0.jar \
    && mv apktool_2.4.0.jar /usr/local/bin/apktool.jar

RUN wget https://github.com/skylot/jadx/releases/download/v0.9.0/jadx-0.9.0.zip \
    && unzip jadx-0.9.0.zip \
    && cp -r bin/ /usr/local/ \
    && cp -r lib/ /usr/local/

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install gplaycli
