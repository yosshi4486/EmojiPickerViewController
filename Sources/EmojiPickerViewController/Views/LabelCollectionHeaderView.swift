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

}

/*
 We don't have to implement the redundant subclass if `UICollectionReusableView` were configuable view which has `contentConfiguration` property 😞
 */

class LabelCollectionHeaderView: UICollectionReusableView {

    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
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

    /*
     We have several tricks to supress autolayout warnings. The warnings appears when deleting the search or recently section because zero height is given to this header temporary and the given height makes conflicts with vertical constraints of layoutMarginGuide.
     */

    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {

        let size = super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        let topAndBottomSpacing: CGFloat = 16

        return CGSize(width: size.width, height: size.height + topAndBottomSpacing)

    }

    private func commonInit() {

        addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor),
            headerLabel.leadingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.leadingAnchor),
            headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            headerLabel.trailingAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.trailingAnchor)
        ])
        
    }

    private func configureAppearance() {

        headerLabel.font = appearance.font
        headerLabel.textColor = appearance.textColor
        headerLabel.textAlignment = appearance.textAlignment
        backgroundColor = appearance.backgroundColor

    }

}
