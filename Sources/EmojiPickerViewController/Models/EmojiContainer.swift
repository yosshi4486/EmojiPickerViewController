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

#if canImport(UIKit)
import UIKit
#endif

import Foundation
import Collections

/**
 A container object for loading, storing and updating stored emojis.
*/
public class EmojiContainer: Loader {

    /**
     Posts when the current annotations changes.

     The posting object is a EmojiLocale instance.
     */
    public static let currentAnnotationDidChangeNotification = Notification.Name(rawValue: "_currentAnnotationDidChangeNotification")

    /**
     The key for which stores recently used emojis.
     */
    public static let recentlyUsedEmojiKey: String = "_emojiPickerViewController_recentlyUsedEmojiKey"

    /**
     The `main` container instance for operating emojis. You can only access to `main`.
     */
    public static let main = EmojiContainer()

    /**
     The number of items that the system stores and presents as `recentlyUsed`. The default value is `30`.
     */
    public var maximumNumberOfItemsForRecentlyUsed: Int = 30

    /**
     The key-value storage for which stores recently used emojis. The default value is `.standard`.
     */
    public var userDefaults: UserDefaults = .standard

    /**
     The boolean value indicating whether this container automatically updates annotations following `UITextInputMode.currentInputModeDidChangeNotification`. The default value is `false`.
     */
    public var automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange: Bool = false

    /**
     The locale which specifies the emoji locale information for the loading.
     */
    public var emojiLocale: EmojiLocale = .default

    /**
     The emoji loader.
     */
    private let emojiLoader = EmojiLoader()

    /**
     The emoji dictionary for which provides entire emoji-set. This contains emojis that iOS can not present or are only semantic variations. The dictionary is empty before an initial call of `load()`.

     The emoji dictionary are desinged for searching an emoji from the entire set. The references of contained emojis are shared with `labeledEmojisForKeyboard`.
     */
    public var entireEmojiSet: [Emoji.ID : Emoji] { emojiLoader.entireEmojiSet }

    /**
     The emoji dictionary which provides a subset for a keyboard or picker experience. The array is empty before an initial call of `load()`.

     This ordered emoji array are desinged for implementing a keyboard view or picker view. The references of contained emojis are shared with `entireEmojiSet`
     */
    public var labeledEmojisForKeyboard: OrderedDictionary<EmojiLabel, [Emoji]> { emojiLoader.labeledEmojisForKeyboard }

    /**
     The boolean value indicating whether the `load()` has already called.
     */
    public var isLoaded: Bool {
        return !entireEmojiSet.isEmpty
    }

    /**
     The emojis which are recently used by the user.

     Although the recently used emojis have already save, the value returns empty array if the `entireEmojiSet` has not loaded yet, so please call `load()` before getting this property.
     */
    var recentlyUsedEmojis: [Emoji] {
        let internalStrings: [String] = (userDefaults.array(forKey: EmojiContainer.recentlyUsedEmojiKey) as? [String]) ?? []
        return internalStrings.compactMap({ entireEmojiSet[$0[$0.startIndex]] })
    }

