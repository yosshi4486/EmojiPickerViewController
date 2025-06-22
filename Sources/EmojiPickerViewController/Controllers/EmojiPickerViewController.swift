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

#if os(iOS)
import UIKit
import Collections

/**
 A *View Controller* for picking an emoji.

 # Sizing Emojis
 The emoji is sized as same as the cell size, so you can change the emoji size and the number of emojis in each row by changing `flowLayout.itemSize`.

 # Design
 The basic design and relationship refers `PHPickerViewController` and `PHPickerConfiguration`.

 */
open class EmojiPickerViewController: UIViewController {

    /**
     The picker’s delegate object.
     */
    open weak var delegate: EmojiPickerViewControllerDelegate?

    /**
     The object that contains information about how to configure a emoji picker view controller.
     */
    public let configuration: EmojiPickerConfiguration

    /**
     The container that loads entire information for emoji.
     */
    public let emojiContainer: EmojiContainer = .main

    /**
     The locale which specifies the emoji locale information for the loading.

     Assigning a new emoji locale causes `loadAnnotations()` of the emoji container. You can assign it to `emojiContainer.emojiLocale` if you want to avoid the automatic loading.
     */
    public var emojiLocale: EmojiLocale {

        get {
            return emojiContainer.emojiLocale
        }

        set {
            emojiContainer.emojiLocale = newValue
            emojiContainer.loadAnnotations()
        }

    }

