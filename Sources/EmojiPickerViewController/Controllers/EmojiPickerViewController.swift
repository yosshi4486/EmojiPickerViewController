//
//  EmojiPickerViewController.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
//
//  Created by yosshi4486 on 2022/01/31.
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
import Collections

/**
 A *View Controller* for picking an emoji.
 */
open class EmojiPickerViewController: UIViewController {

    /**
     The picker’s delegate object.
     */
    open weak var delegate: EmojiPickerViewControllerDelegate?

    /**
     The collection view for which shows emojis.
     */
    open var collectionView: UICollectionView!

    /**
     The visual effect view that adds blur effect. You can customize the effect by accessing the properties.
     */
    public let visualEffectView: UIVisualEffectView = .init(effect: UIBlurEffect(style: .systemMaterial))

    /**
     The data source of the `collectionView`.
     */
    open var dataSource: UICollectionViewDiffableDataSource<EmojiLabel, Emoji>!

    /**
     The layout object that `collectionView` uses.
     */
    open var flowLayout: UICollectionViewFlowLayout!

    /**
     The container that loads emoji set and annotations.
     */
    public let emojiContainer: EmojiContainer = .main

    open override func viewDidLoad() {
        super.viewDidLoad()

        loadEmojiSet()
        setupView()
        setupDataSource()
        applyData()

    }

    private func loadEmojiSet() {

        if !emojiContainer.isLoaded {

            do {
                try emojiContainer.load()
            } catch {
                delegate?.emojiPickerViewController(self, didReceiveError: error)
            }

        }

    }

    private func setupView() {

        // The layout is very simple so that we don't have to use compositional layout.

        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.itemSize = .init(width: 50, height: 50)
        flowLayout.headerReferenceSize = .init(width: view.bounds.width, height: 50)
        flowLayout.sectionHeadersPinToVisibleBounds = true

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self

        view.addSubview(visualEffectView)
        visualEffectView.contentView.addSubview(collectionView)

        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: visualEffectView.contentView.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: visualEffectView.contentView.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: visualEffectView.contentView.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: visualEffectView.contentView.bottomAnchor)
        ])
        

    }

    private func setupDataSource() {

        let emojiCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Emoji> { [unowned self] cell, indexPath, emoji in
            let index = (self.dataSource.snapshot().indexOfItem(emoji) ?? 0) + 1
            var contentConfiguration = EmojiContentConfiguration(emoji: emoji)
            contentConfiguration.accessibilityIndexOfEmoji = index
            cell.contentConfiguration = contentConfiguration
        }

        let headerCellRegistration = UICollectionView.SupplementaryRegistration<EmojiCollectionHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] supplementaryView, elementKind, indexPath in
            let label = self.emojiContainer.labeledEmojisForKeyboard.keys[indexPath.section]
            supplementaryView.headerLabel.text = label.localizedDescription!
        }

        dataSource = UICollectionViewDiffableDataSource<EmojiLabel, Emoji>(collectionView: collectionView, cellProvider: { collectionView, indexPath, emoji in
            return collectionView.dequeueConfiguredReusableCell(using: emojiCellRegistration, for: indexPath, item: emoji)
        })

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerCellRegistration, for: indexPath)
        }
        
        collectionView.dataSource = dataSource

    }

    private func applyData() {

        var snapshot: NSDiffableDataSourceSnapshot<EmojiLabel, Emoji> = .init()

        // TODO: recently used should be considered later.

        snapshot.appendSections(EmojiLabel.allCases)
        for label in EmojiLabel.allCases {
            snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[label]!, toSection: label)
        }

        dataSource.apply(snapshot)
    }

}

extension EmojiPickerViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath)
        let emojiContentConfiguration = cell!.contentConfiguration as! EmojiContentConfiguration
        delegate?.emojiPickerViewController(self, didPick: emojiContentConfiguration.emoji)

    }

}
