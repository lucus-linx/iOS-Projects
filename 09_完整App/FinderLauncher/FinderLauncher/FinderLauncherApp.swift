//
//  FinderLauncherApp.swift
//  FinderLauncher
//
//  Created by 启业云03 on 2026/9/1.
//

import SwiftUI

@main
struct FinderLauncherApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        MenuBarExtra("FinderLauncher", systemImage: "terminal") {
            MenuContentView()
        }
        .menuBarExtraStyle(.menu)

        Settings {
            SettingsView()
        }
    }
}
