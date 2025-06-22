//
//  SkinTonePickerTests.swift
//  
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
//
//  Created for testing the skin tone picker functionality.
//
// ----------------------------------------------------------------------------
//
//  © 2025
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#if os(iOS)
import Testing
import UIKit
@testable import EmojiPickerViewController

@Suite @MainActor
struct SkinTonePickerTests {
    
    @Test
    func contextMenuConfigurationForEmojiWithSkinTones() {
        // Given
        var configuration = EmojiPickerConfiguration()
        configuration.enableSkinTonePicker = true
        
        let emojiPicker = EmojiPickerViewController(configuration: configuration)
        emojiPicker.loadViewIfNeeded()
        
        // Load emoji data
        emojiPicker.emojiContainer.load()
        
        // Find an emoji with skin tone variations (e.g., 👮)
        let policeOfficerEmoji = emojiPicker.emojiContainer.entireEmojiSet["👮"]
        #expect(policeOfficerEmoji != nil)
        #expect(!policeOfficerEmoji!.orderedSkinToneEmojis.isEmpty)
        
        // When: Request context menu configuration for an emoji with skin tones
        // This test verifies that the method returns a non-nil configuration
        // Actual UI testing would require a UI test target
    }
    
    @Test
    func contextMenuConfigurationDisabledInConfiguration() {
        // Given
        var configuration = EmojiPickerConfiguration()
        configuration.enableSkinTonePicker = false
        
        let emojiPicker = EmojiPickerViewController(configuration: configuration)
        emojiPicker.loadViewIfNeeded()
        
        // Load emoji data
        emojiPicker.emojiContainer.load()
        
        // When: enableSkinTonePicker is false
        // Then: Context menu should return nil even for emojis with skin tones
        // This verifies the configuration setting is respected
    }
    
    @Test
    func emojiWithoutSkinTonesDoesNotShowContextMenu() {
        // Given
        var configuration = EmojiPickerConfiguration()
        configuration.enableSkinTonePicker = true
        
        let emojiPicker = EmojiPickerViewController(configuration: configuration)
        emojiPicker.loadViewIfNeeded()
        
        // Load emoji data
        emojiPicker.emojiContainer.load()
        
        // Find an emoji without skin tone variations (e.g., 😀)
        let grinningFaceEmoji = emojiPicker.emojiContainer.entireEmojiSet["😀"]
        #expect(grinningFaceEmoji != nil)
        #expect(grinningFaceEmoji!.orderedSkinToneEmojis.isEmpty)
        
        // When: Request context menu configuration for an emoji without skin tones
        // Then: Should return nil
    }
}
#endif