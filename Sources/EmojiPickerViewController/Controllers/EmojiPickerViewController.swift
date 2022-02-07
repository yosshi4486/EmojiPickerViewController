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

    public enum Section: Int, CaseIterable {

        case recentlyUsed

        case searchResult

        case smileysPeople

        case animalsNature

        case foodDrink

        case travelPlaces

        case activities

        case objects

        case symbols

        case flags

        init(emojiLabel: EmojiLabel) {
            switch emojiLabel {
            case .smileysPeople:
                self = .smileysPeople

            case .animalsNature:
                self = .animalsNature

            case .foodDrink:
                self = .foodDrink

            case .travelPlaces:
                self = .travelPlaces

            case .activities:
                self = .activities

            case .objects:
                self = .objects

            case .symbols:
                self = .symbols

            case .flags:
                self = .flags
            }
        }

    }

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
    open var dataSource: UICollectionViewDiffableDataSource<Section, Emoji>!

    /**
     The layout object that `collectionView` uses.
     */
    open var flowLayout: UICollectionViewFlowLayout!

    /**
     The container that loads emoji set and annotations.
     */
    public let emojiContainer: EmojiContainer = .main

    /**
     The emoji search results. The initial value is empty.
     */
    open var searchResults: [Emoji] = [] {
        didSet {
            updateSearchResultSection()
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        loadEmojiSet()
        setupView()
        setupDataSource()
        setupSearchController()
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
            DispatchQueue.main.async {
                self.searchResults = results
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: visualEffectView.contentView.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: visualEffectView.contentView.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: visualEffectView.contentView.bottomAnchor)
        ])
        

    }

    private func setupSearchController() {

        /*
         You can get a search interface for free if you present this view controller with `UINavigationController`.
         */


        let searchController = UISearchController(searchResultsController: self)
        searchController.automaticallyShowsSearchResultsController = false
        searchController.automaticallyShowsCancelButton = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none
        searchController.searchBar.searchTextField.placeholder = NSLocalizedString("searchEmoji", bundle: .module, comment: "SearchBar placeholder text: hints what the user should enter in.")
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.searchTextField.clearButtonMode = .whileEditing
        searchController.delegate = self
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

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

        dataSource = UICollectionViewDiffableDataSource<Section, Emoji>(collectionView: collectionView, cellProvider: { collectionView, indexPath, emoji in
            return collectionView.dequeueConfiguredReusableCell(using: emojiCellRegistration, for: indexPath, item: emoji)
        })

        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            return collectionView.dequeueConfiguredReusableSupplementary(using: headerCellRegistration, for: indexPath)
        }
        
        collectionView.dataSource = dataSource

    }

    private func applyData() {

        var snapshot: NSDiffableDataSourceSnapshot<Section, Emoji> = .init()

        // TODO: recently used should be considered later.

        snapshot.appendSections([.smileysPeople, .animalsNature, .foodDrink, .travelPlaces, .activities, .objects, .symbols, .flags])
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.smileysPeople]!, toSection: .smileysPeople)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.animalsNature]!, toSection: .animalsNature)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.foodDrink]!, toSection: .foodDrink)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.travelPlaces]!, toSection: .travelPlaces)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.activities]!, toSection: .activities)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.objects]!, toSection: .objects)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.symbols]!, toSection: .symbols)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.flags]!, toSection: .flags)

        dataSource.apply(snapshot)
    }

    private func updateSearchResultSection() {

        var snapshot = dataSource.snapshot()
        if searchResults.isEmpty {

            if navigationItem.searchController?.searchBar.text?.isEmpty == true {
                snapshot.deleteSections([.searchResult])
            } else {
                #warning("TODO: Show empty state. No Results")
            }

        } else {
            snapshot.appendItems(searchResults, toSection: .searchResult)
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

extension EmojiPickerViewController: UISearchResultsUpdating {

    public func updateSearchResults(for searchController: UISearchController) {
        search(from: searchController.searchBar.text!)
    }


}

extension EmojiPickerViewController: UISearchBarDelegate {

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }

    public func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {

    }

    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

    }

}

extension EmojiPickerViewController: UISearchControllerDelegate {

    public func willPresentSearchController(_ searchController: UISearchController) {

    }

    public func willDismissSearchController(_ searchController: UISearchController) {

    }

}
