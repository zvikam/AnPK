FROM alpine

ARG APKTOOL_VERSION=2.4.1
ARG JADX_VERSION=1.1.0

RUN apk update
RUN apk add wget ca-certificates
RUN apk add openjdk8-jre bash git python3 libxslt-dev libxml2-dev openssl-dev musl-dev libffi libffi-dev python3-dev gcc py-pip

WORKDIR /tmp

RUN wget https://raw.githubusercontent.com/iBotPeaches/Apktool/master/scripts/linux/apktool \
    && chmod +x apktool \
    && mv apktool /usr/local/bin/apktool
    
RUN wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_$APKTOOL_VERSION.jar \
    && chmod +x apktool_$APKTOOL_VERSION.jar \
    && mv apktool_$APKTOOL_VERSION.jar /usr/local/bin/apktool.jar

RUN wget https://github.com/skylot/jadx/releases/download/v$JADX_VERSION/jadx-$JADX_VERSION.zip \
    && unzip jadx-$JADX_VERSION.zip \
    && cp -r bin/ /usr/local/ \
    && cp -r lib/ /usr/local/ \
    && rm -r /tmp/*

RUN python3 -m pip install --upgrade pip wheel
RUN python3 -m pip install gplaycli
RUN python3 -m pip install validators

COPY gitGraber /gitGraber
RUN pip3 install -r /gitGraber/requirements.txt

COPY bootstrap.sh /
RUN chmod +x /bootstrap.sh

ENTRYPOINT ["/bootstrap.sh"]
