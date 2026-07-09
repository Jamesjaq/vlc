# VLC Infinity Enhanced - Full Streaming Setup Guide

This guide covers the enhanced version of VLC Infinity that includes full movie streaming capabilities using TMDB, VidSrc, 2embed, and RapidCloud - just like MovieBox, Goojara, and similar sites.

---

## What's New in Enhanced Version

The enhanced version (`vlc-infinity-enhanced.lua`) includes:

✅ **TMDB Integration** - Browse millions of movies with metadata, posters, ratings
✅ **Multi-Source Streaming** - Automatic fallback between VidSrc, 2embed, and RapidCloud
✅ **Smart Stream Selection** - Checks stream health and picks the best available source
✅ **Favorites System** - Save your favorite movies for quick access
✅ **Watch History** - Track what you've watched
✅ **Geo-Blocking** - Block access in specific regions where not allowed
✅ **Settings Panel** - Configure API keys and preferences

---

## Installation

### Step 1: Download the Enhanced Extension

1. Download `vlc-infinity-enhanced.lua` from your GitHub repository
2. Save it to your VLC extensions directory:

**Windows:**
```
C:\Program Files\VideoLAN\VLC\lua\extensions\
or
%APPDATA%\vlc\lua\extensions\
```

**macOS:**
```
~/Library/Application Support/org.videolan.vlc/lua/extensions/
```

**Linux:**
```
~/.local/share/vlc/lua/extensions/
```

### Step 2: Get TMDB API Key (Required)

1. Visit https://www.themoviedb.org/settings/api
2. Create a free account
3. Request an API key
4. Copy your API key

### Step 3: Configure VLC Infinity Enhanced

1. Open VLC Media Player
2. Go to `View > VLC Infinity Enhanced`
3. Click `Settings`
4. Paste your TMDB API key
5. (Optional) Enter your region code for geo-blocking (e.g., "US", "UK", "IN")
6. Click `Save Settings`
7. Restart VLC

---

## How It Works

### Architecture

```
User Search
    ↓
TMDB API (Get movie metadata, IMDb ID)
    ↓
Streaming Link Resolver
    ├─ Try VidSrc.dev
    ├─ Try 2embed.org
    └─ Try RapidCloud
    ↓
Stream Health Check (Verify stream works)
    ↓
Play in VLC
    ↓
Save to History
```

### Step-by-Step Usage

1. **Search for a Movie**
   - Click `Search Movies`
   - Type a movie title (e.g., "The Matrix")
   - Click `Search`
   - Results appear with year and rating

2. **Play a Movie**
   - Select a movie from the list
   - Click `Play Movie`
   - VLC Infinity checks multiple streaming sources
   - Picks the best available stream
   - Movie starts playing

3. **Save to Favorites**
   - While browsing, click `Add to Favorites`
   - Movie is saved for quick access later

4. **Access Favorites**
   - Click `Favorites` from main menu
   - Select a saved movie
   - Click `Play Favorite`

5. **View Watch History**
   - Click `History` from main menu
   - See all recently watched movies
   - Click `Play from History` to replay
   - Click `Clear History` to reset

---

## Streaming Sources Explained

### VidSrc.dev (Primary)
- Most reliable free streaming source
- Aggregates from multiple providers
- Good uptime and stream quality
- URL: `https://vidsrc.dev/embed/movie/{imdb_id}`

### 2embed.org (Fallback 1)
- Alternative streaming aggregator
- Multiple source options
- Clean API
- URL: `https://www.2embed.org/embed/{imdb_id}`

### RapidCloud (Fallback 2)
- Additional streaming provider
- Fast streaming speeds
- URL: `https://rapidcloud.co/embed-{imdb_id}`

**How Fallback Works:**
If VidSrc is down or blocked, VLC Infinity automatically tries 2embed. If that fails, it tries RapidCloud. If all fail, you get an error message.

---

## Geo-Blocking Configuration

To restrict access in specific regions:

1. Go to `Settings`
2. Enter your region code (e.g., "US", "UK", "IN", "AU")
3. Click `Save Settings`

To block access in multiple regions, edit the config file directly:

**Windows:** `%APPDATA%\vlc-infinity-enhanced-config.json`
**macOS:** `~/Library/Application Support/org.videolan.vlc/vlc-infinity-enhanced-config.json`
**Linux:** `~/.local/share/vlc/vlc-infinity-enhanced-config.json`

Add to the JSON file:
```json
{
  "tmdb_api_key": "your_key_here",
  "user_region": "US",
  "enable_streaming": true,
  "geo_blocked_regions": ["US", "UK", "AU"]
}
```

---

## Data Storage

### Configuration File
- **Location:** VLC config directory
- **Filename:** `vlc-infinity-enhanced-config.json`
- **Contains:** TMDB API key, region, preferences

### Favorites File
- **Location:** VLC config directory
- **Filename:** `vlc-infinity-enhanced-favorites.json`
- **Contains:** Saved favorite movies with metadata

### History File
- **Location:** VLC config directory
- **Filename:** `vlc-infinity-enhanced-history.json`
- **Contains:** Last 100 watched movies with timestamps

---

## Features Explained

### Smart Stream Selection
VLC Infinity automatically:
1. Gets the IMDb ID from TMDB
2. Queries multiple streaming providers
3. Checks if each stream is accessible
4. Selects the first working stream
5. Falls back to next provider if needed