    /**
     The emoji search results. The initial value is empty.
     */
    var searchResults: [EmojiPickerItem] = [] {
        didSet {
            updateFrequentlyUsedSection(animate: configuration.animatingChanges)
            updateSegmentedControlElements()
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

    /**
     Creates a new emoji picker view controller with the configuration you specify.

     - Parameters:
       - configuration
       The configuration with which to initialize the view controller.
     */
    public init(configuration: EmojiPickerConfiguration) {
        self.configuration = configuration
        super.init(nibName: nil, bundle: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(updateAnnotationsAutomatically(_:)), name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)

    }

    @available(*, unavailable, message: "Must use init(configuration:)")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("")
    }

    @available(*, unavailable, message: "Must use init(configuration:)")
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        loadEmojiSet()
        setupView()
        setupDataSource()
        applyData()
        updateFrequentlyUsedSection(animate: false)
        updateSegmentedControlElements()

    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        collectionView.flashScrollIndicators()

    }

    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        /*
         Adjust bottom layout.

         0 is good if safearea appears, on the other hand, 15 is good if safearea doesn't appears.

         https://developer.apple.com/documentation/uikit/uiview/positioning_content_relative_to_the_safe_area
         */
        if view.safeAreaInsets.bottom == 0 {
            additionalSafeAreaInsets.bottom = 15
        }

    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            reloadCollectionView()
        }

    }

    /**
     Reloads the entire collectionview information.

     The system calls this method automatically when the picker's trailtCollection changes. You can call this method after you assign a new object to `pickerViewController.configuration`.
     */
    open func reloadCollectionView() {

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

        let items: [UIImage] = {
            if emojiContainer.recentlyUsedEmojis.isEmpty {
                return [
                    UIImage(emojiPickerSection: .smileysPeople),
                    UIImage(emojiPickerSection: .animalsNature),
                    UIImage(emojiPickerSection: .foodDrink),
                    UIImage(emojiPickerSection: .travelPlaces),
                    UIImage(emojiPickerSection: .activities),
                    UIImage(emojiPickerSection: .objects),
                    UIImage(emojiPickerSection: .symbols),
                    UIImage(emojiPickerSection: .flags)
                ]
            } else {
                return [
                    UIImage(emojiPickerSection: .frequentlyUsed(.recentlyUsed)),
                    UIImage(emojiPickerSection: .smileysPeople),
                    UIImage(emojiPickerSection: .animalsNature),
                    UIImage(emojiPickerSection: .foodDrink),
                    UIImage(emojiPickerSection: .travelPlaces),
                    UIImage(emojiPickerSection: .activities),
                    UIImage(emojiPickerSection: .objects),
                    UIImage(emojiPickerSection: .symbols),
                    UIImage(emojiPickerSection: .flags)
                ]
            }
        }()

        segmentedControl = UISegmentedControl(items: items)

        segmentedControl.tintColor = .label
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(scrollToSelectedSection(sender:)), for: .valueChanged)

        flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.sectionInset = .init(top: 0, left: 10, bottom: 0, right: 10)
        flowLayout.itemSize = configuration.cellAppearance.size
        flowLayout.sectionHeadersPinToVisibleBounds = true
        flowLayout.headerReferenceSize = .init(width: view.bounds.width, height: 50)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.contentInset.bottom = view.safeAreaInsets.bottom + segmentedControl.intrinsicContentSize.height + 15 // 15 is spacer.

        searchBar = UISearchBar(frame: .zero)
        searchBar.autocapitalizationType = .none
        searchBar.searchTextField.placeholder = String(localized: "search_emoji", bundle: .module, comment: "SearchBar placeholder text: hints what the user should enter in.")
        searchBar.returnKeyType = .search
        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.searchBarStyle = .minimal
        searchBar.delegate = self
        searchBar.accessibilityLabel = String(localized: "ax_searchbar_label", bundle: .module, comment: "Accessibility label: speaks what the purpose of the search field.")

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
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            segmentedControlContainerVisualEffectView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            segmentedControlContainerVisualEffectView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            segmentedControlContainerVisualEffectView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
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
                cell.accessibilityLabel = "\(emoji.textToSpeech), \(index)"

            } else {

                var contentConfiguration = LabelContentConfiguration()
                contentConfiguration.text = String(localized: "no_results", bundle: .module, comment: "Empty state text: feedbacks no-results to the user.")
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
            supplementaryView.appearance = self.configuration.headerAppearance

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

    // TODO: I think that the implementations around diffable data source are too complex. It should be refactored if there is a better idea.

    private func updateFrequentlyUsedSection(animate: Bool) {

        var snapshot = diffableDataSource.snapshot()

        if searchResults.isEmpty { /* Recently used or empty state */

            if searchBar.isFirstResponder { /* Empty state */

                if snapshot.indexOfSection(.frequentlyUsed(.searchResult)) == nil { /* Insert search result section */
                    snapshot.deleteSections([.frequentlyUsed(.recentlyUsed)])
                    snapshot.insertSections([.frequentlyUsed(.searchResult)], beforeSection: .smileysPeople)
                    snapshot.appendItems([.empty], toSection: .frequentlyUsed(.searchResult))
                    diffableDataSource.apply(snapshot, animatingDifferences: animate)

                } else { /* Replace search result section */

                    // Using section snapshot to repalce the section data.
                    var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<EmojiPickerItem> = .init()
                    sectionSnapshot.append([.empty], to: nil)
                    diffableDataSource.apply(sectionSnapshot, to: .frequentlyUsed(.searchResult), animatingDifferences: animate)

                }

            } else { /* Recently used */

                if snapshot.indexOfSection(.frequentlyUsed(.recentlyUsed)) == nil { /* Insert recently used section */
                    snapshot.deleteSections([.frequentlyUsed(.searchResult)])

                    let recentlyUsedItems: [EmojiPickerItem] = emojiContainer.recentlyUsedEmojis.suffix(configuration.numberOfItemsInRecentlyUsedSection).map({ .recentlyUsed($0 )})
                    if !recentlyUsedItems.isEmpty {
                        snapshot.insertSections([.frequentlyUsed(.recentlyUsed)], beforeSection: .smileysPeople)
                        snapshot.appendItems(recentlyUsedItems, toSection: .frequentlyUsed(.recentlyUsed))
                    }

                    diffableDataSource.apply(snapshot, animatingDifferences: animate)

                } else { /* Replace recently used section */

                    let recentlyUsedItems: [EmojiPickerItem] = emojiContainer.recentlyUsedEmojis.suffix(configuration.numberOfItemsInRecentlyUsedSection).map({ .recentlyUsed($0 )})
                    if recentlyUsedItems.isEmpty {
                        snapshot.deleteSections([.frequentlyUsed(.recentlyUsed)])
                        diffableDataSource.apply(snapshot, animatingDifferences: animate)
                    } else {
                        var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<EmojiPickerItem> = .init()
                        sectionSnapshot.append(recentlyUsedItems, to: nil)
                        diffableDataSource.apply(sectionSnapshot, to: .frequentlyUsed(.recentlyUsed), animatingDifferences: animate)
                    }

                }

            }

        } else { /* Search results */
         
            if snapshot.indexOfSection(.frequentlyUsed(.searchResult)) == nil { /* Insert search result section */
                snapshot.deleteSections([.frequentlyUsed(.recentlyUsed)])
                snapshot.insertSections([.frequentlyUsed(.searchResult)], beforeSection: .smileysPeople)
                snapshot.appendItems(searchResults, toSection: .frequentlyUsed(.searchResult))
                diffableDataSource.apply(snapshot, animatingDifferences: animate)

            } else { /* Replace search result section */

                // Using section snapshot to repalce the section data.
                var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<EmojiPickerItem> = .init()
                sectionSnapshot.append(searchResults, to: nil)
                diffableDataSource.apply(sectionSnapshot, to: .frequentlyUsed(.searchResult), animatingDifferences: animate)

            }

        }

    }

    private func updateSegmentedControlElements() {

        var hasChanges: Bool = false

        let snapshot = diffableDataSource.snapshot()
        if snapshot.indexOfSection(.frequentlyUsed(.recentlyUsed)) == nil && snapshot.indexOfSection(.frequentlyUsed(.searchResult)) == nil {
            if segmentedControl.numberOfSegments > EmojiLabel.allCases.count {
                segmentedControl.removeSegment(at: 0, animated: false)
                hasChanges = true
            }
        } else {
            if segmentedControl.numberOfSegments == EmojiLabel.allCases.count {
                segmentedControl.insertSegment(with: UIImage(emojiPickerSection: .frequentlyUsed(.recentlyUsed)), at: 0, animated: false)
                hasChanges = true
            }
        }

        if hasChanges {
            updateSelectedSegmentIndexToTopSection()
        }

    }

    @objc private func updateSelectedSegmentIndexToTopSection() {

        let indexPathsForVisibleHeaders = collectionView.indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader).sorted(by: { $0.section < $1.section })
        if let indexPathForVisibleTopSectionHeader = indexPathsForVisibleHeaders.first {
            segmentedControl.selectedSegmentIndex = indexPathForVisibleTopSectionHeader.section
        }

    }

    @objc private func updateAnnotationsAutomatically(_ notification: Notification) {

        guard configuration.automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange, let primaryLanguage = (notification.object as? UITextInputMode)?.primaryLanguage else {
            return
        }

        guard let autoUpdatingResource = EmojiLocale(localeIdentifier: primaryLanguage) else {
            return
        }

        emojiLocale = autoUpdatingResource

        NotificationCenter.default.post(name: EmojiContainer.currentAnnotationDidChangeNotification, object: autoUpdatingResource)

    }


}

