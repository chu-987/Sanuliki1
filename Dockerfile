FROM nikolaik/python-nodejs:python3.10-nodejs20-bullseye

# လိုအပ်သော Build Tools များနှင့် စနစ်လိုအပ်ချက်များအားလုံးကို ထည့်သွင်းခြင်း
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    build-essential \
    git \
    python3-dev \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Bot အလုပ်လုပ်ရန် လိုအပ်သော Folder များ ဆောက်လုပ်ခြင်း
RUN mkdir -p /app/downloads /app/cookies

COPY . /app/
WORKDIR /app/

# Pip နှင့် လိုအပ်သော Library များကို သွင်းခြင်း
RUN pip3 install --upgrade pip
RUN pip3 install --no-cache-dir -U -r requirements.txt

# Bot စတင်ခြင်း
CMD ["bash", "start"]
