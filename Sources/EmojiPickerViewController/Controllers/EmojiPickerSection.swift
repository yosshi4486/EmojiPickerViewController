//
//  EmojiPickerSection.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
//
//  Created by yosshi4486 on 2022/02/08.
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
 An section of emoji picker.

 */
enum EmojiPickerSection: Int, CaseIterable {

    /**
     The section for emojis that the user recently used.

     This section should not appear while `.searchResult` is appeared.
     */
    case recentlyUsed

    /**
     The section for the search result's emoji.

     This section should not appear while `.recentlyUsed` is appeared.
     */
    case searchResult

    /**
     The section for emojis which the label is `Smileys & People`.
     */
    case smileysPeople

    /**
     The section for emojis which the label is `Animals & Nature`.
     */
    case animalsNature

    /**
     The section for emojis which the label is `Food & Dring`.
     */
    case foodDrink

    /**
     The section for emojis which the label is `Travel & Places`.
     */
    case travelPlaces

    /**
     The section for emojis which the label is `Activities`.
     */
    case activities

    /**
     The section for emojis which the label is `Objects`.
     */
    case objects

    /**
     The section for emojis which the label is `Symbols`.
     */
    case symbols

    /**
     The section for emojis which the label is `Flags`.
     */
    case flags

    /**
     Creates an *Emoji Label* instance by the ginve `emojiLabel`.

     - Parameters:
       - emojiLabel: The label of the emoji.
     */
    init(emojiLabel: EmojiLabel) {
        switch emojiLabel {
        case .smileysPeople:
            self = .smileysPeople

        case .animalsNature:
            self = .animalsNature

        case .foodDrink:
            self = .foodDrink

        case .travelPlaces:
            self = .travelPlaces

        case .activities:
            self = .activities

        case .objects:
            self = .objects

        case .symbols:
            self = .symbols

        case .flags:
            self = .flags
        }
    }

    /**
     The localized section name.

     The property to be used as section header title.
     */
    var localizedSectionName: String {

        switch self {

        case .recentlyUsed:
            return NSLocalizedString("recently_used", bundle: .module, comment: "Collection header title: indicates in which the emojis is categorized.")

        case .searchResult:
            return NSLocalizedString("search_result", bundle: .module, comment: "Collection header title: indicates in which the emojis is categorized.")

        case .smileysPeople:
            return NSLocalizedString("smileys_people", bundle: .module, comment: "Collection header title: indicates in which the emojis is categorized.")

        case .animalsNature:
            return NSLocalizedString("animals_nature", bundle: .module, comment: "Collection header title: indicates in which the emojis is categorized.")

        case .foodDrink:
            return NSLocalizedString("food_drink", bundle: .module, comment: "Collection header title: indicates in which the emojis is categorized.")

        case .travelPlaces:
            return NSLocalizedString("travel_places", bundle: .module, comment: "Collection header title: indicates in which the emojis is categorized.")

        case .activities:
            return NSLocalizedString("activities", bundle: .module, comment: "Collection header title: indicates in which the emojis is categorized.")

        case .objects:
            return NSLocalizedString("objects", bundle: .module, comment: "Collection header title: indicates in which the emojis is categorized.")

        case .symbols:
            return NSLocalizedString("symbols", bundle: .module, comment: "Collection header title: indicates in which the emojis is categorized.")

        case .flags:
            return NSLocalizedString("flags", bundle: .module, comment: "Collection header title: indicates in which the emojis is categorized.")

        }

    }

    /**
     The image for segmented control.

     # Accessibility
     UISegmentedControl speak its accessibilityLabel like a "Smileys & People category, 1 of 8", which the "8" is the number of the segments and the "1" is the index of the focused segment.
     */
    var imageForSegmentedControlElement: UIImage {

        switch self {
        case .recentlyUsed:

            let image = UIImage(systemName: "clock")!
            image.accessibilityLabel = NSLocalizedString("ax_segmented_control_recently_used", bundle: .module, comment: "AX segmented control label: speaks which segment did select.")
            return image

        case .searchResult:

            let image = UIImage(systemName: "clock")!
            image.accessibilityLabel = NSLocalizedString("ax_segmented_control_search_result", bundle: .module, comment: "AX segmented control label: speaks which segment did select.")
            return image

        case .smileysPeople:

            let image = UIImage(systemName: "face.smiling")!
            image.accessibilityLabel = NSLocalizedString("ax_segmented_control_smileys_people", bundle: .module, comment: "AX segmented control label: speaks which segment did select.")
            return image

        case .animalsNature:

            let image = UIImage(systemName: "leaf")!
            image.accessibilityLabel = NSLocalizedString("ax_segmented_control_animals_nature", bundle: .module, comment: "AX segmented control label: speaks which segment did select.")
            return image

        case .foodDrink:

            let image = UIImage(systemName: "fork.knife")!
            image.accessibilityLabel = NSLocalizedString("ax_segmented_control_food_drink", bundle: .module, comment: "AX segmented control label: speaks which segment did select.")
            return image

        case .travelPlaces:

            let image = UIImage(systemName: "airplane")!
            image.accessibilityLabel = NSLocalizedString("ax_segmented_control_travel_places", bundle: .module, comment: "AX segmented control label: speaks which segment did select.")
            return image

        case .activities:

            let image = UIImage(systemName: "paintpalette")!
            image.accessibilityLabel = NSLocalizedString("ax_segmented_control_activities", bundle: .module, comment: "AX segmented control label: speaks which segment did select.")
            return image

        case .objects:

            let image = UIImage(systemName: "lightbulb")!
            image.accessibilityLabel = NSLocalizedString("ax_segmented_control_objects", bundle: .module, comment: "AX segmented control label: speaks which segment did select.")
            return image

        case .symbols:
            let image = UIImage(systemName: "number")!
            image.accessibilityLabel = NSLocalizedString("ax_segmented_control_symbols", bundle: .module, comment: "AX segmented control label: speaks which segment did select.")
            return image

        case .flags:

            let image = UIImage(systemName: "flag")!
            image.accessibilityLabel = NSLocalizedString("ax_segmented_control_flags", bundle: .module, comment: "AX segmented control label: speaks which segment did select.")
            return image

        }
    }

}
