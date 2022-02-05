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

 - TODO:
 This class is not thread safe, it doesn't do anything about data race. Implements as `actor`?
 */
public class EmojiContainer: Loader {

    /**
     The `main` container instance for operating emojis. You can only access to `main`.
     */
    public static let main = EmojiContainer()

    /**
     The boolean value indicating whether this container automatically updates annotations following `UITextInputMode.currentInputModeDidChangeNotification`. The default value is `false`.
     */
    public var automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange: Bool = false

    /**
     The BCP 47  language identifiers are actually used to load emoji's annotations.

     This container uses the `currentInputMode.primaryLanguage` as primary identifier when the `automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange` is true. Otherwise; the value is completely equal to `preferredLanguageIdentifiers`.
     */
    public var languageIdentifiers: [String] {

        if automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange, let currentPrimaryLanguage = currentInputMode?.primaryLanguage {
            return [currentPrimaryLanguage] + preferredLanguageIdentifiers
        } else {
            return preferredLanguageIdentifiers
        }

    }

    /**
     The BCP 47  language identifiers to load emoji's annotations. The default value is empty.
     */
    public var preferredLanguageIdentifiers: [String] = []

    /**
     The current input mode is getting from `UITextInputMode.currentInputModeDidChangeNotification`.
     */
    private var currentInputMode: UITextInputMode?

    /**
     The emoji loader.
     */
    private let emojiLoader = EmojiLoader()

    /**
     The entire emoji dictionary that has emojis listed in `emoji-test.txt`. The key is a character and the value is an emoji object. The dictionary is empty before an initial call of `load()`.

     The emoji dictionary are desinged for searching an emoji by specifying the character. The references of contained emojis are shared with `orderedEmojisForKeyboard`.
     */
    public var emojiDictionary: [Emoji.ID : Emoji] { emojiLoader.wholeEmojiDictionary }

    /**
     The ordered emoji array for keyboard presentation, which the emoji's status is `.fullyQualified`. The array doesn't contain modifier sequences. The array is empty before an initial call of `load()`.

     This ordered emoji array are desinged for implementing a keyboard view or picker view.
     */
    public var orderedEmojisForKeyboard: [Emoji] { emojiLoader.fullyQualifiedOrderedEmojisForKeyboard }

    init() {

        NotificationCenter.default.addObserver(self, selector: #selector(updateAnnotationsAutomatically(_:)), name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)

    }

    deinit {

        NotificationCenter.default.removeObserver(self, name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)

    }

    /**
     Loads emojis and annotations.

     After an initial call of this method, you should use `loadAnnotations()` rather than calling `load()`  again,  because this method replaces both cached `emojiDictionary` and `orderedEmojisForKeyboard`.
     */
    @MainActor public func load() throws {

        emojiLoader.load()
        try loadAnnotations()

    }

    /**
     Loads annotations following `languageIdentifiers`.

     - Precondition:
     This method should be called when the emoji-set is loaded.
     */
    @MainActor public func loadAnnotations() throws {

        precondition(!emojiDictionary.isEmpty && !orderedEmojisForKeyboard.isEmpty, "Logical Failure, `load()` should be called before `loadAnnotations()`.")

        let annotationLoader = EmojiAnnotationLoader(emojiDictionary: emojiDictionary, languageIdentifiers: languageIdentifiers)
        try annotationLoader.load()

        let annotationDerivedLoader = EmojiAnnotationDerivedLoader(emojiDictionary: emojiDictionary, languageIdentifiers: languageIdentifiers)
        try annotationDerivedLoader.load()

    }

    /**
     Returns emojis which contains the given keyword in `annotation` property. minimally-qualified emojis , unqualified emojis and emoji modifier sequences (skintoned emoji) are ignored from search targets.

     - Precondition:
     This method should be called after an initial call of `load()`.

     - Complexity:
     O(n * m * o) where n is the number of elements in the ordered emoji array, m is the length of the annotation sequence and m is the length of the word in annotation, however we don't have to worry the cost too much, because the size of computation must be enough small (n is 1300~1400, m is 2~5, n is 3 ~15).
     */
    public func searchEmojisForKeyboard(from keyword: String) -> [Emoji] {

        precondition(!emojiDictionary.isEmpty && !orderedEmojisForKeyboard.isEmpty)

        return orderedEmojisForKeyboard.filter({ $0.annotation.split(separator: "|").contains(where: { $0.trimmingCharacters(in: .whitespaces).starts(with: keyword) }) })

    }

    /**
     An async interface of `searchEmojisForKeyboard(from:)`.

     Using this async interface is recommented for providing resut-set in picker or keyboard.
     */
    public func searchEmojisForKeyboard(from keyboard: String) async -> [Emoji] {
        precondition(!emojiDictionary.isEmpty && !orderedEmojisForKeyboard.isEmpty)

        return await withCheckedContinuation({ continuation in
            DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
                let searchResults = self.searchEmojisForKeyboard(from: keyboard)
                continuation.resume(returning: searchResults)
            }
        })

    }


    @MainActor @objc private func updateAnnotationsAutomatically(_ notification: Notification) {

        guard automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange, let mode = notification.object as? UITextInputMode else {
            return
        }

        currentInputMode = mode
        try? loadAnnotations()

    }

}
