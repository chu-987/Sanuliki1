import asyncio, httpx, os, random, yt_dlp
import config
from typing import Union
from pyrogram.types import Message
from pyrogram.enums import MessageEntityType
from youtubesearchpython.__future__ import VideosSearch

# 1. Cookies ဖိုင်ကို ရှာဖွေခြင်း
def cookie_txt_file():
    cookie_dir = "cookies"
    if not os.path.exists(cookie_dir): return None
    cookies_files = [f for f in os.listdir(cookie_dir) if f.endswith(".txt")]
    return os.path.join(cookie_dir, random.choice(cookies_files)) if cookies_files else None

# 2. API မှ URL ယူခြင်း
async def get_stream_url_from_api(query, video=False):
    endpoint = "/video" if video else "/audio"
    api_url = f"{config.API_URL}{endpoint}"
    params = {"url": query, "api_key": config.API_KEY}
    try:
        async with httpx.AsyncClient(timeout=10) as client:
            response = await client.get(api_url, params=params)
            if response.status_code == 200:
                data = response.json()
                return data.get("result", {}).get("url") if data.get("status") else None
    except: return None
    return None

# 3. Cookies + yt-dlp ဖြင့် ဒေါင်းခြင်း (Backup Mode)
async def download_with_cookies(link, video=False):
    cookie_file = cookie_txt_file()
    if not cookie_file: return None
    
    loop = asyncio.get_running_loop()
    def ytdlp_download():
        ydl_opts = {
            "format": "bestvideo+bestaudio/best" if video else "bestaudio/best",
            "outtmpl": "downloads/%(id)s.%(ext)s",
            "cookiefile": cookie_file,
            "quiet": True,
        }
        with yt_dlp.YoutubeDL(ydl_opts) as ydl:
            info = ydl.extract_info(link, download=True)
            return os.path.join("downloads", f"{info['id']}.{info['ext']}")
    
    return await loop.run_in_executor(None, ytdlp_download)

class YouTubeAPI:
    def __init__(self):
        self.base = "https://www.youtube.com/watch?v="

    # --- Error ဖြစ်နေတဲ့ url method ကို ပြန်ထည့်ပေးထားပါတယ် ---
    async def url(self, message_1: Message) -> Union[str, None]:
        messages = [message_1]
        if message_1.reply_to_message:
            messages.append(message_1.reply_to_message)
        text = ""
        offset = None
        length = None
        for message in messages:
            if offset: break
            if message.entities:
                for entity in message.entities:
                    if entity.type == MessageEntityType.URL:
                        text = message.text or message.caption
                        offset, length = entity.offset, entity.length
                        break
            elif message.caption_entities:
                for entity in message.caption_entities:
                    if entity.type == MessageEntityType.TEXT_LINK:
                        return entity.url
        if offset is None: return None
        return text[offset : offset + length]

    async def download(self, link, mystic, video=None, **kwargs) -> str:
        # Step 1: Try API First
        downloaded_file = await get_stream_url_from_api(link, video)
        
        # Step 2: Fallback to Cookies if API fails
        if not downloaded_file:
            print("API Fail ဖြစ်သည်၊ Cookies သုံးပြီး ဒေါင်းနေသည်...")
            downloaded_file = await download_with_cookies(link, video)
            
        return downloaded_file, True
