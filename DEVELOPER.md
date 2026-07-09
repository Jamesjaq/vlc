# VLC Infinity Developer Guide

This guide provides information for developers who want to extend, modify, or contribute to the VLC Infinity Lua extension.

---

## Project Structure

```
vlc-infinity/
├── share/lua/extensions/
│   └── vlc-infinity.lua          # Main extension file
├── README.md                      # Project overview
├── INSTALLATION.md                # Installation guide for all platforms
├── USAGE.md                       # User guide
├── QUICKSTART.md                  # Quick start guide
├── DEVELOPER.md                   # This file
├── install.sh                     # Installation script for Linux/macOS
└── todo.md                        # Project todo list
```

---

## Core Architecture

### Main Components

The `vlc-infinity.lua` extension consists of the following key components:

#### 1. **Descriptor Function**
```lua
function descriptor()
    return {
        title = "VLC Infinity",
        version = "0.1",
        author = "Manus AI",
        url = "https://github.com/Jamesjaq/vlc",
        description = "Advanced VLC plugin for free cable TV and movies.",
        capabilities = {"menu"}
    }
end
```
Provides metadata about the extension to VLC.

#### 2. **Lifecycle Functions**
- `activate()`: Called when the extension is activated from the View menu.
- `close()`: Called when the extension dialog is closed.
- `menu()`: Returns the list of menu options displayed in the View menu.
- `trigger_menu(id)`: Called when a menu option is selected.

#### 3. **Data Persistence**
- `save_data(filename, data)`: Saves data to a JSON file in VLC's config directory.
- `load_data(filename)`: Loads data from a JSON file.
- Favorites and watch history are stored in:
  - `vlc-infinity-favorites.json`
  - `vlc-infinity-history.json`

#### 4. **Network Functions**
- `fetch_url(url)`: Fetches content from a URL using VLC's HTTP session.
- `check_stream_health(url)`: Validates stream URLs before playback.

#### 5. **Parsing Functions**
- `parse_m3u(m3u_content)`: Parses M3U playlist format (IPTV channels).
- `fetch_movies_from_internet_archive(search_query)`: Fetches movies from Internet Archive API.

#### 6. **UI Functions**
- `browse_channels_dialog(search_query, country_filter, category_filter)`: Channel browser UI.
- `browse_movies_dialog(search_query, genre_filter)`: Movie browser UI.
- `play_selected_channel()`: Plays the selected channel.
- `add_to_favorites()`: Adds a channel to favorites.

---

## VLC Lua API Reference

### Dialog API

Create and manage UI dialogs:

```lua
local dlg = vlc.dialog("Dialog Title")

-- Add UI elements
dlg:add_label("Text", col, row, width, height)
dlg:add_text_input("default", col, row, width, height)
dlg:add_button("Button Text", callback, col, row, width, height)
dlg:add_dropdown(col, row, width, height)
dlg:add_checkbox("Checkbox", col, row, width, height)

-- Show/hide dialog
dlg:show()
dlg:hide()
dlg:clear()
dlg:delete()
```

### Playlist API

Control playback:

```lua
-- Add items to playlist
vlc.playlist.add({ { path = "http://stream.url", name = "Stream Name" } })

-- Play/pause
vlc.playlist.play()
vlc.playlist.pause()
vlc.playlist.stop()

-- Navigate
vlc.playlist.next()
vlc.playlist.prev()
```

### Network API

Make HTTP requests:

```lua
local http = vlc.net.get_http_session()
local stream = http:get("http://example.com/data")
local content = stream:read(1024)  -- Read up to 1024 bytes
stream:release()
http:release()
```

### JSON API

Parse and encode JSON:

```lua
local json_string = vlc.json.encode(table)
local table = vlc.json.decode(json_string)
```

### File I/O API

Read/write files:

```lua
local file = vlc.io.open(filename, "r")  -- "r" for read, "w" for write
local content = file:read()
file:write(content)
file:close()
```

### Config API

Access VLC configuration:

```lua
local config_path = vlc.config.path()  -- Returns VLC config directory path
```

### Messaging API

Log messages:

```lua
vlc.msg.info("Info message")
vlc.msg.warn("Warning message")
vlc.msg.err("Error message")
vlc.msg.dbg("Debug message")
```

### String API

String utilities:

```lua
local encoded = vlc.strings.url_encode("string to encode")
local decoded = vlc.strings.url_decode("encoded%20string")
```

---

## Adding New Features

### Example: Add a New Data Source

To add a new data source (e.g., a different movie provider):

1. **Create a fetch function:**
```lua
local function fetch_movies_from_new_source(search_query)
    local url = "https://api.example.com/search?q=" .. vlc.strings.url_encode(search_query)
    local json_content = fetch_url(url)
    if json_content then
        local data = vlc.json.decode(json_content)
        return data.results  -- Adjust based on API response format
    end
    return nil
end
```

