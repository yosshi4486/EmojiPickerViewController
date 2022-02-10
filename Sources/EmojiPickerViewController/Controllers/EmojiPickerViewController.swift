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
     The boolean value indicating whether the collectionview animates changes. The default value is `false`.
     */
    open var animatingChanges: Bool = false

    /**
     The appearance of the collection header.
     */
    open var headerAppearance: HeaderAppearance = HeaderAppearance()

    /**
     The picker’s delegate object.
     */
    open weak var delegate: EmojiPickerViewControllerDelegate?

    /**
     The collection view for which shows emojis.
     */
    public let collectionView: UICollectionView

    /**
     The layout object that `collectionView` uses.
     */
    public var flowLayout: UICollectionViewFlowLayout = .init()

    /**
     The visual effect view that adds blur effect.
     */
    public let visualEffectView: UIVisualEffectView = .init(effect: UIBlurEffect(style: .systemMaterial))

    /**
     The search bar that the user enters tett for searching emojis.

     This view controller uses `UISearchBar` instead of using with `UISearchController`, because showing the results in anothoer view controller is redundant.
     */
    public let searchBar: UISearchBar

    /**
     The segmented control for which jumps curren section to the selected section.
     */
    public let segmentedControl: UISegmentedControl

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

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {

        /*
         Initialize with default settings.
         */
        self.flowLayout = UICollectionViewFlowLayout()
        self.flowLayout.minimumLineSpacing = 5
        self.flowLayout.minimumInteritemSpacing = 5
        self.flowLayout.itemSize = .init(width: 50, height: 50)

        self.searchBar = UISearchBar(frame: .zero)
        self.searchBar.autocapitalizationType = .none
        self.searchBar.searchTextField.placeholder = NSLocalizedString("search_emoji", bundle: .module, comment: "SearchBar placeholder text: hints what the user should enter in.")
        self.searchBar.returnKeyType = .search
        self.searchBar.searchTextField.clearButtonMode = .whileEditing
        self.searchBar.searchBarStyle = .minimal

        /*
         Using SFSymbols might not be the best idea.
         */

        let images: [UIImage] = [
//            UIImage(systemName: "clock")!,
            UIImage(systemName: "face.smiling")!,
            UIImage(systemName: "leaf")!,
            UIImage(systemName: "fork.knife")!,
            UIImage(systemName: "airplane")!,
            UIImage(systemName: "paintpalette")!,
            UIImage(systemName: "lightbulb")!,
            UIImage(systemName: "number")!,
            UIImage(systemName: "flag")!
        ]

        self.segmentedControl = UISegmentedControl(items: images)
        self.segmentedControl.tintColor = .label
        self.segmentedControl.selectedSegmentIndex = 0
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        self.collectionView.backgroundColor = .clear

        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        self.searchBar.delegate = self
        self.segmentedControl.addTarget(self, action: #selector(scrollToSelectedSection(sender:)), for: .valueChanged)
        self.collectionView.delegate = self

    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        loadEmojiSet()
        setupView()
        setupDataSource()
        applyData()

    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        collectionView.flashScrollIndicators()

    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 15.0, *) {
            var snapshot = diffableDataSource.snapshot()
            snapshot.reconfigureItems(snapshot.itemIdentifiers)
            diffableDataSource.apply(snapshot, animatingDifferences: false)
        } else {
            // How to reload the collection view without using this newest API?
        }

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
            let items = results.map({ EmojiPickerItem.labeled($0) })
            DispatchQueue.main.async {
                self.searchResults = items
            }
        }

    }

    @objc func scrollToSelectedSection(sender: Any?) {

        collectionView.scrollToSection(segmentedControl.selectedSegmentIndex, position: .top, animated: false)
        collectionView.flashScrollIndicators()

    }

    private func loadEmojiSet() {

        if !emojiContainer.isLoaded {
            emojiContainer.load()
        }

    }

    private func setupView() {

        view.addSubview(visualEffectView)
        visualEffectView.contentView.addSubview(searchBar)
        visualEffectView.contentView.addSubview(collectionView)
        visualEffectView.contentView.addSubview(segmentedControl)

        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

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
            segmentedControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: collectionView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: collectionView.trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: visualEffectView.safeAreaLayoutGuide.bottomAnchor)
        ])
        

    }

    private func setupDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, EmojiPickerItem> { [unowned self] cell, indexPath, item in

            if let emoji = item.emoji {

                let index = (self.diffableDataSource.snapshot().indexOfItem(item) ?? 0) + 1
                var contentConfiguration = LabelContentConfiguration()
                contentConfiguration.text = String(emoji.character)
                contentConfiguration.font = UIFont.preferredFont(forTextStyle: .headline)
                contentConfiguration.textAlighment = .center

                cell.contentConfiguration = contentConfiguration

                cell.isAccessibilityElement = true
                cell.accessibilityElements = []
                cell.accessibilityTraits = .button
                cell.accessibilityLabel = "\(emoji.textToSpeach), \(index)"

            } else {

                var contentConfiguration = LabelContentConfiguration()
                contentConfiguration.text = NSLocalizedString("no_results", bundle: .module, comment: "Empty state text: feedbacks no-results to the user.")
                contentConfiguration.font = UIFont.preferredFont(forTextStyle: .title2)
                contentConfiguration.textColor = .secondaryLabel
                contentConfiguration.textAlighment = .center

                cell.contentConfiguration = contentConfiguration

                cell.isAccessibilityElement = true
                cell.accessibilityElements = []
                cell.accessibilityTraits = .none
                cell.accessibilityLabel = contentConfiguration.text

            }

        }

        let headerCellRegistration = UICollectionView.SupplementaryRegistration<LabelCollectionHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { [unowned self] supplementaryView, elementKind, indexPath in

            let section = self.section(for: indexPath)!
            supplementaryView.headerLabel.text = section.localizedSectionName
            supplementaryView.appearance = self.headerAppearance

            supplementaryView.isAccessibilityElement = true
            supplementaryView.accessibilityTraits = .header
            supplementaryView.accessibilityElements = []
            supplementaryView.accessibilityLabel = section.localizedSectionName
        }

        diffableDataSource = UICollectionViewDiffableDataSource<EmojiPickerSection, EmojiPickerItem>(collectionView: collectionView, cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
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
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.smileysPeople]!.map({ EmojiPickerItem.labeled($0) }), toSection: .smileysPeople)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.animalsNature]!.map({ EmojiPickerItem.labeled($0) }), toSection: .animalsNature)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.foodDrink]!.map({ EmojiPickerItem.labeled($0) }), toSection: .foodDrink)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.travelPlaces]!.map({ EmojiPickerItem.labeled($0) }), toSection: .travelPlaces)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.activities]!.map({ EmojiPickerItem.labeled($0) }), toSection: .activities)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.objects]!.map({ EmojiPickerItem.labeled($0) }), toSection: .objects)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.symbols]!.map({ EmojiPickerItem.labeled($0) }), toSection: .symbols)
        snapshot.appendItems(emojiContainer.labeledEmojisForKeyboard[.flags]!.map({ EmojiPickerItem.labeled($0) }), toSection: .flags)

        // `animatingDifferences` is false at first time.
        diffableDataSource.apply(snapshot, animatingDifferences: false)
    }

    private func updateSearchResultSection() {

        var snapshot = diffableDataSource.snapshot()

        if searchResults.isEmpty {

            if searchBar.text?.isEmpty == true {

                snapshot.deleteSections([.searchResult])
                diffableDataSource.apply(snapshot, animatingDifferences: animatingChanges)

            } else {

                if snapshot.indexOfSection(.searchResult) == nil {

                    snapshot.insertSections([.searchResult], beforeSection: .smileysPeople)
                    snapshot.appendItems([.empty], toSection: .searchResult)
                    diffableDataSource.apply(snapshot, animatingDifferences: animatingChanges)

                } else {

                    // Using section snapshot to repalce the section data.
                    var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<EmojiPickerItem> = .init()
                    sectionSnapshot.append([.empty], to: nil)
                    diffableDataSource.apply(sectionSnapshot, to: .searchResult, animatingDifferences: animatingChanges)

                }

            }

        } else {
         
            if snapshot.indexOfSection(.searchResult) == nil {

                snapshot.insertSections([.searchResult], beforeSection: .smileysPeople)
                snapshot.appendItems(searchResults, toSection: .searchResult)
                diffableDataSource.apply(snapshot, animatingDifferences: animatingChanges)

            } else {

                // Using section snapshot to repalce the section data.
                var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<EmojiPickerItem> = .init()
                sectionSnapshot.append(searchResults, to: nil)
                diffableDataSource.apply(sectionSnapshot, to: .searchResult, animatingDifferences: animatingChanges)

            }

        }

    }

    private func section(for indexPath: IndexPath) -> EmojiPickerSection? {

        let section: EmojiPickerSection?
        if #available(iOS 15, *) {
            section = diffableDataSource.sectionIdentifier(for: indexPath.section)
        } else {
            section = diffableDataSource.snapshot().sectionIdentifiers[indexPath.section]
        }

        return section

    }

}

