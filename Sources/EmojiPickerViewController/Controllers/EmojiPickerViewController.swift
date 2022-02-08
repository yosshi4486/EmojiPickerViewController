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
    private(set) open var collectionView: UICollectionView!

    /**
     The visual effect view that adds blur effect.
     */
    public let visualEffectView: UIVisualEffectView = .init(effect: UIBlurEffect(style: .systemMaterial))

    /**
     The search bar that the user enters tett for searching emojis.

     This view controller uses `UISearchBar` instead of using with `UISearchController`, because showing the results in anothoer view controller is redundant.
     */
    public let searchBar: UISearchBar = .init(frame: .zero)

    /**
     The layout object that `collectionView` uses.
     */
    private(set) open var flowLayout: UICollectionViewFlowLayout!

    /**
     The container that loads entire information for emoji.
     */
    public let emojiContainer: EmojiContainer = .main

    /**
     The emoji search results. The initial value is empty.
     */
    var searchResults: [EmojiPickerItem] = [] {
        didSet {
            updateSearchResultSection()
        }
    }

    /**
     The diffable data source of the `collectionView`.
     */
    var diffableDataSource: UICollectionViewDiffableDataSource<EmojiPickerSection, EmojiPickerItem>!

    open override func viewDidLoad() {
        super.viewDidLoad()

        loadEmojiSet()
        setupView()
        setupDataSource()
        applyData()

    }

    /**
     Searchs emojis by the given keywork. This method updates triggers `collectionView` update for presenting the search results.

     - Parameters:
       - keyboard: The keyboard for which search emojis.
     */
    func search(from keyboard: String) {

        guard !keyboard.isEmpty else {
            self.searchResults = []
            return
        }

        Task {
            let results = await emojiContainer.searchEmojisForKeyboard(from: keyboard)
            let items = results.map({ EmojiPickerItem(emoji: $0, itemType: .labeled) })
            DispatchQueue.main.async {
                self.searchResults = items
            }
        }

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

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self

        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.placeholder = NSLocalizedString("search_emoji", bundle: .module, comment: "SearchBar placeholder text: hints what the user should enter in.")
        searchBar.returnKeyType = .search
        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.delegate = self
        searchBar.searchBarStyle = .minimal
        searchBar.isUserInteractionEnabled = true

        view.addSubview(visualEffectView)
        visualEffectView.contentView.addSubview(searchBar)
        visualEffectView.contentView.addSubview(collectionView)

        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear

        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            searchBar.leadingAnchor.constraint(equalTo: visualEffectView.layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: visualEffectView.layoutMarginsGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: searchBar.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: searchBar.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: visualEffectView.contentView.bottomAnchor)
        ])
        

    }

    private func setupDataSource() {

        let emojiCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, EmojiPickerItem> { [unowned self] cell, indexPath, item in
            let index = (self.diffableDataSource.snapshot().indexOfItem(item) ?? 0) + 1
            var contentConfiguration = EmojiContentConfiguration(emoji: item.emoji)
            contentConfiguration.accessibilityIndexOfEmoji = index
            cell.contentConfiguration = contentConfiguration
        }

        let headerCellRegistration = UICollectionView.SupplementaryRegistration<EmojiCollectionHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] supplementaryView, elementKind, indexPath in

            let section: EmojiPickerSection
            if #available(iOS 15, *) {
                section = diffableDataSource.sectionIdentifier(for: indexPath.section)!
            } else {
                section = self.diffableDataSource.snapshot().sectionIdentifiers[indexPath.section]
            }

            supplementaryView.headerLabel.text = section.localizedSectionName
        }

        diffableDataSource = UICollectionViewDiffableDataSource<EmojiPickerSection, EmojiPickerItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: emojiCellRegistration, for: indexPath, item: item)
        })

        diffableDataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerCellRegistration, for: indexPath)
        }
        
        collectionView.dataSource = diffableDataSource

    }

    private func applyData() {

        var snapshot: NSDiffableDataSourceSnapshot<EmojiPickerSection, EmojiPickerItem> = .init()

        // TODO: recently used should be considered later.

        snapshot.appendSections([.smileysPeople, .animalsNature, .foodDrink, .travelPlaces, .activities, .objects, .symbols, .flags])
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.smileysPeople]!.map({ EmojiPickerItem(emoji: $0, itemType: .labeled) }), toSection: .smileysPeople)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.animalsNature]!.map({ EmojiPickerItem(emoji: $0, itemType: .labeled) }), toSection: .animalsNature)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.foodDrink]!.map({ EmojiPickerItem(emoji: $0, itemType: .labeled) }), toSection: .foodDrink)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.travelPlaces]!.map({ EmojiPickerItem(emoji: $0, itemType: .labeled) }), toSection: .travelPlaces)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.activities]!.map({ EmojiPickerItem(emoji: $0, itemType: .labeled) }), toSection: .activities)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.objects]!.map({ EmojiPickerItem(emoji: $0, itemType: .labeled) }), toSection: .objects)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.symbols]!.map({ EmojiPickerItem(emoji: $0, itemType: .labeled) }), toSection: .symbols)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.flags]!.map({ EmojiPickerItem(emoji: $0, itemType: .labeled) }), toSection: .flags)

        diffableDataSource.apply(snapshot)
    }

    private func updateSearchResultSection() {

        var snapshot = diffableDataSource.snapshot()

        if searchResults.isEmpty {

            if navigationItem.searchController?.searchBar.text?.isEmpty == true {
                snapshot.deleteSections([.searchResult])
            } else {
                #warning("TODO: Show empty state. No Results")
            }

            diffableDataSource.apply(snapshot)

        } else {
         
            if snapshot.indexOfSection(.searchResult) == nil {
                snapshot.insertSections([.searchResult], beforeSection: .smileysPeople)
                snapshot.appendItems(searchResults, toSection: .searchResult)
                diffableDataSource.apply(snapshot, animatingDifferences: false)

            } else {
                // Using section snapshot makes the datasource repalces the data.
                var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<EmojiPickerItem> = .init()
                sectionSnapshot.append(searchResults, to: nil)
                diffableDataSource.apply(sectionSnapshot, to: .searchResult, animatingDifferences: false)

            }

        }

    }

}

extension EmojiPickerViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let cell = collectionView.cellForItem(at: indexPath)
        let emojiContentConfiguration = cell!.contentConfiguration as! EmojiContentConfiguration
        delegate?.emojiPickerViewController(self, didPick: emojiContentConfiguration.emoji)

    }

}

extension EmojiPickerViewController: UISearchBarDelegate {

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        search(from: searchText)

    }

    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {

    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }

}
