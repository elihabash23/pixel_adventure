# Installing Pixel Adventure on Your iPhone

This guide will walk you through installing Pixel Adventure on your physical iPhone device for testing.

---

## 📋 Prerequisites

- Mac computer with Xcode installed
- Physical iPhone device
- USB cable (Lightning or USB-C depending on your iPhone)
- Apple ID (free account works for testing!)
- Flutter SDK installed and configured

---

## 🚀 Quick Installation (TL;DR)

```bash
# 1. Connect iPhone via USB and unlock it
# 2. Trust the computer when iPhone prompts you
# 3. Check if device is detected
flutter devices

# 4. Run on your iPhone
flutter run

# 5. On iPhone: Settings → General → VPN & Device Management → Trust your Apple ID
```

---

## 📱 Step-by-Step Installation

### Step 1: Connect Your iPhone

1. **Connect your iPhone to your Mac** using a USB cable
2. **Unlock your iPhone**
3. You'll see a prompt on your iPhone: **"Trust This Computer?"**
   - Tap **Trust**
   - Enter your iPhone passcode if prompted

### Step 2: Verify Connection

Run this command to check if Flutter detects your iPhone:

```bash
flutter devices
```

**Expected output:**
```
2 connected devices:

iPhone 16 Plus (mobile) • 00008030-XXXXXXXXXXXX • ios • iOS 17.0
macOS (desktop)         • macos                 • darwin-arm64 • macOS 14.0
```

If you don't see your iPhone, see the [Troubleshooting](#-troubleshooting) section below.

### Step 3: Configure Code Signing (First Time Only)

**You only need to do this once!**

#### Option A: Using Xcode (Recommended)

1. **Open the project in Xcode:**
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Select the Runner project** in the left sidebar (the blue icon at the top)

3. **Go to the "Signing & Capabilities" tab**

4. **Check the box:** ✅ "Automatically manage signing"

5. **Select your Team:**
   - Click the **Team** dropdown
   - If your Apple ID isn't there, click **"Add an Account..."**
   - Sign in with your Apple ID (the one you use for iCloud/App Store)
   - Select your personal team

6. **Change the Bundle Identifier** to make it unique:
   - Find the **Bundle Identifier** field
   - Change from: `com.example.pixelAdventure`
   - Change to: `com.yourname.pixelAdventure`
   - Example: `com.ehabash.pixelAdventure`

7. **Close Xcode** (changes are saved automatically)

#### Option B: Manual Configuration

If you prefer to edit files directly:

1. Open `ios/Runner.xcodeproj/project.pbxproj`
2. Find `PRODUCT_BUNDLE_IDENTIFIER`
3. Change all instances from `com.example.pixelAdventure` to `com.yourname.pixelAdventure`

### Step 4: Build and Install

Now that signing is configured, install the app:

```bash
flutter run
```

**What happens:**
1. Flutter will detect your iPhone
2. If multiple devices are available, you'll be prompted to select one
3. The app will build (takes 1-2 minutes first time)
4. The app will install on your iPhone
5. The app will launch automatically

**Output you'll see:**
```
Launching lib/main.dart on Your iPhone in debug mode...
Running Xcode build...
Xcode build done.                                           45.2s
Installing and launching...
```

### Step 5: Trust the Developer (First Launch Only)

When you first launch the app, you might see:

**"Untrusted Developer"** message on your iPhone

**To fix this:**

1. Go to **Settings** on your iPhone
2. Scroll down to **General**
3. Scroll down to **VPN & Device Management** (or **Device Management**)
4. You'll see your Apple ID under **"Developer App"**
5. Tap on your Apple ID
6. Tap **"Trust [Your Apple ID]"**
7. Tap **"Trust"** in the confirmation dialog

**Now go back to your home screen and launch Pixel Adventure!** 🎮

---

## 🎯 Running Specific Device

If you have multiple devices connected, specify which one:

