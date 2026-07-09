# VLC Infinity Usage Guide

This guide provides detailed instructions on how to use the VLC Infinity Lua extension to browse and play IPTV channels, movies, and manage your favorites and watch history.

---

## Getting Started

### Activating the Extension

1. **Open VLC Media Player.**
2. **Go to the `View` menu** at the top of the window.
3. **Look for `VLC Infinity`** in the menu options.
4. **Click on `VLC Infinity`** to open the extension dialog.

The VLC Infinity dialog will appear, showing a welcome message and menu options.

---

## Main Menu Options

The VLC Infinity extension provides six main menu options:

| Option | Description |
|--------|-------------|
| **Browse Channels** | Browse and search IPTV channels from iptv-org with filtering by country and category. |
| **Browse Movies** | Browse and search public-domain movies from Internet Archive with genre filtering. |
| **Favorites** | View and play your saved favorite channels. |
| **History** | View your watch history and replay previously watched content. |
| **EPG** | Electronic Program Guide (Coming Soon) for viewing channel schedules. |
| **Settings** | Settings and configuration options (Coming Soon). |

---

## Browsing Channels

### Step-by-Step Guide

1. **Click `Browse Channels`** from the main menu.
2. **The channel browser dialog opens** with the following controls:

   - **Search Input Field:** Type a channel name to search (e.g., "BBC", "CNN", "ESPN").
   - **Search Button:** Click to apply the search filter.
   - **Country Dropdown:** Filter channels by country (e.g., "United States", "United Kingdom", "France").
   - **Category Dropdown:** Filter channels by category (e.g., "News", "Sports", "Movies", "Kids").
   - **Channel Dropdown:** Select a channel from the filtered list.
   - **Play Button:** Click to start playing the selected channel.
   - **Add to Favorites Button:** Click to save the selected channel to your favorites.

### Example Workflow

1. Open the channel browser.
2. Select "United States" from the Country dropdown.
3. Select "Sports" from the Category dropdown.
4. Type "NBA" in the search field and click Search.
5. Select an NBA channel from the dropdown.
6. Click **Play** to start watching.
7. Click **Add to Favorites** to save the channel for quick access later.

### Tips

- **Search is case-insensitive:** You can search for "bbc", "BBC", or "Bbc" — all will work.
- **Combine filters:** Use country, category, and search together for precise results.
- **Channel logos:** Some channels include logos that may display in future versions.
- **Stream health:** The extension checks stream health before playing. If a stream fails the health check, try a different channel.

---

## Browsing Movies

### Step-by-Step Guide

1. **Click `Browse Movies`** from the main menu.
2. **The movie browser dialog opens** with the following controls:

   - **Search Input Field:** Type a movie title to search (e.g., "Nosferatu", "Metropolis", "Sherlock Holmes").
   - **Search Button:** Click to apply the search filter.
   - **Genre Dropdown:** Filter movies by genre (e.g., "Drama", "Comedy", "Horror", "Silent Films").
   - **Movie Dropdown:** Select a movie from the filtered list.
   - **Play Movie Button:** Click to start playing the selected movie.

### Example Workflow

1. Open the movie browser.
2. Type "Chaplin" in the search field and click Search.
3. Select "Comedy" from the Genre dropdown.
4. Select a Charlie Chaplin film from the dropdown.
5. Click **Play Movie** to start watching.

### Tips

- **Search is case-insensitive:** Works the same as channel search.
- **Genre filtering:** Movies from Internet Archive may have multiple genres. The extension filters by exact match.
- **Movie quality:** Public-domain movies may vary in quality. Try different versions if available.
- **Streaming:** Movies are streamed directly from Internet Archive. Ensure you have a stable internet connection.

---

## Managing Favorites

### Adding Favorites

**From Channel Browser:**
1. Browse and select a channel.
2. Click **Add to Favorites**.
3. A confirmation message will appear in VLC's message log.

**From Movie Browser:**
- Movie favorites are not yet implemented but will be added in future versions.

### Viewing Favorites

1. **Click `Favorites`** from the main menu.
2. **The favorites dialog opens** showing:
   - A list of all saved favorite channels.
   - A dropdown to select a favorite.
   - A **Play Favorite** button to start playback.

### Removing Favorites

Currently, favorites can only be removed by editing the favorites file directly:

- **Windows:** `%APPDATA%\vlc-infinity-favorites.json`
- **macOS:** `~/Library/Application Support/org.videolan.vlc/vlc-infinity-favorites.json`
- **Linux:** `~/.local/share/vlc/vlc-infinity-favorites.json`

Open the JSON file with a text editor, remove the desired channel entry, and save the file.

---

## Viewing Watch History

### Accessing History

1. **Click `History`** from the main menu.
2. **The history dialog opens** showing:
   - A list of all previously watched channels and movies.
   - A dropdown to select a history item.
   - A **Play from History** button to replay the content.

### History Storage

Watch history is automatically saved to:

- **Windows:** `%APPDATA%\vlc-infinity-history.json`
- **macOS:** `~/Library/Application Support/org.videolan.vlc/vlc-infinity-history.json`
- **Linux:** `~/.local/share/vlc/vlc-infinity-history.json`

### Clearing History

To clear your watch history:

