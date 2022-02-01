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
import UIKit

/**
 A type that loads emoji's annotation and tts to already loaded emojis.

 The resources which this object loads are located at `Resources/CLDR/annotation` and `Resources/CLDR/annotationsDerived`.

 The original resources are:
 - https://github.com/unicode-org/cldr/tree/main/common/annoatations
 - https://github.com/unicode-org/cldr/tree/main/common/annoatationsDerived

 This loader loads annotations and tts following the LSDM specification.

 - SeeAlso:
  - [LSDM](https://unicode.org/reports/tr35/)
 */
class EmojiAnnotationLoader: Loader {

    /**
     An error type that occurs in *Emoji Annotation Loader*.
     */
    enum Error: Swift.Error {

        /**
         An error that an annotation file associated with the language codes is not found. The associated value is language codes.
         */
        case annotationFileNotFound([String])

    }

    /**
     The BCP 47 language identifiers for which loads annotations, such as "es", “en-US”, or “fr-CA”. The first identifier is loaded first, and if it fails to load, the next identifier is checked. This continues until the end of the array.

     This object loads locale-specific annotations in `load()` method, following this `languageIdentifiers` property.
     */
    var languageIdentifiers: [String]

    /**
     The emoji dictionary that contains all possible emojis for setting annotation and tts..
     */
    let emojiDictionary: [Emoji.ID : Emoji]

    /**
     Creates an *Emoji Annotation Loader* instance by the given locale.

     For example:

     ```swift
     let defaultIdentifier = "en" // defaultIdentifier.xml must be located at Resources/CLDR/annotations or Resources/CLDR/annotationsDerived.

     let identifiers: [String] = [currenttTextInputMode.primaryLanguage!] + Locale.preferredLanguages + [defaultIdentifier] // Located as last element is better for a loading stabilizer.
     let loader = EmojiAnnotationLoader(emojiDictionary: emojiDictionary, languageIdentifiers: identifiers)
     do {
         try loader.load()
     } catch {
         print(error)
     }
     ```

     - Parameters:
       - emojiDictionary: The dictionary which the key is a `Character` and the value is a `Emoji`, for setting annotation and tts.
       - languageIdentifiers: The BCP 47 language identifiers for which loads annotations. At least, you should give one identifier that makes sure to be able to load. It helps to avoid throwing a `annotationFileNotFound` error.
     */
    init(emojiDictionary: [Emoji.ID: Emoji], languageIdentifiers: [String]) {

        self.emojiDictionary = emojiDictionary
        self.languageIdentifiers = languageIdentifiers

    }

    /**
     Loads an annotations data file for setting each emoji's annotation and tts property.
     */
    func load() throws {

        var annotationsFileURL: URL?

        for languageCode in languageIdentifiers {
            annotationsFileURL = resourceURL(for: languageCode)

            if annotationsFileURL != nil {
                break
            }
        }

        guard let annotationsFileURL = annotationsFileURL else {
            throw Error.annotationFileNotFound(languageIdentifiers)
        }

        // In this source, we don't have to worry about resources file errors, because the files are managed by this module, not user.
        let annotationXMLData = try! Data(contentsOf: annotationsFileURL)
        let xml = XML.parse(annotationXMLData)

        for annotation in xml.ldml.annotations.annotation {

            let cp = annotation.attributes["cp"] // The type is string
            let character = Character(cp!)

            // is tts type.
            if annotation.attributes["type"] == "tts" {

                emojiDictionary[character]?.textToSpeach = annotation.text!

            } else {

                emojiDictionary[character]?.annotation = annotation.text!
                
            }

        }

    }

    func resourceURL(for languageIdentifier: String) -> URL? {

        let identifier = languageIdentifier.replacingOccurrences(of: "-", with: "_")
        return bundle.url(forResource: identifier, withExtension: "xml")

    }

}
