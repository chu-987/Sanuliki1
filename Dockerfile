FROM nikolaik/python-nodejs:python3.10-nodejs20-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    build-essential \
    git \
    python3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY . /app/

RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel
# အောက်ပါအတိုင်း install လုပ်ပါ
RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["bash", "start"]