1. Locate the `vlc-infinity-history.json` file (see paths above).
2. Delete the file or edit it to remove specific entries.
3. Restart VLC.

---

## Playback Controls

### Playing Content

Once you click **Play** or **Play Movie**:

1. **The stream is added to VLC's playlist.**
2. **Playback starts automatically** (if autoplay is enabled in VLC settings).
3. **Use VLC's standard playback controls:**
   - Play/Pause: Spacebar or click the play button.
   - Volume: Use the volume slider.
   - Fullscreen: Press `F` or double-click the video.
   - Seek: Click on the progress bar or use arrow keys.

### Stopping Playback

- **Click the stop button** in VLC's playback controls.
- **Or press `S` on your keyboard.**

### Adjusting Quality

If a stream is buffering or playing poorly:

1. **Go to `Tools > Preferences > Input / Codecs`** in VLC.
2. **Adjust network caching** to a higher value (e.g., 5000 ms).
3. **Click Save and restart VLC.**

---

## Troubleshooting

### Channel or Movie Won't Play

**Possible causes and solutions:**

1. **Stream is offline:**
   - The stream health checker may have detected an issue.
   - Try a different channel or movie.

2. **Internet connection issue:**
   - Check your internet connection.
   - Restart your router.

3. **VLC network settings:**
   - Go to `Tools > Preferences > Input / Codecs`.
   - Increase network caching.

4. **Firewall or proxy:**
   - Check if your firewall is blocking VLC.
   - If using a proxy, configure it in VLC settings.

### Search Returns No Results

1. **Check spelling:** Ensure you've typed the channel or movie name correctly.
2. **Try broader search:** Use fewer keywords (e.g., "BBC" instead of "BBC News America").
3. **Check internet connection:** The extension needs internet to fetch data.

### Favorites or History Not Saving

1. **Check file permissions:**
   - Ensure VLC has write permissions to the config directory.
   - On Linux/macOS, run: `chmod 755 ~/.local/share/vlc/` or `chmod 755 ~/Library/Application\ Support/org.videolan.vlc/`

2. **Check disk space:**
   - Ensure your device has sufficient disk space.

3. **Restart VLC:**
   - Close and reopen VLC to ensure changes are saved.

### Extension Crashes or Freezes

1. **Check VLC logs:**
   - Go to `Tools > Messages` to view error messages.

2. **Restart VLC:**
   - Close VLC completely and reopen it.

3. **Reinstall the extension:**
   - Delete `vlc-infinity.lua` and reinstall it following the installation guide.

---

## Keyboard Shortcuts

While using VLC Infinity, you can use these VLC shortcuts:

| Shortcut | Action |
|----------|--------|
| `Spacebar` | Play/Pause |
| `F` | Toggle Fullscreen |
| `S` | Stop |
| `N` | Next item in playlist |
| `P` | Previous item in playlist |
| `T` | Show/Hide time display |
| `V` | Cycle subtitle visibility |
| `A` | Cycle audio tracks |
| `Ctrl + H` | Show/Hide interface |

---

## Advanced Features

### Stream Health Checking

The extension automatically checks stream health before playback:

- **What it does:** Sends a test request to the stream URL to verify it's accessible.
- **If it fails:** The extension will warn you and prevent playback of unhealthy streams.
- **Why it matters:** Saves you from wasting time trying to play dead streams.

### Automatic Playlist Refresh

The extension fetches fresh IPTV playlists from iptv-org each time you browse channels. This ensures you always have the latest channels and streams.

### Genre Filtering for Movies

Movies from Internet Archive are tagged with genres. The extension extracts these tags and allows you to filter by genre for easier browsing.

---

## Frequently Asked Questions

**Q: Can I add custom IPTV playlists?**
A: Currently, the extension only supports iptv-org playlists. Custom playlist support may be added in future versions.

**Q: Are the movies legal to watch?**
A: Yes, all movies are from Internet Archive's public-domain collection, which are legally free to watch and distribute.

**Q: Can I use VLC Infinity on mobile?**
A: VLC for Android has limited extension support. VLC for iOS does not support custom Lua extensions. Desktop versions (Windows, macOS, Linux) have full support.

**Q: How often are channels updated?**
A: Channels are fetched from iptv-org each time you browse. iptv-org updates their playlists regularly.

**Q: What if a channel stops working?**
A: Try a different channel or refresh the browser. If many channels are down, it may be a temporary issue with iptv-org or your internet connection.

**Q: Can I export my favorites?**
A: Yes, your favorites are stored in a JSON file (see paths in "Managing Favorites" section). You can copy this file to another device to transfer your favorites.

---

## Tips and Tricks

1. **Create a favorites list:** Add your most-watched channels to favorites for quick access.
2. **Use search effectively:** Combine keywords with country and category filters for precise results.
3. **Check history:** Your watch history is saved automatically. Use it to quickly replay recently watched content.
4. **Adjust VLC settings:** Tweak VLC's network caching and other settings for optimal playback.
5. **Report issues:** If you find dead streams or have suggestions, report them on the GitHub repository.

---

## Support and Feedback

For issues, feature requests, or feedback, visit the [GitHub repository](https://github.com/Jamesjaq/vlc/tree/vlc-infinity).