2. **Create a browser dialog:**
```lua
local function browse_new_source_dialog(search_query)
    main_dlg:clear()
    main_dlg:add_label("Search New Source:", 1, 1, 8, 1)
    -- Add UI elements similar to existing dialogs
    main_dlg:show()
end
```

3. **Add to menu:**
```lua
function menu()
    return {"Browse Channels", "Browse Movies", "Browse New Source", "Favorites", "History", "EPG", "Settings"}
end

function trigger_menu(id)
    if id == 3 then
        browse_new_source_dialog()
    end
    -- ... other menu handlers
end
```

### Example: Add Filtering

To add a new filter (e.g., language filtering for channels):

1. **Modify the M3U parser to extract language:**
```lua
local language_match = line:match("tvg-language=\"([^"]+)\"")
if language_match then
    current_channel.language = language_match
end
```

2. **Add a language dropdown in the browser:**
```lua
local language_dropdown = main_dlg:add_dropdown(5, 4, 4, 1)
language_dropdown:add_value("All Languages", "")
for language, _ in pairs(unique_languages) do
    language_dropdown:add_value(language, language)
end
```

3. **Filter channels by language:**
```lua
local matches_language = not language_filter or channel.language == language_filter
```

---

## Testing

### Manual Testing

1. **Install the extension** following the installation guide.
2. **Open VLC** and activate the extension from the View menu.
3. **Test each feature:**
   - Browse channels with different filters
   - Search for channels and movies
   - Add items to favorites
   - Check watch history
   - Verify playback works

### Debugging

1. **View logs:**
   - Go to `Tools > Messages` in VLC to see extension logs.

2. **Add debug messages:**
```lua
vlc.msg.info("Debug: Variable value = " .. tostring(variable))
```

3. **Use error handling:**
```lua
local success, err = pcall(function_to_test)
if not success then
    vlc.msg.err("Error: " .. tostring(err))
end
```

---

## Performance Optimization

### Tips for Better Performance

1. **Cache data locally:**
   - Store fetched playlists and movie lists to reduce API calls.
   - Implement cache expiration (e.g., refresh every 24 hours).

2. **Optimize network requests:**
   - Use streaming for large responses.
   - Implement request timeouts.

3. **Lazy loading:**
   - Load data only when needed (e.g., when a user opens a dialog).

4. **Limit results:**
   - Paginate search results to avoid loading thousands of items at once.

---

## Security Considerations

1. **URL validation:**
   - Always validate URLs before making requests.
   - Use `vlc.strings.url_encode()` for user input.

2. **Injection prevention:**
   - Sanitize user input before using it in queries.
   - Avoid string concatenation for URLs; use proper encoding.

3. **Error handling:**
   - Handle network errors gracefully.
   - Don't expose sensitive information in error messages.

---

## Contributing

### How to Contribute

1. **Fork the repository** on GitHub.
2. **Create a new branch** for your feature: `git checkout -b feature/my-feature`
3. **Make your changes** and test thoroughly.
4. **Commit with clear messages:** `git commit -m "feat: Add my feature"`
5. **Push to your fork:** `git push origin feature/my-feature`
6. **Create a pull request** on the main repository.

### Code Style

- Use clear, descriptive variable names.
- Add comments for complex logic.
- Follow Lua conventions (lowercase with underscores for functions/variables).
- Keep functions focused and single-purpose.

---

## Known Limitations

1. **Dialog limitations:**
   - VLC's Lua dialog API has limited UI components.
   - No support for custom styling or advanced layouts.

2. **Mobile limitations:**
   - VLC for Android has limited Lua extension support.
   - VLC for iOS does not support custom Lua extensions.

3. **Performance:**
   - Large playlists may cause UI lag.
   - Network requests are synchronous (blocking).

4. **API dependencies:**
   - Relies on external APIs (iptv-org, Internet Archive).
   - No fallback if APIs are unavailable.

---

## Future Enhancements

Potential features for future versions:

- [ ] EPG (Electronic Program Guide) with schedule display
- [ ] Caching system for faster loading
- [ ] Custom playlist support
- [ ] Movie favorites and ratings
- [ ] Subtitle support
- [ ] Recording functionality
- [ ] Mobile app companion
- [ ] Advanced search filters
- [ ] User accounts and sync
- [ ] Streaming quality selection

---

## Resources

- **VLC Lua API Documentation:** https://www.videolan.org/developers/vlc/doc/doxygen/html/group__lua__api.html
- **Lua Documentation:** https://www.lua.org/manual/5.1/
- **IPTV-Org GitHub:** https://github.com/iptv-org/iptv
- **Internet Archive API:** https://archive.org/advancedsearch.php

---

## Support

For questions, issues, or suggestions, please open an issue on the [GitHub repository](https://github.com/Jamesjaq/vlc/tree/vlc-infinity).
