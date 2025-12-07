# the-screen-is-flipped

> [!CAUTION]
> Application is `vibe codded`. Proceed at your own risk!

## 🖤 📸 Black & White Snapshot App

A simple macOS tool that takes a screenshot, turns it black & white, flips it, compresses it, and saves it to your Desktop. All in Swift, using the modern ScreenCaptureKit.

## 🚀 Features

- Capture your main screen effortlessly
- Convert screenshots to black & white instantly
- Flip the image vertically for fun effects
- Compress to JPEG to save space
- One-click save to your Desktop

## 🛠️ Requirements

- macOS 15+
- Xcode or Swift toolchain installed
- Screen Recording permissions for your terminal or app

## ⚡ How to Run

**1. Clone this repo (or download it)**

```
git clone https://github.com/your-username/black-white-snapshot.git
cd black-white-snapshot
```

**2.Compile the Swift program**

```
swiftc main.swift -o screenshotApp -target arm64-apple-macosx15.0
```

**3.Run it**

```
./screenshotApp
```

> ✅ The screenshot will appear on your Desktop as `snapshot.jpg`

## 🎨 Example Output

**Your Desktop will now look mysteriously stylish:**
![image of a flipped desktop screen in black and white](./snapshot.jpg)

## 🤓 How It Works

1. Uses ScreenCaptureKit to grab the main display
2. Converts the captured frame into a CIImage
3. Applies the CIPhotoEffectMono filter for black & white
4. Flips it using CGAffineTransform
5. Compresses it with CIContext and saves as JPEG

## 🦄 Fun Tips

- Want double the fun? Take a screenshot of a screenshot!
- Rename the output file if you want a personalized gallery.
- Perfect for making retro B&W wallpapers.
