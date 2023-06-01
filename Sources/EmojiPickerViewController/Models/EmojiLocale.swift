//
//  EmojiLocale.swift
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

import Foundation

/**
 A locale for which loads the associated language specific files.

 An `EmojiContainer`instance reads `annotations/{localeID}.xml` and `annotationsDerived/{localeID}.xml` to fill the emoji's `annotation` and `textToSpeach` properties. This object specified the locale information for which file should be loaded.

 # Reading Difference
 Please see `Resources/CLDR/annotations/af` and `Resources/CLDR/annotations/af_SA`, you can see the first one describes many emojis and the second one describes very few emojis. The rule is that an annotation file which has the region resignator only describes regional differences between the base annotation file. The base annotation is `af` in this case.

 Following the specification, *Emoji Locale* have a base annotation file and the reginal specified annotation file if possible.

 - SeeAlso:
 [Language and Locale IDs](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html)

 */
public struct EmojiLocale {

    /**
     The default locale. You can change the static default.
     */
    static let `default` = EmojiLocale(localeIdentifier: "en")!

    /**
     The comprehensive list of available identifiers.

     The `annotations` directory now contains two more files (namely `ha_NE` and `ku`)  than the `annotationDerived` directory. `availableIdentifiers` returns the identifiers of al files in the `annotation` directory.
     */
    static let availableIdentifiers: [String] = {

        return [
            "af",
            "am",
            "ar",
            "ar_SA",
            "as",
            "ast",
            "az",
            "be",
            "bg",
            "bn",
            "br",
            "bs",
            "ca",
            "ccp",
            "ceb",
            "chr",
            "ckb",
            "cs",
            "cy",
            "da",
            "de",
            "de_CH",
            "doi",
            "dsb",
            "el",
            "en",
            "en_001",
            "en_AU",
            "en_CA",
            "en_GB",
            "en_IN",
            "es",
            "es_419",
            "es_MX",
            "es_US",
            "et",
            "eu",
            "fa",
            "fi",
            "fil",
            "fo",
            "fr",
            "fr_CA",
            "ga",
            "gd",
            "gl",
            "gu",
            "ha",
            "he",
            "hi",
            "hr",
            "hsb",
            "hu",
            "hy",
            "ia",
            "id",
            "ig",
            "is",
            "it",
            "ja",
            "jv",
            "ka",
            "kab",
            "kk",
            "km",
            "kn",
            "ko",
            "kok",
            "ky",
            "lb",
            "lo",
            "lt",
            "lv",
            "mai",
            "mi",
            "mk",
            "ml",
            "mn",
            "mni",
            "mr",
            "ms",
            "mt",
            "my",
            "ne",
            "nl",
            "nn",
            "no",
            "or",
            "pa",
            "pcm",
            "pl",
            "ps",
            "pt",
            "pt_PT",
            "qu",
            "rm",
            "ro",
            "root",
            "ru",
            "sa",
            "sat",
            "sc",
            "sd",
            "si",
            "sk",
            "sl",
            "so",
            "sq",
            "sr",
            "sr_Cyrl",
            "sr_Cyrl_BA",
            "sr_Latn",
            "sr_Latn_BA",
            "su",
            "sv",
            "sw",
            "sw_KE",
            "ta",
            "te",
            "tg",
            "th",
            "ti",
            "tk",
            "to",
            "tr",
            "tt",
            "ug",
            "uk",
            "ur",
            "uz",
            "vi",
            "wo",
            "yo",
            "yo_BJ",
            "yue",
            "yue_Hans",
            "zh",
            "zh_Hant",
            "zh_Hant_HK",
            "zu"
        ]

    }()

    /**
     The locale identifier which the accosiated annotations and annotationDerived files exist.
     */
    public let localeIdentifier: String

    let annotationFileURLs: [URL]

    let annotationDerivedFileURLs: [URL]

