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
import SwiftyXMLParser

/**
 A type that loads emoji's annotation and tts to already loaded emojis.

 The resources which this object loads are located at `Resources/CLDR/annotation`.

 The original resource is https://github.com/unicode-org/cldr/tree/main/common/annoatations
 - https://github.com/unicode-org/cldr/tree/main/common/annoatationsDerived

 This loader loads annotations and tts following the LSDM specification.

 - SeeAlso:
  - [LSDM](https://unicode.org/reports/tr35/)

 */
class EmojiAnnotationLoader: Loader {

    /**
     The emoji dictionary that contains all possible emojis for setting annotation and tts..
     */
    let emojiDictionary: [Emoji.ID : Emoji]

    /**
     The locale which specifies the emoji locale information for the loading.
     */
    let emojiLocale: EmojiLocale

    /**
     The URLs where the destination resources are located.
     */
    var resourceURLs: [URL] {
        return emojiLocale.annotationFileURLs
    }

    /**
     Creates an *Emoji Annotation Loader* instance by the given locale.

     - Parameters:
       - emojiDictionary: The dictionary which the key is a `Character` and the value is a `Emoji`, for setting annotation and tts.
       - emojiLocale:The locale which specifies the emoji locale information for the loading. `Emoji` annotation and textToSpeech are loaded following the given locale.
     */
    init(emojiDictionary: [Emoji.ID: Emoji], emojiLocale: EmojiLocale) {

        self.emojiDictionary = emojiDictionary
        self.emojiLocale = emojiLocale

    }

    /**
     Loads an annotations data file for setting each emoji's annotation and tts property.
     */
    func load() {

        for resourceURL in resourceURLs {

            // In this source, we don't have to worry about resources file errors, because the files are managed by this module, not user.
            let annotationXMLData = try! Data(contentsOf: resourceURL)
            let xml = XML.parse(annotationXMLData)

            for annotation in xml.ldml.annotations.annotation {

                let cp = annotation.attributes["cp"] // The type is string
                let character = Character(cp!)

                /*
                 Some annotations are not for `.fullyQualified`, so we have to care that. This implementation is bit a complex.
                 When the cp indicate minimally-qualified or unqualified emoji, assigns values to the fully-qualified version by referring the `fullyQualifiedVersion` property.
                 */

                let targetEmoji: Emoji? = emojiDictionary[character]

                if annotation.attributes["type"] == "tts" {

                    targetEmoji?.textToSpeech = annotation.text!
                    targetEmoji?.fullyQualifiedVersion?.textToSpeech = annotation.text!

                } else {

                    targetEmoji?.annotation = annotation.text!
                    targetEmoji?.fullyQualifiedVersion?.annotation = annotation.text!

                }

            }

        }

    }

}
