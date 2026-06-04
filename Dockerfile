FROM nikolaik/python-nodejs:python3.10-nodejs20-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/downloads /app/cookies

COPY . /app/
WORKDIR /app/

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["bash", "start"]
