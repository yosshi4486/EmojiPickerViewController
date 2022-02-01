//
//  EmojiContainer.swift.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by yosshi4486 on 2022/01/31.
//
// ----------------------------------------------------------------------------
//
//  © 2022  yosshi4486
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

import Foundation
import UIKit

/**
 A container object for loading, storing and updating stored emojis.
 */
public class EmojiContainer {

    /**
     The `main` container instance for operating emojis. You can only access to `main`.
     */
    public static let main = EmojiContainer()

    /**
     The boolean value indicating whether this container automatically updates annotations following `UITextInputMode.currentInputModeDidChangeNotification`. The default value is `true`.
     */
    public var automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange: Bool = true

    internal(set) public var emojiDictionary: [Emoji.ID : Emoji] = [:]

    internal(set) public var orderedEmojisForKeyboard: [Emoji] = []

    private let emojiLoader = EmojiLoader()

    init() {

        // 1. Load emoji

        // 2. Load initial annotation and tts

        // 3. Register `UITextInputMode.currentInputModeDidChangeNotification`

    }

    public func searchEmojis(from keyboard: String) -> [Emoji] {

        // Test performances array filter and regex.
        fatalError("Should be implemented.")
    }

    public func updateAnnotations(with locale: Locale) {

    }

    private func updateAnnotationsAutomatically(_ notification: Notification) {

        guard automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange, let mode = notification.object as? UITextInputMode else {
            return
        }

        let annotationLanguage: String = mode.primaryLanguage ?? Locale.preferredLanguages[0]
        updateAnnotations(with: Locale(identifier: annotationLanguage))

    }

}
