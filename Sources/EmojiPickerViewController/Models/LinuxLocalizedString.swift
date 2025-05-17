//
//  LinuxLocalizedString.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by 山田良治 on 2025/05/17.
//
// ----------------------------------------------------------------------------
//
//  © 2025  yosshi4486
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

#if os(Linux)
import Foundation

extension String {
    /// Fallback initializer for Linux where Foundation does not provide String(localized:bundle:comment:)
    init(localized key: String, bundle: Bundle, comment: StaticString) {
        self = bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
#endif
