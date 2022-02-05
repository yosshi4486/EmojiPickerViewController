//
//  File.swift
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
 An abstract loader type that loads data.
 */
protocol Loader {

    /**
     The bundle where the resouces are located.
     */
    var bundle: Bundle { get }

    /**
     Loads data.
     */
    func load() throws

}

extension Loader {

    /**
     The bundle where the resouces are located. In swift package system, `.module` specifies the resource's bundle of the current module.
     */
    var bundle: Bundle { .module }

}
