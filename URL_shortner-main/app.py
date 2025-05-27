from fastapi import FastAPI, HTTPException
from fastapi.responses import RedirectResponse
from fastapi.staticfiles import StaticFiles
from fastapi.responses import FileResponse
from pydantic import BaseModel
import redis
import secrets
import string
import os

app = FastAPI(title="URL Shortener")

# Mount static files
app.mount("/static", StaticFiles(directory="static"), name="static")

# Initialize Redis connection
redis_client = redis.Redis(
    host=os.getenv('REDIS_HOST', 'redis'),
    port=int(os.getenv('REDIS_PORT', 6379)),
    db=0
)

class URLRequest(BaseModel):
    long_url: str

def generate_short_code(length: int = 6) -> str:
    """Generate a random short code for the URL."""
    alphabet = string.ascii_letters + string.digits
    return ''.join(secrets.choice(alphabet) for _ in range(length))

@app.get("/")
async def root():
    """Serve the main page."""
    return FileResponse("static/index.html")

@app.post("/shorten")
async def shorten_url(url_request: URLRequest):
    """Create a short URL for the given long URL."""
    if not url_request.long_url:
        raise HTTPException(status_code=400, detail="URL cannot be empty")
    
    # Generate a unique short code
    short_code = generate_short_code()
    
    # Store the mapping in Redis
    redis_client.set(short_code, url_request.long_url)
    
    # Return the short URL
    return {"short_url": f"/{short_code}"}

@app.get("/{short_code}")
async def redirect_to_url(short_code: str):
    """Redirect to the original URL using the short code."""
    # Get the long URL from Redis
    long_url = redis_client.get(short_code)
    
    if not long_url:
        raise HTTPException(status_code=404, detail="URL not found")
    
    # Redirect to the original URL
    return RedirectResponse(url=long_url.decode('utf-8')) 