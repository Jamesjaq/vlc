# Movie Streaming Sources Guide for VLC Infinity

This guide explains where popular streaming sites like MovieBox, Goojara, FlixMomo, and WatchSoMuch get their movies, and how we can integrate similar sources into VLC Infinity for browsing and streaming.

---

## How Streaming Aggregator Sites Work

Sites like MovieBox, Goojara, FlixMomo, and WatchSoMuch use a **two-layer architecture**:

### Layer 1: Movie Metadata (What to watch)
These sites fetch movie information from:
- **TMDB (The Movie Database)** - Free API with movie details, posters, ratings
- **IMDb** - Movie information (limited free access)
- **OMDb** - IMDb wrapper API
- **Custom scrapers** - Crawling other sites for metadata

### Layer 2: Streaming Links (How to watch)
These sites aggregate streaming links from:
- **VidSrc.dev** - Popular free streaming link provider
- **RapidCloud** - Streaming embed provider
- **2embed.org** - Movie/TV embed API
- **VidCloud.stream** - Video streaming service
- **StreamTape** - File hosting with streaming
- **Custom scrapers** - Scraping other streaming sites

---

## Major Streaming Link Providers

### 1. VidSrc.dev (Most Popular)
**What it is:** A free API that aggregates streaming links from multiple sources
**How it works:** 
- Searches multiple streaming providers
- Returns playable stream URLs
- Supports movies and TV shows
- No authentication required

**API Endpoint:**
```
https://vidsrc.dev/embed/movie/{imdb_id}
https://vidsrc.dev/embed/tv/{imdb_id}/{season}/{episode}
```

**Example:**
```
https://vidsrc.dev/embed/movie/tt0111161  # The Shawshank Redemption
```

**Pros:**
- Free to use
- Reliable streaming links
- Good uptime
- Supports both movies and TV

**Cons:**
- May have ads or popups
- Links may be region-restricted
- Quality varies by source

---

### 2. 2embed.org
**What it is:** Movie and TV show embed API
**How it works:**
- Provides embed codes and direct links
- Aggregates from multiple sources
- RESTful API

**API Endpoint:**
```
https://www.2embed.org/embed/{imdb_id}
https://www.2embed.org/api/embedlinks/{imdb_id}
```

**Pros:**
- Clean API
- Multiple source options
- Good documentation

**Cons:**
- Some sources may be unreliable
- Rate limiting possible

---

### 3. RapidCloud
**What it is:** Streaming embed provider
**How it works:**
- Hosts streaming embeds
- Used by many aggregator sites
- Direct streaming links

**Endpoint:**
```
https://rapidcloud.co/embed-{imdb_id}
```

**Pros:**
- Fast streaming
- Reliable uptime

**Cons:**
- May have geographic restrictions
- Quality dependent on source

---

### 4. StreamTape
**What it is:** File hosting with streaming capabilities
**How it works:**
- Users upload files
- Provides streaming URLs
- Direct download links

**Pros:**
- Direct file hosting
- No ads on direct links
- Reliable

**Cons:**
- Limited free movie library
- Requires file uploads

---

## Movie Metadata Sources

### TMDB (The Movie Database)
**Best for:** Movie information, posters, ratings, genres

**API:**
```
https://api.themoviedb.org/3/search/movie?api_key=YOUR_KEY&query=movie_name
```

**Features:**
- Free API key (register at themoviedb.org)
- 40 requests per 10 seconds
- Comprehensive movie database
- High-quality posters and metadata

**Example Response:**
```json
{
  "results": [
    {
      "id": 278,
      "title": "The Shawshank Redemption",
      "poster_path": "/q6y0Go1TSGaFvLY9l2yL2IData.jpg",
      "release_date": "1994-09-23",
      "overview": "...",
      "genres": [...]
    }
  ]
}
```

### IMDb
**Best for:** Ratings, reviews, detailed information

**Note:** IMDb doesn't have a free official API, but:
- TMDB includes IMDb IDs
- OMDb provides IMDb data (limited free tier)
- IMDb data can be scraped (with limitations)

---

## How MovieBox, Goojara, and Similar Sites Work

### Example: MovieBox.ph
1. **User searches for a movie** → "The Shawshank Redemption"
2. **Site queries TMDB API** → Gets movie info, poster, IMDb ID
3. **Site queries VidSrc or 2embed** → Gets streaming links
4. **Site displays results** with play button
5. **User clicks play** → Streams from VidSrc or other provider

### Example: Goojara.to
1. Similar process but may use:
   - Custom scrapers for additional sources
   - RapidCloud for embeds
   - Multiple fallback providers
2. Focuses on UI/UX for discovery
3. Aggregates from 5-10 different streaming sources

---

## Integrating into VLC Infinity

### Architecture for Enhanced VLC Infinity

```
┌─────────────────────────────────────────────┐
│         VLC Infinity Extension              │
├─────────────────────────────────────────────┤
│  1. Search Interface (User Input)           │
│  2. TMDB API (Movie Metadata)               │
│  3. Streaming Link Resolver                 │
│     ├─ VidSrc.dev                          │
│     ├─ 2embed.org                          │
│     ├─ RapidCloud                          │
│     └─ Fallback providers                  │
│  4. VLC Playlist Integration                │
│  5. Playback & History                      │
└─────────────────────────────────────────────┘
```

### Implementation Steps

