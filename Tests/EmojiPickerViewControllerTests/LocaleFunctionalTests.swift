//
//  LocaleFunctionalTests.swift
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

import Testing
import Foundation

@Suite
struct LocaleFunctionalTests {

    /*
     Locale object can understand and store the given identifier regardless the format is hyphen or underscore.
     */

    @Test
    func identifierHyphen() {
        let locale = Locale(identifier: "de-CH")
        #expect(locale.identifier == "de-CH")
    }

    @Test
    func identifierUnderScore() {
        let locale = Locale(identifier: "de_CH")
        #expect(locale.identifier == "de_CH")
    }

    @Test
    func localeRoundIdentifier() {
        let langageCode = "sr"
        let scriptCode = "Cyrl"
        let regionCode = "BA"

        let identifier = "\(langageCode)-\(scriptCode)_\(regionCode)"
        let foundationLocale = Locale(identifier: identifier)
        #expect(foundationLocale.identifier != identifier)
        #expect(foundationLocale.identifier == "sr_BA")
        #expect(foundationLocale.language.languageCode?.identifier == "sr")
        #expect(foundationLocale.language.script?.identifier == "Cyrl")
        #expect(foundationLocale.region!.identifier == "BA")
    }

}
