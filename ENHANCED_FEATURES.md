# VLC Infinity Enhanced Features - Implementation Guide

This guide provides code examples and instructions for adding advanced movie streaming features to VLC Infinity using TMDB API and streaming link providers.

---

## Feature 1: TMDB Integration for Movie Metadata

### Why TMDB?
- Free API with comprehensive movie database
- High-quality posters and metadata
- IMDb IDs for linking to streaming providers
- Ratings, genres, release dates, and cast information

### Setup

1. **Get TMDB API Key:**
   - Visit https://www.themoviedb.org/settings/api
   - Sign up for free account
   - Generate API key
   - Add to VLC Infinity configuration

2. **Add to VLC Infinity:**

```lua
-- Configuration
local TMDB_API_KEY = "YOUR_TMDB_API_KEY"  -- User provides this
local TMDB_BASE_URL = "https://api.themoviedb.org/3"

-- Search movies on TMDB
local function search_tmdb_movies(query, page)
    page = page or 1
    local url = TMDB_BASE_URL .. "/search/movie?api_key=" .. TMDB_API_KEY .. 
                "&query=" .. vlc.strings.url_encode(query) .. 
                "&page=" .. page
    
    vlc.msg.info("VLC Infinity: Searching TMDB for: " .. query)
    local json_content = fetch_url(url)
    
    if json_content then
        local data = vlc.json.decode(json_content)
        if data and data.results then
            return data.results
        end
    end
    return nil
end

-- Get detailed movie info
local function get_tmdb_movie_details(movie_id)
    local url = TMDB_BASE_URL .. "/movie/" .. movie_id .. 
                "?api_key=" .. TMDB_API_KEY .. 
                "&append_to_response=external_ids"
    
    local json_content = fetch_url(url)
    if json_content then
        return vlc.json.decode(json_content)
    end
    return nil
end

-- Get poster URL
local function get_tmdb_poster_url(poster_path)
    if poster_path then
        return "https://image.tmdb.org/t/p/w500" .. poster_path
    end
    return nil
end
```

---

## Feature 2: Multi-Source Streaming Link Resolution

### How It Works
1. User searches for a movie
2. VLC Infinity finds it on TMDB (gets IMDb ID)
3. VLC Infinity queries multiple streaming providers
4. Returns list of available streams with quality/source info
5. User selects preferred source
6. VLC plays the stream

### Implementation

```lua
-- Streaming providers configuration
local STREAMING_PROVIDERS = {
    {
        name = "VidSrc",
        embed_url = "https://vidsrc.dev/embed/movie/{imdb_id}",
        direct_url = "https://vidsrc.dev/embed/movie/{imdb_id}",
        priority = 1
    },
    {
        name = "2embed",
        embed_url = "https://www.2embed.org/embed/{imdb_id}",
        direct_url = "https://www.2embed.org/embed/{imdb_id}",
        priority = 2
    },
    {
        name = "RapidCloud",
        embed_url = "https://rapidcloud.co/embed-{imdb_id}",
        direct_url = "https://rapidcloud.co/embed-{imdb_id}",
        priority = 3
    }
}

-- Get streaming links for a movie
local function get_streaming_links(imdb_id)
    local links = {}
    
    for i, provider in ipairs(STREAMING_PROVIDERS) do
        local url = provider.direct_url:gsub("{imdb_id}", imdb_id)
        
        table.insert(links, {
            provider = provider.name,
            url = url,
            priority = provider.priority,
            healthy = false  -- Will be checked later
        })
    end
    
    return links
end

-- Check stream health and get best available
local function get_best_streaming_link(imdb_id)
    local links = get_streaming_links(imdb_id)
    
    -- Sort by priority
    table.sort(links, function(a, b) return a.priority < b.priority end)
    
    -- Check each link's health
    for i, link in ipairs(links) do
        vlc.msg.info("VLC Infinity: Checking " .. link.provider .. " stream...")
        
        if check_stream_health(link.url) then
            vlc.msg.info("VLC Infinity: Found working stream on " .. link.provider)
            link.healthy = true
            return link
        end
    end
    
    vlc.msg.warn("VLC Infinity: No working streams found")
    return nil
end
```

---

## Feature 3: Advanced Movie Browser with TMDB

