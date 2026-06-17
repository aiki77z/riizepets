# RIIZE Pets iPad Testing

This branch includes an iPad web app entry at `ipad.html`.

The WidgetKit prototype source lives in `ios-widget/`. It must be copied into a macOS Xcode SwiftUI app + Widget Extension target to build a real iPad Home Screen widget.

## Local iPad Test

1. Connect the computer and iPad to the same Wi-Fi.
2. On the computer, run:

   ```powershell
   npm run serve:ipad
   ```

3. Find the computer LAN IP:

   ```powershell
   ipconfig
   ```

4. On iPad Safari, open:

   ```text
   http://<computer-lan-ip>:4173/ipad.html
   ```

5. In Safari, tap Share, then Add to Home Screen.

For production-style PWA behavior and offline caching on iPad, host the same files over HTTPS.