extension EmojiPickerViewController: UIScrollViewAccessibilityDelegate {

    public func accessibilityScrollStatus(for scrollView: UIScrollView) -> String? {

        /*
         `accessibilityScrollStatus(for:)` is called **after** the accessibility scrolling.
         `accessibilityScroll(_:)` is called before the accessibility scrolling.

         This method is appropriate for updating the currently selected segment index.
         */
        updateSelectedSegmentIndexToTopSection()

        // Floor decimals.
        let pageHeight = collectionView.bounds.height
        let currentPage = Int(collectionView.contentOffset.y / pageHeight) + 1 // the value is zero until collectinView.contentOffset.y becomes equal to pageHeight, however the user counts from 1.
        let totalPages = Int(collectionView.contentSize.height / pageHeight)

        let visibleSectionsLabel: String = collectionView
            .indexPathsForVisibleSupplementaryElements(ofKind: UICollectionView.elementKindSectionHeader)
            .sorted(by: { $0.section < $1.section })
            .compactMap({ [unowned self] in self.diffableDataSource.sectionIdentifier(for: $0.section) })
            .reduce(into: "", { $0 += ",\($1.localizedSectionName)" })

        // Should we prefer to use `accessibilityAttributedScrollStatus(for:)`?
        return String(format: String(localized: "ax_collection_view_scroll_status", bundle: .module, comment:  "Accessibility scroll status: speaks the current page index and the visible section labels."), currentPage as NSNumber, totalPages as NSNumber, visibleSectionsLabel as NSString)
    }

}


