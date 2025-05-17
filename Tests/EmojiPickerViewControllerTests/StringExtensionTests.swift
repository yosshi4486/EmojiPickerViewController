//
//  StringExtensionTests.swift
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
@testable import EmojiPickerViewController

@Suite
struct StringExtensionTests {

    @Suite
    struct IsISO639LanguageCodeFormTests {

        @Test
        func count2AsciiLowercase() {
            #expect("ab".isISO639LanguageCodeForm)
        }

        @Test
        func count2AsciiNotLowercase() {
            #expect("aB".isISO639LanguageCodeForm == false)
        }

        @Test
        func count2NonAsciiLowercase() {
            #expect("éи".isISO639LanguageCodeForm == false)
        }

        @Test
        func count2NonAsciiNotLowercase() {
            #expect("空腹".isISO639LanguageCodeForm == false)
        }

        @Test
        func count4AsciiLowercase() {
            #expect("abzz".isISO639LanguageCodeForm == false)
        }

        @Test
        func count4AsciiNotLowercase() {
            #expect("abZz".isISO639LanguageCodeForm == false)
        }

        @Test
        func count4NonAsciiLowercase() {
            #expect("éиπé".isISO639LanguageCodeForm == false)
        }

        @Test
        func count4NonAsciiNotLowercase() {
            #expect("空腹限界".isISO639LanguageCodeForm == false)
        }

        @Test
        func count3AsciiLowercase() {
            #expect("abc".isISO639LanguageCodeForm)
        }
    }

    @Suite
    struct IsISO3166RegionCodeFormTests {

        @Test
        func count1AsciiUpper() {
            #expect("Z".isISO3166RegionCodeForm == false)
        }

        @Test
        func count3AsciiUpper() {
            #expect("ABB".isISO3166RegionCodeForm)
        }

        @Test
        func count3AsciiNotUpper() {
            #expect("AbB".isISO3166RegionCodeForm == false)
        }

        @Test
        func count3NonAsciiUpper() {
            #expect("ÉИΠ".isISO3166RegionCodeForm == false)
        }

        @Test
        func count3NonAsciiNotUpper() {
            #expect("éиπ".isISO3166RegionCodeForm == false)
        }

        @Test
        func count3AsciiNumber() {
            #expect("001".isISO3166RegionCodeForm)
        }

        @Test
        func count3NonAsciiNumber() {
            #expect("㊈㊈㊈".isISO3166RegionCodeForm == false)
        }
    }

    @Suite
    struct IsISO15924ScriptCodeFormTests {

        @Test
        func count3Ull() {
            #expect("Arb".isISO15924ScriptCodeForm == false)
        }

        @Test
        func count4Ulll() {
            #expect("Arbb".isISO15924ScriptCodeForm)
        }

        @Test
        func count4Llll() {
            #expect("arbb".isISO15924ScriptCodeForm == false)
        }
    }

}