```lua
-- Enhanced movie browser with TMDB
local function browse_tmdb_movies_dialog(search_query, genre_filter, page)
    search_query = search_query or ""
    page = page or 1
    genre_filter = genre_filter or ""
    
    main_dlg:clear()
    main_dlg:add_label("Search Movies (TMDB):", 1, 1, 8, 1)
    
    local search_input = main_dlg:add_text_input(search_query, 1, 2, 8, 1)
    local search_button = main_dlg:add_button("Search", function()
        local query = search_input:get_text()
        browse_tmdb_movies_dialog(query, genre_filter, 1)
    end, 1, 3, 4, 1)
    
    local next_button = main_dlg:add_button("Next Page", function()
        browse_tmdb_movies_dialog(search_query, genre_filter, page + 1)
    end, 5, 3, 4, 1)
    
    -- Fetch movies from TMDB
    local movies = search_tmdb_movies(search_query, page)
    
    if movies and #movies > 0 then
        main_dlg:add_label("Results (" .. #movies .. " found):", 1, 4, 8, 1)
        
        local movie_dropdown = main_dlg:add_dropdown(1, 5, 8, 1)
        local selected_movie_index = 0
        
        for i, movie in ipairs(movies) do
            local title = movie.title
            if movie.release_date then
                title = title .. " (" .. movie.release_date:sub(1, 4) .. ")"
            end
            movie_dropdown:add_value(title, i)
        end
        
        movie_dropdown:set_callback(function(index, value)
            selected_movie_index = index
        end)
        
        main_dlg:add_button("Play", function()
            if selected_movie_index > 0 and movies[selected_movie_index] then
                local movie = movies[selected_movie_index]
                local details = get_tmdb_movie_details(movie.id)
                
                if details and details.external_ids and details.external_ids.imdb_id then
                    local imdb_id = details.external_ids.imdb_id
                    local stream = get_best_streaming_link(imdb_id)
                    
                    if stream then
                        vlc.msg.info("Playing: " .. movie.title)
                        vlc.playlist.add({ { path = stream.url, name = movie.title } })
                        vlc.playlist.play()
                        
                        -- Save to history
                        table.insert(watch_history, {
                            name = movie.title,
                            url = stream.url,
                            source = stream.provider,
                            type = "movie",
                            timestamp = os.time()
                        })
                        save_data(history_file, watch_history)
                    else
                        vlc.msg.err("No working streams found for: " .. movie.title)
                    end
                end
            end
        end, 1, 6, 8, 1)
        
        main_dlg:add_label("Powered by TMDB", 1, 7, 8, 1)
    else
        main_dlg:add_label("No movies found. Try a different search.", 1, 4, 8, 1)
    end
    
    main_dlg:show()
end
```

---

## Feature 4: User Configuration for API Keys

```lua
-- Configuration file for user settings
local config_file = vlc.config.path() .. "vlc-infinity-config.json"

local function load_config()
    local file = vlc.io.open(config_file, "r")
    if file then
        local content = file:read()
        file:close()
        return vlc.json.decode(content)
    end
    return {
        tmdb_api_key = "",
        preferred_streaming_provider = "VidSrc",
        enable_tmdb = false
    }
end

local function save_config(config)
    local file = vlc.io.open(config_file, "w")
    if file then
        file:write(vlc.json.encode(config))
        file:close()
        return true
    end
    return false
end

-- Settings dialog
local function settings_dialog()
    main_dlg:clear()
    main_dlg:add_label("VLC Infinity Settings", 1, 1, 8, 1)
    
    local config = load_config()
    
    main_dlg:add_label("TMDB API Key:", 1, 2, 8, 1)
    local api_key_input = main_dlg:add_text_input(config.tmdb_api_key or "", 1, 3, 8, 1)
    
    main_dlg:add_label("Get free API key at: https://www.themoviedb.org/settings/api", 1, 4, 8, 1)
    
    main_dlg:add_button("Save Settings", function()
        config.tmdb_api_key = api_key_input:get_text()
        config.enable_tmdb = true
        save_config(config)
        vlc.msg.info("VLC Infinity: Settings saved!")
    end, 1, 5, 8, 1)
    
    main_dlg:show()
end
```

---

## Feature 5: Integrated Search (IPTV + TMDB Movies)

