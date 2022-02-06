//
//  EmojiCellContentConfiguration.swift
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

import UIKit

/**
 A content configuration for showing emoji.
 */
struct EmojiContentConfiguration: UIContentConfiguration {

    /**
     The emoji which shows as image.
     */
    var emoji: Emoji

    /**
     The emoji index for accessibility.
     */
    var accessibilityIndexOfEmoji: Int = 1

    func makeContentView() -> UIView & UIContentView {
        return EmojiContentView(self)
    }

    func updated(for state: UIConfigurationState) -> EmojiContentConfiguration {
        return self
    }

}

/**
 A content view for which shows an emoji.
 */
class EmojiContentView: UIView, UIContentView {

    let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    var configuration: UIContentConfiguration {
        didSet {
            configure(from: configuration)
        }
    }

    private var emojiConfiguration: EmojiContentConfiguration? {
        return configuration as? EmojiContentConfiguration
    }

    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)

        commonInit()
        configure(from: configuration)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(from configuration: UIContentConfiguration) {

        guard let configuration = configuration as? EmojiContentConfiguration else {
            emojiLabel.text = ""
            return
        }

        emojiLabel.text = String(configuration.emoji.character)

    }

    private func commonInit() {

        addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            emojiLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            emojiLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            emojiLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])

    }

    // - MARK: - Accessibilities

    override var isAccessibilityElement: Bool {

        get {
            return true
        }

        set {
            super.isAccessibilityElement = newValue
        }

    }

    override var accessibilityElements: [Any]? {

        get {
            return []
        }

        set {
            super.accessibilityElements = newValue
        }

    }

    override var accessibilityTraits: UIAccessibilityTraits {

        get {
            return .button
        }

        set {
            super.accessibilityTraits = newValue
        }

    }

    override var accessibilityLabel: String? {

        /*
         Although UILabel speak an annotation of the emoji, speaking testToSpeach is more appropriate than the system behavior.
         */
        get {

            guard let emojiConfiguration = emojiConfiguration else {
                return nil
            }

            return "\(emojiConfiguration.emoji.textToSpeach), \(emojiConfiguration.accessibilityIndexOfEmoji)"

        }

        set {
            super.accessibilityLabel = newValue
        }

    }

}

