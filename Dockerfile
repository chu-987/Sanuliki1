FROM nikolaik/python-nodejs:python3.10-nodejs20-bullseye

# လိုအပ်တဲ့ build tools တွေကို install လုပ်ပါ
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    build-essential \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# အဓိကအချက်: Bot အတွက် လိုအပ်တဲ့ Folder တွေကို ကြိုတင်ဆောက်ပေးထားပါ
RUN mkdir -p /app/downloads /app/cookies

COPY . /app/
WORKDIR /app/

# Pip ကို အရင်ဆုံး Upgrade လုပ်ပြီးမှ library တွေကို သွင်းပါ
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir -U -r requirements.txt

CMD ["bash", "start"]
