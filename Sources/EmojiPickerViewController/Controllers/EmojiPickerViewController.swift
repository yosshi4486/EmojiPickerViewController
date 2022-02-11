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

 # Sizing Emojis
 The emoji is sized as same as the cell size, so you can change the emoji size and the number of emojis in each row by changing `flowLayout.itemSize`.
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

    /**
     The collection view for which shows emojis.
     */
    var collectionView: UICollectionView!

    /**
     The layout object that `collectionView` uses.
     */
    var flowLayout: UICollectionViewFlowLayout = .init()

    /**
     The search bar that the user enters tett for searching emojis.

     This view controller uses `UISearchBar` instead of using with `UISearchController`, because showing the results in anothoer view controller is redundant.
     */
    var searchBar: UISearchBar!

    /**
     The visual effect view that adds blur effect for segmented control.
     */
    let segmentedControlContainerVisualEffectView: UIVisualEffectView = .init(effect: UIBlurEffect(style: .systemMaterial))

    /**
     The segmented control for which jumps curren section to the selected section.
     */
    var segmentedControl: UISegmentedControl!

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

        var snapshot = diffableDataSource.snapshot()
        snapshot.reconfigureItems(snapshot.itemIdentifiers)
        diffableDataSource.apply(snapshot, animatingDifferences: false)

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
            let items = results.map({ EmojiPickerItem.searchResult($0) })
            DispatchQueue.main.async {
                self.searchResults = items
            }
        }

    }

    @objc func scrollToSelectedSection(sender: Any?) {

        collectionView.scrollToSectionTop(segmentedControl.selectedSegmentIndex, animated: false)
        collectionView.flashScrollIndicators()

    }

    private func loadEmojiSet() {

        if !emojiContainer.isLoaded {
            emojiContainer.load()
        }

    }

    private func setupView() {

        // Using SFSymbols might not be the best idea.

        segmentedControl = UISegmentedControl(items: [
            EmojiPickerSection.smileysPeople.imageForSegmentedControlElement,
            EmojiPickerSection.animalsNature.imageForSegmentedControlElement,
            EmojiPickerSection.foodDrink.imageForSegmentedControlElement,
            EmojiPickerSection.travelPlaces.imageForSegmentedControlElement,
            EmojiPickerSection.activities.imageForSegmentedControlElement,
            EmojiPickerSection.objects.imageForSegmentedControlElement,
            EmojiPickerSection.symbols.imageForSegmentedControlElement,
            EmojiPickerSection.flags.imageForSegmentedControlElement
        ])

        segmentedControl.tintColor = .label
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(scrollToSelectedSection(sender:)), for: .valueChanged)

        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.itemSize = .init(width: 50, height: 50)
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.headerReferenceSize = .init(width: view.bounds.width, height: 50)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.contentInset.bottom = view.safeAreaInsets.bottom + segmentedControl.intrinsicContentSize.height + 15 // 15 is spacer.

        searchBar = UISearchBar(frame: .zero)
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.placeholder = NSLocalizedString("search_emoji", bundle: .module, comment: "SearchBar placeholder text: hints what the user should enter in.")
        searchBar.returnKeyType = .search
        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self

        view.backgroundColor = .systemBackground

        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(segmentedControlContainerVisualEffectView)
        segmentedControlContainerVisualEffectView.contentView.addSubview(segmentedControl)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlContainerVisualEffectView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 5),
            searchBar.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            segmentedControlContainerVisualEffectView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            segmentedControlContainerVisualEffectView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            segmentedControlContainerVisualEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlContainerVisualEffectView.contentView.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainerVisualEffectView.contentView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlContainerVisualEffectView.contentView.trailingAnchor),
            segmentedControl.bottomAnchor.constraint(equalTo: segmentedControlContainerVisualEffectView.contentView.bottomAnchor),
        ])

        segmentedControlContainerVisualEffectView.clipsToBounds = true
        segmentedControlContainerVisualEffectView.layer.cornerRadius = segmentedControl.layer.cornerRadius
    }

    private func setupDataSource() {

        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, EmojiPickerItem> { [unowned self] cell, indexPath, item in

            if let emoji = item.emoji {

                let index = (self.diffableDataSource.snapshot().indexOfItem(item) ?? 0) + 1
                var contentConfiguration = LabelContentConfiguration()
                contentConfiguration.text = String(emoji.character)
                contentConfiguration.font = UIFont.systemFont(ofSize: cell.bounds.height) // Presents the emoji as equal size as the parent cell.
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

            let section = self.diffableDataSource.sectionIdentifier(for: indexPath.section)!
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

}


extension EmojiPickerViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = diffableDataSource.itemIdentifier(for: indexPath), let emoji = item.emoji else {
            return
        }

        delegate?.emojiPickerViewController(self, didPick: emoji)

    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        /*
         `setContentOffset` triggers this method, but it doesn't trigger dragging.
         */
        guard scrollView.isDragging else {
            return
        }

        /*
         Consider the top section as the selected segment if multiple sections appear.
         */
        let indexPathsForVisibleHeaders = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader).sorted(by: { $0.section < $1.section })
        if let indexPathForVisibleTopSectionHeader = indexPathsForVisibleHeaders.first {
            segmentedControl.selectedSegmentIndex = indexPathForVisibleTopSectionHeader.section
        }

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
        return CGSize(width: collectionView.bounds.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right), height: flowLayout.itemSize.height)

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

    func scrollToSectionTop(_ section: Int, animated: Bool) {

        /*
         `layoutAttributesForSupplementaryView` is very useful API, however the `headerAttributes.frame.origin.x(or frame.minY)` returns the bottom frame of the section when the flowLayout.sectionHeadersPinToVisibleBounds is `true`, like this:

         # Expected

         |      Scrolled top header    | ← top
         | cell0,0 | cell0,1 | cell0,2 |
         | cell0,3 | cell0,4 | cell0,5 |
         | cell0,6 | cell0,7 | cell0,8 |
         |         Next Header         |


         # Unexpected
         |      Scrolled top header    | ← top, but the position is bottom of the section
         |         Next Header         |

         # Conclusion
         we can get `expected` by calculating `cellAttribute.frame.minY - headerAttributes.frame.height` and get `unexpected` by using `headerAttributes.frame.height`

         */

        guard
            let cellAttribute = collectionViewLayout.layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
            let headerAttributes = collectionViewLayout.layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: section))
        else {
            return
        }

        setContentOffset(CGPoint(x: 0, y: cellAttribute.frame.minY - headerAttributes.frame.height), animated: animated)

    }

}
