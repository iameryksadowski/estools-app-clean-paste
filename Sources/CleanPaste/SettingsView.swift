import AppKit
import ServiceManagement
import SwiftUI

/// The settings window. While it is open the app has a Dock icon; closing it puts the
/// app back into the menu bar only.
final class SettingsWindowController: NSObject, NSWindowDelegate {
    private var window: NSWindow?
    private let updater: Updater

    init(updater: Updater) {
        self.updater = updater
    }

    func show() {
        DockIcon.show("settings")
        if window == nil {
            let hosting = NSHostingController(rootView: SettingsView(updater: updater))
            let window = NSWindow(contentViewController: hosting)
            window.title = "Clean Paste"
            window.styleMask = [.titled, .closable, .miniaturizable]
            window.isReleasedWhenClosed = false
            window.delegate = self
            window.center()
            window.setFrameAutosaveName("SettingsWindow")
            self.window = window
        }
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func windowWillClose(_ notification: Notification) {
        DockIcon.hide("settings")
    }
}

struct SettingsView: View {
    @ObservedObject private var preferences = Preferences.shared
    let updater: Updater
    @State private var trusted = AXIsProcessTrusted()
    @State private var openAtLogin = SMAppService.mainApp.status == .enabled
    @State private var loginError: String?
    @State private var autoUpdates = false
    @State private var cliStatus = CommandLineTool.status()
    @State private var raycastNote: String?
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    private var version: String {
        let info = Bundle.main.infoDictionary
        return info?["CFBundleShortVersionString"] as? String ?? "dev"
    }

    var body: some View {
        Form {
            Section {
                HStack(spacing: 14) {
                    Image(nsImage: NSApp.applicationIconImage)
                        .resizable()
                        .frame(width: 56, height: 56)
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Clean Paste").font(.title2.weight(.semibold))
                        Text("Paste formatted text without backgrounds, colors and fonts. Bold, lists, links and line breaks stay.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.vertical, 4)
            }

            if !trusted {
                Section {
                    VStack(alignment: .leading, spacing: 8) {
                        Label("One step left: allow Accessibility", systemImage: "hand.raised")
                            .font(.headline)
                        Text("Clean Paste presses Cmd+V for you, and macOS asks for your permission. Click the button, turn on Clean Paste in the list and come back here. After an update, if Clean Paste is already on, turn it off and on again.")
                            .font(.callout)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                        Button("Allow Accessibility") { Permissions.requestAccessibility() }
                            .buttonStyle(.borderedProminent)
                            .tint(Color(red: 0.020, green: 0.588, blue: 0.412))
                    }
                    .padding(.vertical, 4)
                }
            }

            Section {
                LabeledContent {
                    ShortcutField(shortcut: $preferences.pasteCleanShortcut).frame(width: 150, height: 24)
                } label: {
                    Text("Paste Clean")
                    Text("Cleans the clipboard and pastes it into the app you are in.")
                }
                LabeledContent {
                    ShortcutField(shortcut: $preferences.repairShortcut).frame(width: 150, height: 24)
                } label: {
                    Text("Repair Clipboard")
                    Text("Keeps the text and removes backgrounds, colors and fonts. Then paste with Cmd+V yourself.")
                }
                if preferences.shortcutConflict {
                    Label("Another app already uses one of these shortcuts. Pick a different one.", systemImage: "exclamationmark.triangle")
                        .foregroundStyle(.orange)
                        .font(.callout)
                }
            } header: {
                Text("Shortcuts")
            } footer: {
                Text("Click a field and press the keys. Delete clears it. Both commands are also in the menu bar icon.")
                    .foregroundStyle(.secondary)
            }

            Section("Formatting") {
                Toggle(isOn: $preferences.replaceDashes) {
                    Text("Replace em and en dashes")
                    Text("Long dashes become a plain hyphen \"-\".")
                }
                Toggle(isOn: $preferences.replaceQuotes) {
                    Text("Replace typographic quotes")
                    Text("Curly and angle quotes, and the curly apostrophe, become \" and '.")
                }
                Picker(selection: $preferences.fontSize) {
                    ForEach(Preferences.fontSizes, id: \.value) { size in
                        Text(size.title).tag(size.value)
                    }
                } label: {
                    Text("Font size")
                    Text("Size of the pasted text. Without a size, Mail and Notes paste at 16 px.")
                }
            }

            Section("General") {
                Toggle(isOn: $openAtLogin) {
                    Text("Open at login")
                    if let loginError {
                        Text(loginError).foregroundStyle(.orange)
                    }
                }
                .onChange(of: openAtLogin) { _, enabled in setOpenAtLogin(enabled) }
                Toggle(isOn: $preferences.showFeedback) {
                    Text("Show a confirmation")
                    Text("A short note on screen after Repair Clipboard.")
                }
                LabeledContent {
                    if cliStatus.installed {
                        Text(cliStatus.path).font(.system(.callout, design: .monospaced)).foregroundStyle(.secondary)
                    } else {
                        Button("Install") { cliStatus = CommandLineTool.install() }
                    }
                } label: {
                    Text("Command line tool")
                    Text(cliStatus.note ?? "cleanpaste for Terminal, scripts and AI assistants. See cleanpaste --help.")
                }
                LabeledContent {
                    Button("Add to Raycast") {
                        raycastNote = RaycastIntegration.install()
                    }
                    .disabled(!RaycastIntegration.isInstalled)
                } label: {
                    Text("Raycast")
                    Text(raycastNote ?? (RaycastIntegration.isInstalled
                        ? "Paste Clean, Repair Clipboard and Settings as Raycast commands; give them Raycast hotkeys if you like."
                        : "Raycast is not installed."))
                }
            }

            Section("Updates") {
                Toggle("Check for updates automatically", isOn: $autoUpdates)
                    .onChange(of: autoUpdates) { _, value in updater.automaticallyChecks = value }
                    .disabled(!updater.isAvailable)
                LabeledContent("Version \(version)") {
                    Button("Check Now") { updater.checkForUpdates() }
                }
            }

            Section {
                LabeledContent("Accessibility") {
                    if trusted {
                        Label("Allowed", systemImage: "checkmark.circle.fill").foregroundStyle(.green)
                    } else {
                        Button("Open Settings") { Permissions.requestAccessibility() }
                    }
                }
            } header: {
                Text("Permission")
            } footer: {
                HStack {
                    Text("ES Tools by Eryk Sadowski")
                    Spacer()
                    Link("eryksadowski.com", destination: URL(string: "https://eryksadowski.com")!)
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 6)
            }
        }
        .formStyle(.grouped)
        // fits a 13-inch screen; the form scrolls
        .frame(width: 520, height: 660)
        .onAppear {
            autoUpdates = updater.automaticallyChecks
            cliStatus = CommandLineTool.status()
        }
        .onReceive(timer) { _ in
            trusted = AXIsProcessTrusted()
        }
    }

    private func setOpenAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
            loginError = nil
        } catch {
            loginError = "Could not change it: \(error.localizedDescription)"
        }
        openAtLogin = SMAppService.mainApp.status == .enabled
    }
}

/// Links Contents/Helpers/cleanpaste into a folder on the PATH, without an admin password.
enum CommandLineTool {
    struct Status {
        var installed: Bool
        var path: String
        var note: String?
    }