extension EmojiPickerViewController: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let item = diffableDataSource.itemIdentifier(for: indexPath), let emoji = item.emoji else {
            return
        }

        emojiContainer.saveRecentlyUsedEmoji(emoji)

        // Update `recently used` section if it exists.
        if diffableDataSource.snapshot().indexOfSection(.frequentlyUsed(.recentlyUsed)) != nil {
            var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<EmojiPickerItem> = .init()
            sectionSnapshot.append(emojiContainer.recentlyUsedEmojis.suffix(configuration.numberOfItemsInRecentlyUsedSection).map({ .recentlyUsed($0) }), to: nil)
            diffableDataSource.apply(sectionSnapshot, to: .frequentlyUsed(.recentlyUsed), animatingDifferences: configuration.animatingChanges)
        }

        delegate?.emojiPickerViewController(self, didPick: emoji)

    }
    
    public func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        guard let item = diffableDataSource.itemIdentifier(for: indexPath), let emoji = item.emoji, !emoji.orderedSkinToneEmojis.isEmpty else {
            return nil
        }
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return nil }
            
            let skinToneActions = emoji.orderedSkinToneEmojis.map { skinToneEmoji in
                UIAction(title: String(skinToneEmoji.character),
                         image: skinToneEmoji.image(for: cell?.bounds.size ?? .init(width: 60, height: 60)),
                         identifier: nil,
                         discoverabilityTitle: skinToneEmoji.textToSpeech.isEmpty ? nil : skinToneEmoji.textToSpeech,
                         attributes: [],
                         state: .off) { [weak self] _ in
                    
                    guard let self = self else { return }
                    
                    // Save the selected skin tone emoji
                    self.emojiContainer.saveRecentlyUsedEmoji(skinToneEmoji)
                    
                    // Update recently used section if it exists
                    if self.diffableDataSource.snapshot().indexOfSection(.frequentlyUsed(.recentlyUsed)) != nil {
                        var sectionSnapshot: NSDiffableDataSourceSectionSnapshot<EmojiPickerItem> = .init()
                        sectionSnapshot.append(self.emojiContainer.recentlyUsedEmojis.suffix(self.configuration.numberOfItemsInRecentlyUsedSection).map({ .recentlyUsed($0) }), to: nil)
                        self.diffableDataSource.apply(sectionSnapshot, to: .frequentlyUsed(.recentlyUsed), animatingDifferences: self.configuration.animatingChanges)
                    }
                    
                    // Notify delegate about the selection
                    self.delegate?.emojiPickerViewController(self, didPick: skinToneEmoji)
                }
            }
            
            return UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: [.displayAsPalette, .displayInline],
                          children: skinToneActions)
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return createTargetedPreview(for: configuration, in: collectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return createTargetedPreview(for: configuration, in: collectionView)
    }
    
    private func createTargetedPreview(for configuration: UIContextMenuConfiguration, in collectionView: UICollectionView) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = collectionView.cellForItem(at: indexPath) else {
            return nil
        }
        
        let parameters = UIPreviewParameters()
        
        // Create a rounded rectangle path that matches the cell bounds
        let cornerRadius: CGFloat = min(cell.bounds.width, cell.bounds.height) * 0.2
        let roundedPath = UIBezierPath(roundedRect: cell.bounds, cornerRadius: cornerRadius)
        parameters.visiblePath = roundedPath
        
        // Set background color to transparent to avoid visual artifacts
        parameters.backgroundColor = .clear
        
        return UITargetedPreview(view: cell, parameters: parameters)
    }

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {

        /*
         `setContentOffset` triggers this method, but it doesn't trigger dragging.
         */
        guard scrollView.isDragging else {
            return
        }

        updateSelectedSegmentIndexToTopSection()

    }

}

private extension Emoji {
    
    func image(for size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: .init(width: size.width, height: size.height))
        let image = renderer.image { _ in
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: size.width),
                .backgroundColor: UIColor.clear
            ]
            let string = String(character)
            let textSize = string.size(withAttributes: attributes)
            let rect = CGRect(
                x: (size.width - textSize.width) / 2,
                y: (size.height - textSize.height) / 2,
                width: textSize.width,
                height: textSize.height
            )
            string.draw(in: rect, withAttributes: attributes)
        }
        return image
    }
    
}

extension EmojiPickerViewController: UICollectionViewDelegateFlowLayout {

    /*
     This implementation is to adopt size category changes.
     */
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let temporaryHeaderView = LabelCollectionHeaderView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: 0))
        
        temporaryHeaderView.appearance = EmojiPickerConfiguration.HeaderAppearance(
            font: UIFont.systemFont(ofSize: 16),
            textColor: .label,
            textAlignment: .center,
            backgroundColor: .systemBackground,
            labelPadding: UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        )
        
        temporaryHeaderView.headerLabel.text = " "
        
        let fittingSize = temporaryHeaderView.systemLayoutSizeFitting(
            CGSize(width: collectionView.bounds.width, height: UIView.layoutFittingExpandedSize.height),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return fittingSize
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
        delegate?.emojiPickerViewControllerDidBeginSearching(self)
    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        delegate?.emojiPickerViewControllerDidEndSearching(self)
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
#endif