```lua
-- Universal search across all sources
local function universal_search_dialog()
    main_dlg:clear()
    main_dlg:add_label("Universal Search", 1, 1, 8, 1)
    
    local search_input = main_dlg:add_text_input("", 1, 2, 8, 1)
    local search_button = main_dlg:add_button("Search", function()
        local query = search_input:get_text()
        
        -- Search IPTV channels
        local channels = search_iptv_channels(query)
        
        -- Search TMDB movies
        local config = load_config()
        local movies = nil
        if config.enable_tmdb and config.tmdb_api_key ~= "" then
            TMDB_API_KEY = config.tmdb_api_key
            movies = search_tmdb_movies(query)
        end
        
        -- Display results
        display_universal_search_results(channels, movies)
    end, 1, 3, 8, 1)
    
    main_dlg:show()
end

local function display_universal_search_results(channels, movies)
    main_dlg:clear()
    main_dlg:add_label("Search Results", 1, 1, 8, 1)
    
    local row = 2
    
    if channels and #channels > 0 then
        main_dlg:add_label("IPTV Channels (" .. #channels .. "):", 1, row, 8, 1)
        row = row + 1
        
        local channel_dropdown = main_dlg:add_dropdown(1, row, 8, 1)
        for i, channel in ipairs(channels) do
            channel_dropdown:add_value(channel.name, i)
        end
        row = row + 1
        
        main_dlg:add_button("Play Channel", function()
            -- Play selected channel
        end, 1, row, 4, 1)
        row = row + 1
    end
    
    if movies and #movies > 0 then
        main_dlg:add_label("Movies (" .. #movies .. "):", 1, row, 8, 1)
        row = row + 1
        
        local movie_dropdown = main_dlg:add_dropdown(1, row, 8, 1)
        for i, movie in ipairs(movies) do
            movie_dropdown:add_value(movie.title, i)
        end
        row = row + 1
        
        main_dlg:add_button("Play Movie", function()
            -- Play selected movie
        end, 1, row, 4, 1)
    end
    
    main_dlg:show()
end
```

---

## Feature 6: Quality and Source Selection

```lua
-- Allow users to select preferred streaming source
local function play_movie_with_source_selection(movie)
    local imdb_id = movie.external_ids.imdb_id
    local links = get_streaming_links(imdb_id)
    
    main_dlg:clear()
    main_dlg:add_label("Select Streaming Source:", 1, 1, 8, 1)
    
    local source_dropdown = main_dlg:add_dropdown(1, 2, 8, 1)
    
    for i, link in ipairs(links) do
        source_dropdown:add_value(link.provider, i)
    end
    
    main_dlg:add_button("Play", function()
        local selected = source_dropdown:get_selection()
        if selected > 0 and links[selected] then
            local link = links[selected]
            vlc.playlist.add({ { path = link.url, name = movie.title } })
            vlc.playlist.play()
        end
    end, 1, 3, 4, 1)
    
    main_dlg:add_button("Cancel", function()
        main_dlg:hide()
    end, 5, 3, 4, 1)
    
    main_dlg:show()
end
```

---

## Integration Checklist

- [ ] Add TMDB API integration
- [ ] Implement streaming link resolution
- [ ] Add user settings dialog for API keys
- [ ] Create enhanced movie browser
- [ ] Add universal search functionality
- [ ] Implement source selection UI
- [ ] Add error handling for failed streams
- [ ] Test with multiple streaming providers
- [ ] Document TMDB API setup
- [ ] Add legal disclaimers

---

## Legal Considerations

**Important:** Before implementing streaming link resolution:

1. **Check Local Laws:** Copyright laws vary by jurisdiction
2. **Review ToS:** Streaming providers may have usage restrictions
3. **Consider Alternatives:** Focus on legal sources (public domain, Creative Commons)
4. **Add Disclaimers:** Inform users about legal responsibilities
5. **Consult Legal:** For production use, consult with legal counsel

---

## Resources

- **TMDB API Documentation:** https://developer.themoviedb.org/docs
- **TMDB API Key:** https://www.themoviedb.org/settings/api
- **VidSrc.dev:** https://vidsrc.dev/
- **2embed.org:** https://www.2embed.org/
- **Lua Documentation:** https://www.lua.org/manual/5.1/

---

## Next Steps

1. Get TMDB API key from https://www.themoviedb.org/settings/api
2. Add configuration dialog to VLC Infinity
3. Implement TMDB search functionality
4. Add streaming link resolution
5. Test with various movies
6. Add error handling and fallbacks
7. Document for users
8. Consider legal implications

---

## Support

For questions or issues with implementation, refer to:
- VLC Lua API Documentation
- TMDB API Documentation
- GitHub Issues on the VLC Infinity repository