    static var helper: URL { Bundle.main.bundleURL.appendingPathComponent("Contents/Helpers/cleanpaste") }

    /// Homebrew's folder is on the PATH and writable without a password; ~/.local/bin otherwise.
    static var targetFolder: URL {
        let fm = FileManager.default
        for folder in ["/opt/homebrew/bin", "/usr/local/bin"] where fm.isWritableFile(atPath: folder) {
            return URL(fileURLWithPath: folder)
        }
        return fm.homeDirectoryForCurrentUser.appendingPathComponent(".local/bin")
    }

    static func status() -> Status {
        let link = targetFolder.appendingPathComponent("cleanpaste")
        let destination = try? FileManager.default.destinationOfSymbolicLink(atPath: link.path)
        return Status(installed: destination == helper.path, path: link.path.replacingOccurrences(of: NSHomeDirectory(), with: "~"))
    }

    static func install() -> Status {
        let fm = FileManager.default
        guard fm.fileExists(atPath: helper.path) else {
            return Status(installed: false, path: "", note: "The command line tool is missing from this build.")
        }
        let folder = targetFolder
        let link = folder.appendingPathComponent("cleanpaste")
        do {
            try fm.createDirectory(at: folder, withIntermediateDirectories: true)
            if (try? fm.destinationOfSymbolicLink(atPath: link.path)) != nil || fm.fileExists(atPath: link.path) {
                try fm.removeItem(at: link)
            }
            try fm.createSymbolicLink(at: link, withDestinationURL: helper)
        } catch {
            return Status(installed: false, path: "", note: "Could not install: \(error.localizedDescription)")
        }
        var result = status()
        if folder.path.hasSuffix("/.local/bin") {
            result.note = "Installed. Add ~/.local/bin to your PATH to use cleanpaste in Terminal."
        }
        return result
    }
}

/// Raycast Quicklinks that call Clean Paste through its links (estools-clean-paste://...).
/// Raycast imports them from a JSON file with its Import Quicklinks command.
enum RaycastIntegration {
    static var raycastURL: URL? { NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.raycast.macos") }
    static var isInstalled: Bool { raycastURL != nil }

    static let quicklinks: [[String: String]] = [
        ["name": "Clean Paste: Paste Clean", "link": "estools-clean-paste://paste"],
        ["name": "Clean Paste: Repair Clipboard", "link": "estools-clean-paste://repair"],
        ["name": "Clean Paste: Settings", "link": "estools-clean-paste://settings"],
        ["name": "Clean Paste: About", "link": "estools-clean-paste://about"],
    ]

    static var fileURL: URL {
        FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent("Clean Paste for Raycast.json")
    }

    /// Writes the import file to Downloads, opens Raycast and returns the next steps.
    static func install() -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: quicklinks, options: [.prettyPrinted, .withoutEscapingSlashes])
            try data.write(to: fileURL, options: .atomic)
        } catch {
            return "Could not write the file for Raycast: \(error.localizedDescription)"
        }
        if let raycastURL {
            NSWorkspace.shared.openApplication(at: raycastURL, configuration: NSWorkspace.OpenConfiguration())
        }
        return "Almost done: in Raycast type Import Quicklinks, press Return and choose \"Clean Paste for Raycast.json\" in Downloads. Hotkeys: Raycast Settings > Extensions > Quicklinks."
    }
}