```bash
# List all devices with their IDs
flutter devices

# Run on specific device
flutter run -d 00008030-XXXXXXXXXXXX

# Or use device name
flutter run -d "Ehab's iPhone"
```

---

## 🔄 Updating the App

After making code changes, you have two options:

### Hot Reload (Fast - Preserves State)
While the app is running, press **`r`** in the terminal or:
```bash
# In the terminal where flutter run is active, type:
r
```

### Hot Restart (Full Restart)
While the app is running, press **`R`** in the terminal or:
```bash
# In the terminal where flutter run is active, type:
R
```

### Full Rebuild
```bash
# Stop the current run (Ctrl+C or 'q')
# Then run again
flutter run
```

---

## ⚠️ Troubleshooting

### iPhone Not Detected

**Problem:** `flutter devices` doesn't show your iPhone

**Solutions:**

1. **Check cable connection**
   - Try a different USB cable
   - Make sure cable supports data transfer (not just charging)
   - Try a different USB port on your Mac

2. **Check iPhone trust**
   - Unlock your iPhone
   - You should see "Trust This Computer?" prompt
   - If you accidentally tapped "Don't Trust", disconnect and reconnect

3. **Restart trust process**
   ```bash
   # Install libimobiledevice if needed
   brew install libimobiledevice

   # Unpair and re-pair device
   idevicepair unpair
   idevicepair pair
   ```

4. **Check iOS version compatibility**
   ```bash
   flutter doctor -v
   ```

5. **Restart everything**
   - Disconnect iPhone
   - Quit Xcode if open
   - Run: `killall -9 Xcode`
   - Reconnect iPhone

### Code Signing Error

**Problem:** Build fails with code signing error

**Solution:**

1. Make sure you changed the Bundle Identifier to something unique
2. In Xcode, go to Signing & Capabilities
3. Verify "Automatically manage signing" is checked
4. Select your Team from the dropdown
5. Try cleaning the build:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### "Untrusted Developer" Won't Go Away

**Problem:** After trusting, app still won't launch

**Solution:**

1. Delete the app from your iPhone
2. In Xcode: Product → Clean Build Folder (Cmd+Shift+K)
3. Rebuild and reinstall:
   ```bash
   flutter clean
   flutter run
   ```
4. Trust the developer again in Settings

### App Expires After 7 Days

**Problem:** App stops working after a week

**Explanation:**
- Free Apple ID allows testing for 7 days only
- This is an Apple restriction, not a Flutter limitation

**Solutions:**

**Option 1: Reinstall (Free)**
```bash
flutter run
# Trust developer again in Settings
```

**Option 2: Join Apple Developer Program ($99/year)**
- Apps don't expire
- Can distribute via TestFlight
- Can publish to App Store
- Sign up at: https://developer.apple.com/programs/

### Build Takes Forever

**Problem:** First build takes 5+ minutes

**Solutions:**

1. **This is normal for first build!** Subsequent builds are much faster (10-30 seconds)

2. **Speed up future builds:**
   ```bash
   # Close unnecessary apps to free up RAM
   # Use release mode for testing (smaller, faster):
   flutter run --release
   ```

3. **Clean build if stuck:**
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

### iPhone Screen Stays Black

**Problem:** App installs but shows black screen

**Solutions:**

1. Check terminal for errors
2. Try hot restart (press `R` in terminal)
3. Check iPhone storage (need at least 1GB free)
4. Full rebuild:
   ```bash
   flutter clean
   flutter run
   ```

### Wi-Fi Debugging Not Working

**Problem:** Want to debug wirelessly

**Solution:**

1. Connect iPhone via USB first
2. In Xcode: Window → Devices and Simulators
3. Select your iPhone
4. Check "Connect via network"
5. Disconnect USB cable
6. Your iPhone should still appear in `flutter devices`

---

## 🎮 Building for Release (TestFlight/App Store)

If you want to distribute your app to others or publish it:

### 1. Enroll in Apple Developer Program
- Cost: $99/year
- Sign up: https://developer.apple.com/programs/
- Approval takes 1-2 days