    /**
     Creates an *Emoji Locale* instance by the given locale identifier.

     The rule of locale ID joiners:
     - use _(underscore) before regional designator.
     - use -(hyphen) befoer script designator.

     For instance, "sr-Cyrl_BA", "sr" is language designator, "Cyrl" is script designator, "BA" is regional designator. Cyrl is joined by "-" and "BA" is joined by "_". Please check apple's document archive for details.

     *However*, this initialization can handle themas correct format if the identifier is "sr_Cyrl_BA" or "sr-Cyrl-BA"

     - Parameters:
       - localeIdentifier: The locale identifier which indicates the locale for whichloads annotations.

     - Note:
     we intentionally implement our EmojiLocale object rather than using Foundation.Locale, because a Foundation.Locale instance rounds the locale identifier following its rules, and the behavior makes our difficult to load the associated annotation files.

     - SeeAlso:
     LocaleFunctionalTests.testLocaleRoundIdentifer()
     
     */
    public init?(localeIdentifier: String) {

        /*
         we intentionally prepare Foundation.Locale rounds
         */

        var languageCode: String?
        var scriptCode: String?
        var regionCode: String?

        let underscoredLocaleIdentifier = localeIdentifier.replacingOccurrences(of: "-", with: "_")
        let idComponents = underscoredLocaleIdentifier.components(separatedBy: "_")

        if idComponents.count == 3 {

            // language-script_region

            languageCode = idComponents[0].isISO639LanguageCodeForm ? idComponents[0] : nil
            scriptCode = idComponents[1].isISO15924ScriptCodeForm ? idComponents[1] : nil
            regionCode = idComponents[2].isISO3166RegionCodeForm ? idComponents[2] : nil

        } else if idComponents.count == 2 {

            // language-script or language_region

            languageCode = idComponents[0].isISO639LanguageCodeForm ? idComponents[0] : nil
            if idComponents[1].isISO15924ScriptCodeForm {
                scriptCode = idComponents[1]
            } else if idComponents[1].isISO3166RegionCodeForm {
                regionCode = idComponents[1]
            }

        } else if idComponents.count == 1 {

            // language
            languageCode = idComponents[0].isISO639LanguageCodeForm ? idComponents[0] : nil

        }

        // Fails the initialization if there is no language code.
        guard let languageCode = languageCode else {
            return nil
        }

        let baseAnontationFilename: String = {

            if let scriptCode = scriptCode {
                return "\(languageCode)_\(scriptCode)"
            } else {
                return "\(languageCode)"
            }

        }()

        let regionalAnnotationFilename: String? = {

            if let regionCode = regionCode {
                return "\(baseAnontationFilename)_\(regionCode)"
            } else {
                return nil
            }

        }()

        let annotationFileURLs: [URL] = {

            var urls: [URL] = []

            if let baseFileURL = EmojiLocale.annotationResource(for: baseAnontationFilename) {
                urls.append(baseFileURL)
            }

            if let regionalAnnotationFilename = regionalAnnotationFilename, let regionalFileURL = EmojiLocale.annotationResource(for: regionalAnnotationFilename) {
                urls.append(regionalFileURL)
            }

            return urls

        }()

        let annotationDerivedFileURLs: [URL] = {

            var urls: [URL] = []

            if let baseFileURL = EmojiLocale.annotationDerivedResource(for: baseAnontationFilename) {
                urls.append(baseFileURL)
            }

            if let regionalAnnotationFilename = regionalAnnotationFilename, let regionalFileURL = EmojiLocale.annotationDerivedResource(for: regionalAnnotationFilename) {
                urls.append(regionalFileURL)
            }

            return urls

        }()

        guard !annotationFileURLs.isEmpty && !annotationDerivedFileURLs.isEmpty else {
            return nil
        }

        assert(annotationFileURLs.count == annotationDerivedFileURLs.count, "The annotation file should have the associated derived annotation file. `Resources` directory may have some problem.")

        self.localeIdentifier = localeIdentifier
        self.annotationFileURLs = annotationFileURLs
        self.annotationDerivedFileURLs = annotationDerivedFileURLs

    }

    static func annotationResource(for identifier: String) -> URL? {
        return Bundle.module.url(forResource: identifier, withExtension: "xml")
    }

    static func annotationDerivedResource(for identifier: String) -> URL? {
        return Bundle.module.url(forResource: "\(identifier)_derived", withExtension: "xml")
    }

}

extension String {

    /**
     The boolean value indicating whether self follows ISO639 language code's form. (e.g)  hsb, de, ja, en

     Since this checker only checks the form, the string may not be valid language code.

     - SeeAlso:
       - [Language and Locale IDs](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html)
       - [Codes for the Representation of Names of Languages](https://www.loc.gov/standards/iso639-2/php/English_list.php)
     */
    var isISO639LanguageCodeForm: Bool {

        guard count == 2 || count == 3 else {
            return false
        }

        return allSatisfy({ $0.isASCII && $0.isLowercase })

    }

    /**
     The boolean value indicating whether self follows ISO3166 region code's form. (e.g)  CH, 001, US, NE

     Since this checker only checks the form, the string may not be valid region code.

     - SeeAlso:
       - [Language and Locale IDs](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html)
     */
    var isISO3166RegionCodeForm: Bool {

        guard count == 2 || count == 3 else {
            return false
        }

        return allSatisfy({ $0.isASCII && $0.isUppercase }) || (count == 3 && allSatisfy({ $0.isNumber && $0.isASCII }))

    }

    /**
     The boolean value indicating whether self follows ISO15924 script code's form. (e.g)  Arab, Cyrl, Latn

     Since this checker only checks the form, the string may not be valid script code.

     - SeeAlso:
       - [Language and Locale IDs](https://developer.apple.com/library/archive/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html)
       - [Codes for the representation of names of scripts](http://www.unicode.org/iso15924/iso15924-codes.html)
     */
    var isISO15924ScriptCodeForm: Bool {

        guard count == 4 else {
            return false
        }

        return enumerated().allSatisfy({ index, character in
            if index == 0 {
                return character.isASCII && character.isUppercase
            } else {
                return character.isASCII && character.isLowercase
            }
        })
    }

}
