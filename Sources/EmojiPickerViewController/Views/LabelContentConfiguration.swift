//
//  LabelContentConfiguration.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by yosshi4486 on 2022/02/05.
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

#if !os(macOS)
import UIKit

/**
 A content configuration for showing text in `UILabel`.
 */
struct LabelContentConfiguration: UIContentConfiguration {

    var text: String = ""

    var font: UIFont = UIFont.preferredFont(forTextStyle: .body)

    var textColor: UIColor = .label

    var textAlighment: NSTextAlignment = .natural

    func makeContentView() -> UIView & UIContentView {
        return LabelContentView(self)
    }

    func updated(for state: UIConfigurationState) -> LabelContentConfiguration {
        return self
    }

}

/**
 A content view for which shows an emoji.
 */
class LabelContentView: UIView, UIContentView {

    let label: UILabel = UILabel()

    var configuration: UIContentConfiguration {
        didSet {
            configure()
        }
    }

    private var labelContentConfiguration: LabelContentConfiguration! {
        return configuration as? LabelContentConfiguration
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)

        commonInit()
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {

        guard let configuration = configuration as? LabelContentConfiguration else {
            label.text = ""
            return
        }

        label.text = configuration.text
        label.font = configuration.font
        label.textColor = configuration.textColor
        label.textAlignment = configuration.textAlighment

    }

    private func commonInit() {

        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        label.adjustsFontSizeToFitWidth = true

    }

}
#endif