### Stream Health Checking
Before playing, VLC Infinity verifies:
- Stream URL is accessible
- No geographic restrictions
- Stream is not dead/offline
- Timeout after 5 seconds

### Favorites System
- Save unlimited favorite movies
- Favorites stored locally (no account needed)
- Quick access from main menu
- Remove favorites anytime

### Watch History
- Automatically tracks watched movies
- Shows provider used for each movie
- Keeps last 100 items
- Clear history anytime

---

## Troubleshooting

### "TMDB API key not configured"
**Solution:** Go to Settings and enter your TMDB API key

### "No working streams found"
**Possible causes:**
1. All streaming providers are down (rare)
2. Movie not available on any provider
3. Geographic restrictions
4. Internet connection issue

**Solution:**
- Try a different movie
- Check your internet connection
- Try again in a few minutes

### "Region blocked"
**Meaning:** VLC Infinity is not available in your configured region

**Solution:**
- Go to Settings
- Change or clear your region code
- Save and restart VLC

### Streams are slow/buffering
**Solution:**
1. Go to VLC Preferences
2. Navigate to Input / Codecs
3. Increase network caching (e.g., 5000 ms)
4. Restart VLC

### Movie not found in search
**Possible causes:**
1. Misspelled movie title
2. Very new or very old movie
3. Movie not in TMDB database

**Solution:**
- Try searching with just the movie name
- Try the year (e.g., "Matrix 1999")
- Search for similar movies

---

## Legal & Ethical Considerations

### Important Disclaimer

VLC Infinity Enhanced uses streaming sources (VidSrc, 2embed, RapidCloud) that aggregate content from multiple providers. While these services are accessible in many regions, they may host copyrighted content.

**Your Responsibility:**
- Ensure streaming is legal in your jurisdiction
- Respect copyright laws in your region
- Use geo-blocking to comply with local laws
- Do not distribute copyrighted content

**Recommended Usage:**
- Use in regions where it's legally permitted
- Enable geo-blocking for restricted regions
- Respect content creators' rights
- Consider supporting official streaming services

---

## Advanced Configuration

### Modify Streaming Providers

Edit `vlc-infinity-enhanced.lua` to add or remove providers:

```lua
local STREAMING_PROVIDERS = {
    {
        name = "VidSrc",
        url_pattern = "https://vidsrc.dev/embed/movie/{imdb_id}",
        priority = 1,
        type = "embed"
    },
    -- Add more providers here
}
```

### Enable/Disable Streaming

In the config file, set:
```json
{
  "enable_streaming": false
}
```

### Change Provider Priority

Modify the `priority` value (lower = higher priority):
```lua
{
    name = "2embed",
    priority = 1,  -- Try this first
    ...
}
```

---

## Performance Tips

1. **Cache TMDB Results:** Search results are cached locally
2. **Stream Health Check:** Takes 1-2 seconds per provider
3. **Network Caching:** Increase in VLC settings for smoother playback
4. **Fallback Providers:** Multiple sources ensure availability

---

## Frequently Asked Questions

**Q: Is this legal?**
A: It depends on your jurisdiction. VLC Infinity Enhanced is a tool. Users are responsible for ensuring their use complies with local laws.

**Q: Can I use this on mobile?**
A: VLC for Android has limited Lua extension support. Desktop versions (Windows, macOS, Linux) have full support.

**Q: Do I need an account?**
A: No. Favorites and history are stored locally. No account or login required.

**Q: Can I add custom streaming sources?**
A: Yes. Edit the `STREAMING_PROVIDERS` table in `vlc-infinity-enhanced.lua`

**Q: What if a stream is blocked in my country?**
A: Use geo-blocking in Settings to restrict access, or use a VPN (at your own risk).

**Q: How often are streaming links updated?**
A: VLC Infinity queries providers in real-time, so links are always current.

**Q: Can I export my favorites?**
A: Yes. Copy the `vlc-infinity-enhanced-favorites.json` file to another device.

---

## Support & Feedback

- **GitHub Repository:** https://github.com/Jamesjaq/vlc/tree/vlc-infinity
- **Report Issues:** Open an issue on GitHub
- **Request Features:** Discuss on GitHub

---

## Comparison: Original vs Enhanced

| Feature | Original | Enhanced |
|---------|----------|----------|
| IPTV Channels | ✅ | ✅ |
| Movie Browsing | ✅ Internet Archive | ✅ TMDB (Millions) |
| Streaming | Limited | ✅ VidSrc, 2embed, RapidCloud |
| Search | ✅ | ✅ |
| Favorites | ✅ | ✅ |
| History | ✅ | ✅ |
| Geo-Blocking | ❌ | ✅ |
| TMDB Integration | ❌ | ✅ |
| Settings | ❌ | ✅ |

---

## Next Steps

1. **Install** the enhanced version
2. **Get TMDB API key** from themoviedb.org
3. **Configure** in VLC Infinity Settings
4. **Search** for your favorite movies
5. **Enjoy** streaming!

---

## Version History

### v0.2 (Enhanced)
- TMDB integration for movie metadata
- Multi-source streaming (VidSrc, 2embed, RapidCloud)
- Geo-blocking support
- Settings panel
- Improved UI

### v0.1 (Original)
- IPTV channel browsing
- Internet Archive movies
- Favorites and history
- Basic search

---

**Enjoy streaming with VLC Infinity Enhanced!** 🎬📺