### 2. Create App ID and Provisioning Profile
```bash
# In Xcode
# 1. Select Runner target
# 2. Go to Signing & Capabilities
# 3. Select your paid team
# 4. Xcode will create provisioning profile automatically
```

### 3. Build Release Version
```bash
# Build IPA file
flutter build ipa

# Or build and upload to App Store Connect
flutter build ipa --release
```

### 4. Upload to App Store Connect
```bash
# Option 1: Use Xcode
# 1. Open ios/Runner.xcworkspace
# 2. Product → Archive
# 3. Distribute App → App Store Connect

# Option 2: Use Transporter app
# 1. Download Transporter from Mac App Store
# 2. Drag the .ipa file to Transporter
# 3. Click "Deliver"
```

### 5. TestFlight Distribution
- Go to App Store Connect (https://appstoreconnect.apple.com)
- Select your app
- Go to TestFlight tab
- Add internal testers (up to 100)
- Add external testers (up to 10,000) - requires Apple review

---

## 📊 Useful Commands

```bash
# Check all connected devices
flutter devices

# Run in debug mode (default)
flutter run

# Run in release mode (faster, smaller)
flutter run --release

# Run in profile mode (for performance testing)
flutter run --profile

# Build without running
flutter build ios

# Clean build cache
flutter clean

# Update dependencies
flutter pub get

# Check Flutter setup
flutter doctor

# View device logs
flutter logs

# Screenshot from connected device
flutter screenshot

# Install specific version
flutter run -d [device-id]

# Verbose output (for debugging issues)
flutter run -v
```

---

## 💡 Pro Tips

1. **Keep USB cable connected** during development for hot reload
2. **Use release mode** (`flutter run --release`) for performance testing
3. **Enable Wi-Fi debugging** for wireless development
4. **Use TestFlight** for sharing with beta testers
5. **Keep Xcode updated** for latest iOS support
6. **Battery drain is normal** in debug mode - release mode is much better
7. **Close the app** between major code changes for best results

---

## 🔗 Helpful Resources

- **Flutter iOS Deployment:** https://docs.flutter.dev/deployment/ios
- **Apple Developer Portal:** https://developer.apple.com
- **App Store Connect:** https://appstoreconnect.apple.com
- **TestFlight Documentation:** https://developer.apple.com/testflight/
- **Flutter Doctor Issues:** https://flutter.dev/docs/get-started/install/macos#update-your-path

---

## 🆘 Still Having Issues?

1. **Check Flutter setup:**
   ```bash
   flutter doctor -v
   ```

2. **Check Xcode setup:**
   ```bash
   xcodebuild -version
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

3. **Verify iOS deployment setup:**
   ```bash
   flutter doctor --verbose
   # Look for any [!] warnings in "iOS toolchain" section
   ```

4. **Get detailed logs:**
   ```bash
   flutter run -v
   # Save the output and review for specific errors
   ```

5. **Community help:**
   - Flutter Discord: https://discord.gg/flutter
   - Stack Overflow: https://stackoverflow.com/questions/tagged/flutter
   - Flutter GitHub Issues: https://github.com/flutter/flutter/issues

---

## ✅ Success Checklist

Before you start, make sure you have:

- [ ] Mac with Xcode installed
- [ ] iPhone connected via USB
- [ ] iPhone unlocked and trusted computer
- [ ] `flutter devices` shows your iPhone
- [ ] Changed bundle identifier in Xcode to something unique
- [ ] Selected your Team in Xcode Signing & Capabilities
- [ ] "Automatically manage signing" is checked
- [ ] Built and installed with `flutter run`
- [ ] Trusted developer in iPhone Settings

If all checkboxes are checked, you should have Pixel Adventure running on your iPhone! 🎉

---

**Happy Testing! 🎮📱**

If you encounter any issues not covered in this guide, run `flutter doctor -v` and check the troubleshooting section above.
