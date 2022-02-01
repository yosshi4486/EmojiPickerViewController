//
//  EmojiAnnotationLoader.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by yosshi4486 on 2022/02/01.
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
 A type that loads emoji's annotations and tts to already loaded emojis.

 The resources which this object loads are located at `Resources/CLDR/annotations` and `Resources/CLDR/annotationsDerived`.

 The original resources are:
 - https://github.com/unicode-org/cldr/tree/main/common/annoatations
 - https://github.com/unicode-org/cldr/tree/main/common/annoatationsDerived

 This loader loads annotations and tts following the LSDM specification.

 - SeeAlso:
  - [LSDM](https://unicode.org/reports/tr35/)
 */
class EmojiAnnotationLoader: Loader {

    /**
     The locale for which loads annotations.

     This object loads locale-specific annotations in `load()` method, following this `locale` property.
     */
    var locale: Locale

    /**
     The emoji dictionary that contains all possible emojis for setting annotations and tts..
     */
    let emojiDictionary: [Emoji.ID : Emoji]

    /**
     Creates an *Emoji Annotation Loader* instance by the given locale.

     - Parameters:
       - emojiDictionary: The dictionary which the key is a `Character` and the value is a `Emoji`, for setting annotations and tts.
       - locale: The locale for which loads annotations.
     */
    init(emojiDictionary: [Emoji.ID: Emoji], locale: Locale) {
        self.emojiDictionary = emojiDictionary
        self.locale = locale
    }

    func load() {

    }

}