    init() {

#if os(iOS)
        NotificationCenter.default.addObserver(self, selector: #selector(updateAnnotationsAutomatically(_:)), name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
#endif

    }

    deinit {

#if os(iOS)
        NotificationCenter.default.removeObserver(self, name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
#endif

    }

    /**
     Loads emojis and annotations.

     After an initial call of this method, you should use `loadAnnotations()` rather than calling `load()`  again,  because this method replaces both cached `emojiDictionary` and `orderedEmojisForKeyboard`.
     */
    @MainActor public func load() {

        emojiLoader.load()
        loadAnnotations()

    }

    /**
     Loads annotations following `languageIdentifiers`.

     - Precondition:
     This method should be called when the emoji-set is loaded.
     */
    @MainActor public func loadAnnotations() {

        precondition(!entireEmojiSet.isEmpty && !labeledEmojisForKeyboard.isEmpty, "Logical Failure, `load()` should be called before `loadAnnotations()`.")

        let annotationLoader = EmojiAnnotationLoader(emojiDictionary: entireEmojiSet, emojiLocale: emojiLocale)
        annotationLoader.load()

        let annotationDerivedLoader = EmojiAnnotationDerivedLoader(emojiDictionary: entireEmojiSet, emojiLocale: emojiLocale)
        annotationDerivedLoader.load()

    }

    /**
     Returns emojis which contains the given keyword in `annotation` property. minimally-qualified emojis , unqualified emojis and emoji modifier sequences (skintoned emoji) are ignored from search targets.

     - Precondition:
     This method should be called after an initial call of `load()`.

     - Complexity:
     O(n * m * o) where n is the number of elements in the ordered emoji array, m is the length of the annotation sequence and m is the length of the word in annotation, however we don't have to worry the cost too much, because the size of computation must be enough small (n is 1300~1400, m is 2~5, n is 3 ~15).
     */
    public func searchEmojisForKeyboard(from keyword: String) -> [Emoji] {

        precondition(!entireEmojiSet.isEmpty && !labeledEmojisForKeyboard.isEmpty)

        return labeledEmojisForKeyboard
            .values
            .joined()
            .filter({ $0.annotation.split(separator: "|").contains(where: { $0.trimmingCharacters(in: .whitespaces).starts(with: keyword) }) })

    }

    /**
     An async interface of `searchEmojisForKeyboard(from:)`.

     Using this async interface is recommented for providing resut-set in picker or keyboard.
     */
    public func searchEmojisForKeyboard(from keyboard: String) async -> [Emoji] {
        precondition(!entireEmojiSet.isEmpty && !labeledEmojisForKeyboard.isEmpty)

        return await withCheckedContinuation({ continuation in
            DispatchQueue.global(qos: .userInitiated).async { [unowned self] in
                let searchResults = self.searchEmojisForKeyboard(from: keyboard)
                continuation.resume(returning: searchResults)
            }
        })

    }

    /**
     Stores the given emoji as recently used. Actually, this method only saves its `id` property as `String`.

     The head element is poped if the number of recently used emoji exceeds `maximumNumberOfItemsForRecentlyUsed`.

     For example:
     ```swift
     EmojiContainer.main.load()

     EmojiContainer.main.maximumNumberOfItemsForRecentlyUsed = 3
     EmojiContainer.main.saveRecentlyUsedEmoji(Emoji("👌"))
     EmojiContainer.main.saveRecentlyUsedEmoji(Emoji("😵‍💫"))
     EmojiContainer.main.saveRecentlyUsedEmoji(Emoji("🍇"))

     print(EmojiContainer.main.recentlyUsedEmoji.map(\.character)
     Print ["👌", "😵‍💫", "🍇"]

     EmojiContainer.main.saveRecentlyUsedEmoji(Emoji("🛫"))
     print(EmojiContainer.main.recentlyUsedEmoji.map(\.character)
     Print ["😵‍💫", "🍇", "🛫"]
     ```
     */
    func saveRecentlyUsedEmoji(_ emoji: Emoji) {

        var internalStrings: [String] = (userDefaults.array(forKey: EmojiContainer.recentlyUsedEmojiKey) as? [String]) ?? []
        if internalStrings.count >= maximumNumberOfItemsForRecentlyUsed {
            internalStrings.removeFirst()
        }
        internalStrings.append(String(emoji.character))
        userDefaults.set(internalStrings, forKey: EmojiContainer.recentlyUsedEmojiKey)

    }


#if os(iOS)
    @MainActor @objc private func updateAnnotationsAutomatically(_ notification: Notification) {

        guard automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange, let primaryLanguage = (notification.object as? UITextInputMode)?.primaryLanguage else {
            return
        }

        guard let autoUpdatingResource = EmojiLocale(localeIdentifier: primaryLanguage) else {
            return
        }

        emojiLocale = autoUpdatingResource
        loadAnnotations()

        NotificationCenter.default.post(name: EmojiContainer.currentAnnotationDidChangeNotification, object: autoUpdatingResource)
        
    }
#endif

}
