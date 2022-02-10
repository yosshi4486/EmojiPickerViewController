//
//  LabelCollectionHeaderView.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by yosshi4486 on 2022/02/07.
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

public struct HeaderAppearance {

    public var font: UIFont = UIFont.preferredFont(forTextStyle: .headline)

    public var textColor: UIColor = .label

    public var textAlignment: NSTextAlignment = .natural

    public var backgroundColor: UIColor = .systemBackground

    public var labelPadding: UIEdgeInsets = .init(top: 8, left: 8, bottom: 8, right: 8)

}

class LabelCollectionHeaderView: UICollectionReusableView {

    let headerLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 1
        label.textColor = .label
        return label
    }()

    var appearance: HeaderAppearance! {
        didSet {
            configureAppearance()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        commonInit()
    }

    private func commonInit() {

        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

    }

    private func configureAppearance() {

        headerLabel.font = appearance.font
        headerLabel.textColor = appearance.textColor
        headerLabel.textAlignment = appearance.textAlignment
        headerLabel.padding = appearance.labelPadding
        backgroundColor = appearance.backgroundColor

    }

}

class PaddingLabel: UILabel {

    var padding: UIEdgeInsets = .zero

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {

        var anIntrinsicContentSize = super.intrinsicContentSize
        anIntrinsicContentSize.height += padding.top + padding.bottom
        anIntrinsicContentSize.width += padding.left + padding.right
        return anIntrinsicContentSize

    }

}
