//
//  FinderLauncherTests.swift
//  FinderLauncherTests
//
//  Created by 启业云03 on 2026/9/1.
//

import Testing
import Carbon.HIToolbox
@testable import FinderLauncher

struct FinderLauncherTests {

    @Test func keyNameForLetter() {
        #expect(KeycodeTable.keyName(for: UInt32(kVK_ANSI_A)) == "A")
        #expect(KeycodeTable.keyName(for: UInt32(kVK_ANSI_T)) == "T")
    }

    @Test func keyNameForDigitAndFunction() {
        #expect(KeycodeTable.keyName(for: UInt32(kVK_ANSI_1)) == "1")
        #expect(KeycodeTable.keyName(for: UInt32(kVK_F5)) == "F5")
    }

    @Test func modifierString() {
        #expect(KeycodeTable.modifierString(carbon: UInt32(cmdKey | shiftKey)) == "⇧⌘")
        #expect(KeycodeTable.modifierString(carbon: UInt32(optionKey | controlKey)) == "⌃⌥")
        #expect(KeycodeTable.modifierString(carbon: 0) == "")
    }

    @Test func displayString() {
        #expect(KeycodeTable.displayString(keyCode: UInt32(kVK_ANSI_T),
                                           modifiers: UInt32(cmdKey | shiftKey)) == "⇧⌘T")
    }
}
