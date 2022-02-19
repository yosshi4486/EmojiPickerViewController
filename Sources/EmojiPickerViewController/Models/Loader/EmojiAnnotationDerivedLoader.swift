//
//  EmojiAnnotationDerivedLoader.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by yosshi4486 on 2022/02/02.
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
 A subtype that loads emoji's annotation **derived** and derived tts to already loaded emojis.

 The resources which this object loads are located at `Resources/CLDR/annotationsDerived`. The original resource is https://github.com/unicode-org/cldr/tree/main/common/annoatationsDerived

 This loader loads annotations and tts following the LSDM specification.

 - Note:
 I suppose that **Derived** means emoji sequences like emoji modifier sequence or emoji flag sequence.

 - SeeAlso:
  - [LSDM](https://unicode.org/reports/tr35/)

 */
class EmojiAnnotationDerivedLoader: EmojiAnnotationLoader {

    override var resourceURLs: [URL] {
        return emojiLocale.annotationDerivedFileURLs
    }
    
}
