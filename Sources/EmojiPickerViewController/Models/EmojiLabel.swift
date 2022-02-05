//
//  EmojiLabel.swift
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
 A label which categorizes emojis.

 - Note:
 For emoji, `group` and `label` are different. unicode-org/cldr has a `labels.text` file for labeling emojis, but parsing it and setting lables to emojis takes time and effort, so we decided to compute the label from `group` for ease.

 - SeeAlso: [unicode-org/cldr/common/properties/label.txt](https://github.com/unicode-org/cldr/blob/main/common/properties/labels.txt)
 */
public enum EmojiLabel: String, CaseIterable {

    case smileysPeople

    case animalsNature

    case foodDrink

    case travelPlaces

    case activities

    case objects

    case symbols

    case flags

    init?(group: String) {

        switch group {

        case "Smileys & Emotion", "People & Body":
            self = .smileysPeople

        case "Animals & Nature":
            self = .animalsNature

        case "Food & Drink":
            self = .foodDrink

        case "Travel & Places":
            self = .travelPlaces

        case "Activities":
            self = .activities

        case "Objects":
            self = .objects

        case "Symbols":
            self = .symbols

        case "Flags":
            self = .flags

        default: // "Component" or future added unknown groups returns nil.
            return nil

        }

    }

    /**
     The label of the emoji, which is used as category as usual.
     */
    public var localizedDescription: String? {

        return NSLocalizedString(String(describing: self), bundle: .module, comment: "Emoji label: groups emojis into Smileys & People.")

    }

}