extension EmojiPickerViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = diffableDataSource.itemIdentifier(for: indexPath), let emoji = item.emoji else {
            return
        }

        delegate?.emojiPickerViewController(self, didPick: emoji)

    }

}

extension EmojiPickerViewController: UICollectionViewDelegateFlowLayout {

    /*
     This implementation is to adopt size category changes.
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        guard let header = diffableDataSource.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: IndexPath(row: 0, section: section)) as? LabelCollectionHeaderView else {
            return CGSize(width: collectionView.bounds.width, height: 50) // Default size
        }

        let sizeForAdoptingTraitChanges = header.systemLayoutSizeFitting(.init(width: collectionView.bounds.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)

        return sizeForAdoptingTraitChanges
    }

    /*
     This implementation is to provide empty state experience.
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let item = diffableDataSource.itemIdentifier(for: indexPath), item == .empty else {
            return flowLayout.itemSize
        }

        // The size for empty state cell.
        return CGSize(width: collectionView.bounds.width, height: flowLayout.itemSize.height)

    }

}

extension EmojiPickerViewController: UISearchBarDelegate {

    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        search(from: searchText)
        segmentedControl.selectedSegmentIndex = 0
        scrollToSelectedSection(sender: nil)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchResults = []
    }

}

extension UICollectionView {

    func scrollToSection(_ section: Int, position: UICollectionView.ScrollPosition, animated: Bool) {

        guard let attributes = collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section)) else {
            return
        }

        setContentOffset(CGPoint(x: 0, y: attributes.frame.origin.y - contentInset.top), animated: animated)

    }

}
