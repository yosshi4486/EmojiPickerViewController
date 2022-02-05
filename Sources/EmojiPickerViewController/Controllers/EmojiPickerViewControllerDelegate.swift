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
 */
public protocol EmojiPickerViewControllerDelegate: AnyObject {

    /**
     Notifies the delegate that the user completed a selection or dismissed the picker.

     The view controller doesn't dismiss automatically. The owner should explicitly call `emojiPickerViewController.dismiss()`.

     - Parameters:
       - emojiPickerViewController: The view controller that is presenting the emoji picker.
       - emoji: The emoji that is picked by the user.
     */
    func emojiPickerViewController(_ emojiPickerViewController: EmojiPickerViewController, didFinishPicking emoji: Emoji)

    /**
     Notifies the delegate that the emoji picker view controller receives error.

     The view controller doesn't dismiss automatically. The owner should explicitly call `emojiPickerViewController.dismiss()`.

     - Parameters:
       - emojiPickerViewController: The view controller that is presenting the emoji picker.
       - error: The error that is raised in the emoji picker view controller.
     */
    func emojiPickerViewController(_ emojiPickerViewController: EmojiPickerViewController, didReceiveError error: Error)

}
