//
//  EmojiPickerConfiguration.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by yosshi4486 on 2022/02/12.
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

#if os(iOS)
import UIKit

/**
 An object that contains information about how to configure a emoji picker view controller.
 */
public struct EmojiPickerConfiguration {

    /**
     An object that contains information about how to configure an appearance of emoji category section header.
     */
    public struct HeaderAppearance {

        /**
         The font for the header label.
         */
        public var font: UIFont = UIFont.preferredFont(forTextStyle: .headline)

        /**
         The text color for the header label.
         */
        public var textColor: UIColor = .label

        /**
         The text alignment for the header label.
         */
        public var textAlignment: NSTextAlignment = .natural

        /**
         The background color for the header view.
         */
        public var backgroundColor: UIColor = .systemBackground

        /**
         The padding for the header label.
         */
        public var labelPadding: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)

    }

    /**
     An object that contains information about how to configure an appearance of each emoji cell.
     */
    public struct CellAppearance {

        /**
         The size for each emoji cell.

         The number of emojis in a horizontal line depends on this `size` property.
         */
        public var size: CGSize = .init(width: 50, height: 50)

    }

    /**
     The boolean value indicating whether the collectionview animates changes. The default value is `false`.
     */
    public var animatingChanges: Bool = false

    /**
     The number of items that the picker view controller presents emojis in `recentlyUsed` section. The default value is `30`.

     The picker view controller doesn't present recently used section if the value is `zero`.
     */
    public var numberOfItemsInRecentlyUsedSection: Int = 30

    /**
     The appearance for each emoji category section header.
     */
    public var headerAppearance: HeaderAppearance = .init()

    /**
     The appearance for each emoji cell.
     */
    public var cellAppearance: CellAppearance = .init()

    /**
     Creates an *Emoji Picker Configuration* instance.
     */
    public init() {}
    
}
#endif
