//
//  EmojiPickerViewControllerDelegate.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by yosshi4486 on 2022/02/05.
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

/**
 A protocol the picker uses to communicate user selections.

 `UIAdaptivePresentationControllerDelegate` can be used to detect dismissing of *Emoji Picker View Controller*.
 */
@MainActor public protocol EmojiPickerViewControllerDelegate: AnyObject {

    /**
     Tells the delegate that the user completed a picking.

     The view controller doesn't dismiss automatically after this delegate event. The owner should explicitly call `emojiPickerViewController.dismiss()`.

     - Parameters:
       - emojiPickerViewController: The view controller that is presenting the emoji picker.
       - emoji: The emoji that is picked by the user.
     */
    func emojiPickerViewController(_ emojiPickerViewController: EmojiPickerViewController, didPick emoji: Emoji)

    /**
     Tells the delegate that the user begins searching emojis.

     The default implementation does nothing.

     - Parameters:
       - emojiPickerViewController: The view controller that is presenting the emoji picker.
     */
    func emojiPickerViewControllerDidBeginSearching(_ emojiPickerViewController: EmojiPickerViewController)

    /**
     Tells the delegate that the user ends searching emojis.

     The default implementation does nothing.

     - Parameters:
       - emojiPickerViewController: The view controller that is presenting the emoji picker.
     */
    func emojiPickerViewControllerDidEndSearching(_ emojiPickerViewController: EmojiPickerViewController)

}

public extension EmojiPickerViewControllerDelegate {

    func emojiPickerViewControllerDidBeginSearching(_ emojiPickerViewController: EmojiPickerViewController) { }

    func emojiPickerViewControllerDidEndSearching(_ emojiPickerViewController: EmojiPickerViewController) { }

}
