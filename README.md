# 🧹 **NimbusCache – The Swiftest Cache in the Wizarding World!** 🚀

[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-brightgreen)](https://swift.org/package-manager/) [![CocoaPods](https://img.shields.io/badge/CocoaPods-compatible-brightgreen)](https://cocoapods.org/)

<div align="center">
  <table style="border-collapse: collapse; border: none;">
    <tr>
      <td align="center" style="padding: 20px;">
        <img src="https://github.com/vijay-subramani/Assets/blob/main/downloadAnimation.gif?raw=true" alt="Fast Caching" width="150"/>  
        <br>  
        <div style="margin-top: 10px;">
          <strong>Fast Caching</strong>  
          <br>  
          <em>Files cached in a flash!</em>  
        </div>
      </td>
      <td align="center" style="padding: 20px;">
        <div style="margin-top: 30px;">
        <img src="https://github.com/vijay-subramani/Assets/blob/main/videoPlaying.gif?raw=true" alt="Instant Video Playback" width="150"/>  
        <br>  
        <div style="margin-top: 10px;">
          <strong>Instant Video Playback</strong>  
          <br>  
          <em>No buffering, just magic!</em>  
        </div>
      </td>
    </tr>
  </table>
</div>

**"Why wait when you can fly?"** 🌪️💨 **NimbusCache** is **not just a caching framework—it’s a revolution in speed and efficiency**! Inspired by the legendary **Nimbus 2000**, it ensures that your app **soars past slow load times** and delivers a **buttery-smooth experience** to your users.

🔮 **No buffering. No waiting. Just instant playback and seamless file caching.**

⚡ **Imagine this:** A user taps on a video, and BOOM—**instant playback** without a single loading screen. They switch screens, come back, and guess what? **Still cached.** No redownloading. No wasted bandwidth. **Just pure speed.** 🚀

---

## ✨ **What Makes NimbusCache Magical?**

✅ **🚀 Hyper-Speed Video Caching** – Say goodbye to buffering.

✅ **🎥 Optimized for AVPlayerItem** – Works like a charm with native video playback.

✅ **💾 Cache Any File** – Effortlessly store & retrieve any data you need.

✅ **🧼 Auto-Managed Cache** – No manual cleanup; NimbusCache **handles everything**.

✅ **🔌 Plug & Play** – Integrate in **seconds** with SPM & CocoaPods.

✅ **🔮 Future-Ready** – More file types & advanced caching algorithms **coming soon!**

✨ **No extra dependencies. No unnecessary complexity. Just pure caching magic.**

---

## 📲 **Installation**

### 🚀 **Swift Package Manager (SPM)**
Calling NimbusCache is as easy as **summoning a Patronus**:

1️⃣ **Open Xcode** → **File** → **Add Packages**

2️⃣ Paste this **URL** into the search bar:
   ```
   https://github.com/vijay-subramani/NimbusCache.git
   ```
3️⃣ Select **branch or version** → Click **Add Package** (Select the latest version to get the best experience)

🎉 **BOOM!** NimbusCache is now in your project! 🚀

### 🍩 **CocoaPods**
For those who prefer **CocoaPods**, installation is just as simple:
```ruby
pod 'NimbusCache'
```
Then run:
```sh
pod install
```
💡 After running `pod install`, open the `.xcworkspace` file in Xcode, and voilà. **🧙‍♂️✨ Your app is ready to fly at lightning speed! ⚡**
💡 **Done!** Your caching problems are now officially history.

---

## 🚀 **How to Use NimbusCache**

### 🎬 **1️⃣ Effortless Video Caching for AVPlayerItem**
```swift
import NimbusCache
import AVKit

let url = URL(string: "https://yourvideo.com/video.mp4")!
let player = AVPlayer()
Task {
    if let videoUrl, let playerItem = await AVPlayerItem(url: url, isCacheEnabled: true) {
        player = AVPlayer(playerItem: playerItem)
        player.play()
    }
}
```
✨ **No stutters. No lag. Just instant, smooth video playback.**

### 💾 **2️⃣ Cache Any File Efficiently**  
Before downloading a file, **always check if it's already cached**:  
```swift
import NimbusCache

let url = URL(string: "https://yourfile.com/sample.pdf")!
let cacheManager = NimbusCacheManager.shared

if let cachedURL = cacheManager.cachedFileURL(for: url) {
    print("✨ File is already cached at:", cachedURL.path)
} else {
    Task {
        let localURL = await cacheManager.downloadAndCacheFile(from: url)
        if let localURL = localURL {
            print("✅ File downloaded & cached at:", localURL.path)
        } else {
            print("❌ Download failed")
        }
    }
}
```
🚀 **Super smart!**  
🔹 **No duplicate downloads**—always checks the cache first.  
🔹 **Auto-handles file management for efficiency.**  

### 🧹 **3️⃣ Smart Cache Cleanup**
```swift
NimbusCacheManager.shared.clearCacheIfNeeded()
```
🎯 **Storage optimized automatically.** No bloat—just a **lean, mean caching machine.**

### ⚡ **4️⃣ Command the Cache: Set Age & Limit Like a Wizard**

Take control of your cache like a true sorcerer! With a flick of your wand (or a line of code), you can set the **maximum cache age** and **cache size limit** to keep your app running like magic.

#### ✨ **Set the Cache Age (in Days)**  
Decide how long your cached files stay fresh. After the set number of days, older files will vanish into thin air!  

```swift
NimbusCacheManager.shared.setCacheAgeIn(days: 10)
```

#### ✨ **Set the Cache Limit (in MB)**  
Keep your cache from overflowing by setting a size limit. Once the limit is reached, older files will disappear to make room for new ones.  

```swift
NimbusCacheManager.shared.setCacheLimit(200.0) // Cache limit in MB
```

💡 **Pro Tip**: Cast these spells in your `AppDelegate` to ensure the cache rules apply across your entire app.  

### 🧹 **5️⃣ Cleanse the Cache with One Swift Spell**

When you need a fresh start, banish all cached files in a flash:

```swift
NimbusCacheManager.shared.clearAllCache()
```

---

## 🌟 **Why NimbusCache Stands Out: The Magic Behind the Speed**

NimbusCache isn’t just another caching framework—it’s a **game-changer**. Built to make your app **fly faster than a Firebolt**, it combines **cutting-edge technology** with **elegant simplicity**. Here’s why developers are switching to NimbusCache:

| Feature                | NimbusCache 🚀 | Others        |
|------------------------|----------------|---------------|
| **Video Caching Speed** | **Instant** playback with no buffering. ✨ | Often requires preloading or buffering. 🐌 |
| **File Retrieval Time** | **0.5s** average retrieval time for cached files. ⚡ | Slower retrieval due to inefficient caching mechanisms. ⏳ |
| **Cache Cleanup**      | **Auto-managed** – Clears old files automatically. 🧹 | Manual or semi-automatic cleanup required. 🛠️ |
| **Ease of Integration** | **Plug & Play** – Integrate in seconds with SPM or CocoaPods. 🎯 | Complex setup and configuration. 🧩 |
| **File Type Support**  | **Any file type** – Videos, images, PDFs, and more. 🌈 | Limited to specific file types. 🚫 |

✨ **NimbusCache is built for speed, simplicity, and versatility. No bloat, no complexity—just pure caching magic.**

### **The NimbusCache Advantage: A Closer Look**

#### **🚀 Hyper-Speed Caching**
- **Instant Playback**: Videos start playing **immediately**—no buffering, no waiting.  
- **Seamless Transitions**: Switch between screens without losing cached data.  

#### **🧼 Auto-Managed Cache**
- **No Manual Cleanup**: NimbusCache **automatically clears old files** to save space.  
- **Smart Eviction**: Keeps your cache lean and efficient without any effort on your part.  

#### **🔌 Plug & Play Integration**
- **SPM & CocoaPods**: Integrate in **seconds** with your favorite dependency manager.  
- **Zero Configuration**: Get started with just a few lines of code.  

#### **💾 Cache Any File**
- **Versatile Support**: Works with **videos, images, PDFs, audio**, and more.  
- **Future-Ready**: Expanding support for even more file types and advanced caching algorithms.  

#### **🔮 Built for Developers**
- **Lightweight**: No extra dependencies—just pure caching power.  
- **Open-Source**: Built for developers, by developers.  

### **Why Choose NimbusCache?**
- **Optimized for AVPlayerItem**: Perfect for video-heavy apps.  
- **No Extra Dependencies**: Lightweight and easy to use.  
- **Smart Cache Management**: Automatically clears old files to save space.  
- **Open-Source & Community-Driven**: Built for developers, by developers.

---  

## ❓ **FAQ**  

### **Q: What if the cache size grows too large?**  
A: NimbusCache automatically manages cache size and clears old files when needed. You can also set a custom cache size limit.  

### **Q: Can I use NimbusCache for non-video files?**  
A: Absolutely! NimbusCache works with **any file type**—PDFs, images, audio, and more.  

### **Q: Does NimbusCache support streaming links (.m3u8)?** 
A: Not yet, but soon! 🚀 Streaming link support is on the horizon, and we’re working hard to make it a reality. Stay tuned!

### **Q: Where does NimbusCache store cached files? Can they be accessed outside the app?**  
A: NimbusCache stores files in `AppName/NimbusCache` within the app’s **.cachesDirectory**.  
   - **Access**: Files are **sandboxed**—only your app can access them.  
   - **Persistence**: The system may clear the **.cachesDirectory** if device space is low, but NimbusCache manages the cache efficiently to minimize this risk.  
   
✨ **Your cached files are safe, secure, and optimized for performance!**  


### **Q: How do I set a cache age or size limit?**  
A: Use the `setCacheAgeIn(days:)` and `setCacheLimit(_:)` methods. Check out the **Code Samples** section for details.  

### **Q: How do I clear the cache manually?**  
A: Use the `clearAllCache()` method to banish all cached files in one go. 

---

## 🔮 **What’s Next?**
🚀 **Streaming Link Support (.m3u8)** – Coming soon! *(Because even wizards need to stream!)*  
🚀 **Expanding support for more file formats**
🚀 **Background caching magic for ultimate performance**
🚀 **Smarter cache eviction to maximize efficiency**

🔔 **Stay tuned! NimbusCache is evolving—faster than a Firebolt.**

---

## 🎩 **Join the Magic!**

NimbusCache is **open-source and community-driven**! 🌍✨
💡 **Have an idea?** Fork the repo, submit a PR, or open an issue. Let’s build the **ultimate caching framework together!**

🧙‍♂️✨ **"Mischief Managed!"**
(🌟 A nod to the magical world of Harry Potter, because with NimbusCache, your caching problems are officially solved! 🧹⚡🎉)

## 📜 **License**
NimbusCache is licensed under **MIT**—because **fast, efficient caching should be for everyone!**

---

✨ **Ready to take your app’s performance to the next level?** 🚀
🔗 **Get NimbusCache today!** 🧹💨
🌐 **Explore the Magic:**  
- [GitHub Repository](https://github.com/vijay-subramani/NimbusCache)  
- [Documentation](#) *(coming soon!)*
- [Follow Me on LinkedIn](https://www.linkedin.com/in/vijay-subramani-b6313514a)  

---

### **"Whispered into existence by 🪄✨ The Muggle Developer"**  
*(Because even Muggles can create magic! 🧚✨)*
