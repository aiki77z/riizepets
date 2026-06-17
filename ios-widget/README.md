# RIIZE Pets WidgetKit Prototype

This folder contains the WidgetKit-side source for the iPad memo widget design. It is source-only because this Windows workspace cannot build or sign an iPad app.

To use it on macOS:

1. Create/open a SwiftUI iPad app in Xcode.
2. Add a Widget Extension target named `RIIZEPetsWidgetExtension`.
3. Copy the Swift files from this folder into the app/widget targets as indicated by file comments.
4. Add an App Group capability to both targets and set `RIIZE_APP_GROUP` in `RIIZEPetSharedStore.swift`.
5. Export pet representative PNG frames into the app/widget asset catalogs using names like `rizuko_idle_0` and `rizuko_running_left_2`.

WidgetKit cannot force-install the widget onto the iPad Home Screen. The app can expose a `Desk Widget` toggle and instructions, while the user still adds the widget manually from the Home Screen widget picker.
