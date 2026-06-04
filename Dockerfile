FROM nikolaik/python-nodejs:python3.10-nodejs20-bullseye

RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    build-essential \
    git \
    python3-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /app/downloads /app/cookies

COPY . /app/
WORKDIR /app/

# အရေးကြီးဆုံးအချက် - Pip ကို upgrade လုပ်ပြီးမှ install လုပ်ပါ
RUN pip3 install --no-cache-dir --upgrade pip setuptools wheel
RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["bash", "start"]
