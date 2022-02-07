//
//  EmojiSearchResultViewController.swift
//  
//
//  Created by yosshi4486 on 2022/02/07.
//

import UIKit

/**
 A *View Controller* for which present emoji's search results.
 */
class EmojiSearchResultViewController: UIViewController {

    enum Section: Int {
        case main
    }

    /**
     The picker view controller that manages this search interactions.
     */
    weak var pickerViewController: EmojiPickerViewController!
    
    /**
     The collection view for which shows search results.
     */
    var collectionView: UICollectionView!

    /**
     The visual effect view that adds blur effect. You can customize the effect by accessing the properties.
     */
    let visualEffectView: UIVisualEffectView = .init(effect: UIBlurEffect(style: .systemMaterial))

    /**
     The data source of the `collectionView`.
     */
    var dataSource: UICollectionViewDiffableDataSource<Section, Emoji>!

    /**
     The container that has a subset for keyboard.
     */
    var container: EmojiContainer = .main

    /**
     The search resuls. The initial value is empty.
     */
    var searchResults: [Emoji] = []

    /**
     Creates an *EmojiSearchResultViewController* instance by the container`pickerViewController`.

     - Parameters:
       - pickerViewController: The picker view controller that manages this search interactions..
     */
    init(pickerViewController: EmojiPickerViewController) {
        self.pickerViewController = pickerViewController
        super.init(nibName: nil, bundle: nil)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /**
     Searchs emojis by the given keywork. This method updates triggers `collectionView` update for presenting the search results.

     - Parameters:
       - keyboard: The keyboard for which search emojis.
     */
    func search(from keyboard: String) {

        Task {
            let results = await container.searchEmojisForKeyboard(from: keyboard)
            DispatchQueue.main.async {
                self.searchResults = results
                self.updateDataSource()
            }
        }

    }

    private func setup() {

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = pickerViewController.flowLayout.minimumLineSpacing
        flowLayout.minimumInteritemSpacing = pickerViewController.flowLayout.minimumInteritemSpacing
        flowLayout.itemSize = pickerViewController.flowLayout.itemSize

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

        let emojiCellRegistration = UICollectionView.CellRegistration<UICollectionViewCell, Emoji> { [unowned self] cell, indexPath, emoji in
            let index = (self.dataSource.snapshot().indexOfItem(emoji) ?? 0) + 1
            var contentConfiguration = EmojiContentConfiguration(emoji: emoji)
            contentConfiguration.accessibilityIndexOfEmoji = index
            cell.contentConfiguration = contentConfiguration
        }

        dataSource = UICollectionViewDiffableDataSource<Section, Emoji>(collectionView: collectionView, cellProvider: { collectionView, indexPath, emoji in
            return collectionView.dequeueConfiguredReusableCell(using: emojiCellRegistration, for: indexPath, item: emoji)
        })

        collectionView.dataSource = dataSource

        var snapshot: NSDiffableDataSourceSnapshot<Section, Emoji> = .init()
        snapshot.appendSections([Section.main])
        dataSource.apply(snapshot)

    }

    private func updateDataSource() {

        var snapshot: NSDiffableDataSourceSnapshot<Section, Emoji> = .init()
        snapshot.appendSections([Section.main])
        snapshot.appendItems(searchResults, toSection: .main)
        dataSource.apply(snapshot)

    }

}

extension EmojiSearchResultViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let emoji = searchResults[indexPath.row]
        pickerViewController.delegate?.emojiPickerViewController(pickerViewController, didPick: emoji)

    }

}
