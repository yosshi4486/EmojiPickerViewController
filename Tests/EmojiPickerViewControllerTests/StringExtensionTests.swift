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

@Suite("StringExtensionTests")
struct StringExtensionTests {



@Test
    func testIsISO639LanguageCodeForm() throws {

        // whitebox testing: MCC

            #expect("ab".isISO639LanguageCodeForm)

            #expect(!"aB".isISO639LanguageCodeForm)

            #expect(!"éи".isISO639LanguageCodeForm)

            #expect(!"空腹".isISO639LanguageCodeForm)

            #expect(!"abzz".isISO639LanguageCodeForm)

            #expect(!"abZz".isISO639LanguageCodeForm)

            #expect(!"éиπé".isISO639LanguageCodeForm)

            #expect(!"空腹限界".isISO639LanguageCodeForm)

        // additional

            #expect("abc".isISO639LanguageCodeForm)
    }


@Test
    func testIsISO3166RegionCodeForm() throws {

        // I'm writing very rough tests.

            #expect(!"Z".isISO3166RegionCodeForm)

            #expect("ABB".isISO3166RegionCodeForm)

            #expect(!"AbB".isISO3166RegionCodeForm)

            #expect(!"ÉИΠ".isISO3166RegionCodeForm)

            #expect(!"éиπ".isISO3166RegionCodeForm)

            #expect("001".isISO3166RegionCodeForm)

            #expect(!"㊈㊈㊈".isISO3166RegionCodeForm)
    }
@Test
    func testIsISO15924ScriptCodeForm() throws {
        // I'm writing very rough tests.
            #expect(!"Arb".isISO15924ScriptCodeForm)
            #expect("Arbb".isISO15924ScriptCodeForm)
            #expect(!"arbb".isISO15924ScriptCodeForm)
    }
    }