#### Step 1: Add TMDB Integration
```lua
local function search_movies_tmdb(query)
    local api_key = "YOUR_TMDB_API_KEY"  -- Get from themoviedb.org
    local url = "https://api.themoviedb.org/3/search/movie?api_key=" .. api_key .. 
                "&query=" .. vlc.strings.url_encode(query)
    
    local json_content = fetch_url(url)
    if json_content then
        local data = vlc.json.decode(json_content)
        return data.results  -- Returns array of movies with metadata
    end
    return nil
end
```

#### Step 2: Add Streaming Link Resolution
```lua
local function get_streaming_links(imdb_id)
    local links = {}
    
    -- Try VidSrc.dev
    table.insert(links, {
        provider = "VidSrc",
        url = "https://vidsrc.dev/embed/movie/" .. imdb_id
    })
    
    -- Try 2embed.org
    table.insert(links, {
        provider = "2embed",
        url = "https://www.2embed.org/embed/" .. imdb_id
    })
    
    -- Try RapidCloud
    table.insert(links, {
        provider = "RapidCloud",
        url = "https://rapidcloud.co/embed-" .. imdb_id
    })
    
    return links
end
```

#### Step 3: Add Fallback Logic
```lua
local function play_movie_with_fallback(movie)
    local links = get_streaming_links(movie.imdb_id)
    
    for i, link in ipairs(links) do
        if check_stream_health(link.url) then
            vlc.msg.info("Playing from " .. link.provider)
            vlc.playlist.add({ { path = link.url, name = movie.title } })
            vlc.playlist.play()
            return true
        end
    end
    
    vlc.msg.err("No working streams found for " .. movie.title)
    return false
end
```

---

## Legal and Ethical Considerations

### Important Notes

1. **Copyright:** Most streaming links from VidSrc, 2embed, etc. may host copyrighted content. Using them may violate copyright laws depending on your jurisdiction.

2. **Terms of Service:** 
   - TMDB API is free but has usage terms
   - Streaming providers may have ToS restrictions
   - Check local laws before implementation

3. **Alternatives for Legal Streaming:**
   - **Public Domain:** Internet Archive (already integrated)
   - **Creative Commons:** Free licensed movies
   - **Official APIs:** Netflix, Amazon Prime, Disney+ (require authentication)
   - **Open Source:** Pluto TV, Tubi, Crackle APIs

4. **Recommendation:** For a production extension, focus on:
   - Public domain content (Internet Archive)
   - Creative Commons licensed content
   - Official streaming service APIs
   - User-provided content

---

## Alternative Legal Streaming Sources

### 1. Pluto TV API
**What it is:** Free, ad-supported streaming service
**Content:** Movies, TV shows, live channels
**API:** Limited public API, but can scrape channel listings

### 2. Tubi API
**What it is:** Free streaming with ads
**Content:** Movies and TV shows
**Note:** No official API, but content is publicly available

### 3. Open Culture
**What it is:** Curated collection of free movies
**Content:** Documentaries, indie films, classics
**Format:** Direct links to streaming sources

### 4. Criterion Channel (Limited Free)
**What it is:** Curated film collection
**Content:** Art house and independent films
**Note:** Requires subscription for most content

---

## Building a Legal Movie Aggregator for VLC Infinity

### Recommended Approach

```lua
-- Combine multiple legal sources
local function search_all_legal_sources(query)
    local results = {}
    
    -- 1. Internet Archive (Public Domain)
    local ia_results = search_internet_archive(query)
    for i, movie in ipairs(ia_results) do
        table.insert(results, {
            title = movie.title,
            source = "Internet Archive (Public Domain)",
            url = movie.url,
            legal = true
        })
    end
    
    -- 2. Open Culture
    local oc_results = search_open_culture(query)
    for i, movie in ipairs(oc_results) do
        table.insert(results, {
            title = movie.title,
            source = "Open Culture",
            url = movie.url,
            legal = true
        })
    end
    
    -- 3. Creative Commons
    local cc_results = search_creative_commons(query)
    for i, movie in ipairs(cc_results) do
        table.insert(results, {
            title = movie.title,
            source = "Creative Commons",
            url = movie.url,
            legal = true
        })
    end
    
    return results
end
```

---

## Summary: Where MovieBox, Goojara Get Movies

| Component | Source |
|-----------|--------|
| **Movie Info** | TMDB API, IMDb scraping |
| **Streaming Links** | VidSrc.dev, 2embed.org, RapidCloud, custom scrapers |
| **User Interface** | Custom web/app development |
| **Aggregation** | Combining multiple sources with fallbacks |

---

## Next Steps for VLC Infinity

### Option 1: Legal Implementation
Integrate public domain and Creative Commons content:
- Expand Internet Archive integration
- Add Open Culture API
- Add Creative Commons search
- Focus on documentaries and indie films

### Option 2: Metadata + User Streams
Allow users to provide their own streaming links:
- Search TMDB for metadata
- Users paste streaming URLs
- VLC Infinity manages playback and history

### Option 3: Official APIs
Integrate with legal streaming services:
- Pluto TV (free, ad-supported)
- Tubi (free, ad-supported)
- YouTube Movies (some free content)

---

## Resources

- **TMDB API:** https://www.themoviedb.org/settings/api
- **VidSrc.dev:** https://vidsrc.dev/
- **2embed.org:** https://www.2embed.org/
- **Internet Archive:** https://archive.org/
- **Open Culture:** https://www.openculture.com/
- **Creative Commons:** https://creativecommons.org/

---

## Disclaimer

This guide is for educational purposes. Users are responsible for ensuring their use of streaming sources complies with local laws and copyright regulations. VLC Infinity developers are not responsible for how users utilize streaming links or APIs.

For production implementations, consult with legal counsel regarding copyright and licensing requirements.
