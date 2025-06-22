//
//  EmojiLocaleTests.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
//
//  Created by yosshi4486 on 2022/02/06.
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

import Testing
import Foundation
@testable import EmojiPickerViewController

@Suite
struct EmojiLocaleTests {

    @Suite
    struct InitTests {
        
        static let notexistValidFormLanguageCode = "zz"
        static let notexistValidFormScriptCode = "Abcd"
        static let notexistValidFormRegionCode = "ABC"

        @Suite @MainActor
        struct LanguageScriptRegionTests {

            @Test
            func existExistExist() {
                let locale = EmojiLocale(localeIdentifier: "sr-Cyrl_BA")
                #expect(locale != nil)
                #expect(locale?.localeIdentifier == "sr-Cyrl_BA")
                #expect(locale?.annotationFileURLs.map(\.lastPathComponent) == ["sr_Cyrl.xml", "sr_Cyrl_BA.xml"])
                #expect(locale?.annotationDerivedFileURLs.map(\.lastPathComponent) == ["sr_Cyrl_derived.xml", "sr_Cyrl_BA_derived.xml"])
            }

            @Test
            func existExistNotExist() {
                let locale = EmojiLocale(localeIdentifier: "sr-Cyrl_\(notexistValidFormRegionCode)")
                #expect(locale != nil)
                #expect(locale?.localeIdentifier == "sr-Cyrl_\(notexistValidFormRegionCode)")
                #expect(locale?.annotationFileURLs.map(\.lastPathComponent) == ["sr_Cyrl.xml"])
                #expect(locale?.annotationDerivedFileURLs.map(\.lastPathComponent) == ["sr_Cyrl_derived.xml"])
            }

            @Test
            func existNotExistExist() {
                let locale = EmojiLocale(localeIdentifier: "sr-\(notexistValidFormScriptCode)_BA")
                #expect(locale == nil)
            }

            @Test
            func existNotExistNotExist() {
                let locale = EmojiLocale(localeIdentifier: "sr-\(notexistValidFormScriptCode)_\(notexistValidFormRegionCode)")
                #expect(locale == nil)
            }

            @Test
            func notExistExistExist() {
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-Cyrl_BA")
                #expect(locale == nil)
            }

            @Test
            func notExistExistNotExist() {
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-Cyrl_\(notexistValidFormRegionCode)")
                #expect(locale == nil)
            }

            @Test
            func notExistNotExistExist() {
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-\(notexistValidFormScriptCode)_BA")
                #expect(locale == nil)
            }

            @Test
            func notExistNotExistNotExist() {
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-\(notexistValidFormScriptCode)_\(notexistValidFormRegionCode)")
                #expect(locale == nil)
            }
        }
        
        @Suite @MainActor
        struct LanguageScriptTests {

            @Test
            func existExist() {
                let locale = EmojiLocale(localeIdentifier: "zh-Hant")
                #expect(locale != nil)
                #expect(locale?.localeIdentifier == "zh-Hant")
                #expect(locale?.annotationFileURLs.map(\.lastPathComponent) == ["zh_Hant.xml"])
                #expect(locale?.annotationDerivedFileURLs.map(\.lastPathComponent) == ["zh_Hant_derived.xml"])
            }

            @Test
            func existNotExist() {
                let locale = EmojiLocale(localeIdentifier: "zh-\(notexistValidFormScriptCode)")
                #expect(locale == nil)
            }

            @Test
            func notExistExist() {
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-Hant")
                #expect(locale == nil)
            }

            @Test
            func notExistNotExist() {
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-\(notexistValidFormScriptCode)")
                #expect(locale == nil)
            }
        }

        @Suite @MainActor
        struct LanguageRegionTests {

            @Test
            func existExist() {
                let locale = EmojiLocale(localeIdentifier: "en_IN")
                #expect(locale != nil)
                #expect(locale?.localeIdentifier == "en_IN")
                #expect(locale?.annotationFileURLs.map(\.lastPathComponent) == ["en.xml", "en_IN.xml"])
                #expect(locale?.annotationDerivedFileURLs.map(\.lastPathComponent) == ["en_derived.xml", "en_IN_derived.xml"])
            }

            @Test
            func existNotExist() {
                let locale = EmojiLocale(localeIdentifier: "en_\(notexistValidFormRegionCode)")
                #expect(locale != nil)
                #expect(locale?.localeIdentifier == "en_\(notexistValidFormRegionCode)")
                #expect(locale?.annotationFileURLs.map(\.lastPathComponent) == ["en.xml"])
                #expect(locale?.annotationDerivedFileURLs.map(\.lastPathComponent) == ["en_derived.xml"])
            }

            @Test
            func notExistExist() {
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)_IN")
                #expect(locale == nil)
            }

            @Test
            func notExistNotExist() {
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)_\(notexistValidFormRegionCode)")
                #expect(locale == nil)
            }
        }

        @Suite @MainActor
        struct LanguageTests {

            @Test
            func exist() {
                let locale = EmojiLocale(localeIdentifier: "bg")
                #expect(locale != nil)
                #expect(locale?.localeIdentifier == "bg")
                #expect(locale?.annotationFileURLs.map(\.lastPathComponent) == ["bg.xml"])
                #expect(locale?.annotationDerivedFileURLs.map(\.lastPathComponent) == ["bg_derived.xml"])
            }

            @Test
            func notExist() {
                let locale = EmojiLocale(localeIdentifier: notexistValidFormLanguageCode)
                #expect(locale == nil)
            }
        }
        
    }
    
    @Test
    func availableIdentifier() {
        for identifier in EmojiLocale.availableIdentifiers {
            #expect(Bundle.module.url(forResource: identifier, withExtension: "xml") != nil)
            #expect(Bundle.module.url(forResource: "\(identifier)_derived", withExtension: "xml") != nil)
        }
    }

}
