//
//  ViewController.swift
//  Example
//
//  Created by yosshi4486 on 2022/02/06.
//

import UIKit
import EmojiPickerViewController

class ViewController: UIViewController {

    let resultLabel: UILabel = .init(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(resultLabel)
        resultLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

        resultLabel.text = ""

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Pick Emoji", image: nil, primaryAction: UIAction(handler: { [unowned self] _ in
            self.showPicker()
        }))

    }

    func showPicker() {

        let emojiPicker = EmojiPickerViewController()

        /*
         Receiveing events from the picker view controller.
         */
        emojiPicker.delegate = self

        /*
         Disabling changes animation.
         */
        emojiPicker.animatingChanges = false

        /*
         Customizing the collectionview layout via `UICollectionViewFlowLayout` object.
         */
        emojiPicker.flowLayout.itemSize = .init(width: 60, height: 60)

        /*
         Customizing the searchbar appearances.
         */
        emojiPicker.searchBar.searchTextField.textColor = .blue

        /*
         Customizing the visual effect.
         */
        emojiPicker.visualEffectView.effect = UIBlurEffect(style: .systemUltraThinMaterial)

        /*
         Specifying the language for searching and voiceover.
         */
        emojiPicker.emojiContainer.emojiLocale = EmojiLocale(localeIdentifier: "ja")!

        /*
         Activating an automatic-annotations-update option.
         */
        emojiPicker.emojiContainer.automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange = true

        /*
         Getting the loaded emoji.
         */

        // Getting the emoji via the emoji picker, or
        let bouncingBall = emojiPicker.emojiContainer.entireEmojiSet["⛹🏿‍♀"]!
        print(bouncingBall)

        // singleton main container.
        let grapes = EmojiContainer.main.entireEmojiSet["🍇"]!
        print(grapes)

        // You can also run load() at any time earlier, such as UIApplicationDelegate, UISceneDelegate and so on.
        // EmojiContainer.main.load()
        
        /*
         This is recommented implementation. In iPad, presents the picker as a popover, otherwise presents it as a sheet.
         */
        if traitCollection.userInterfaceIdiom == .pad {

            emojiPicker.modalPresentationStyle = .popover

            let popover = emojiPicker.popoverPresentationController!
            popover.barButtonItem = navigationItem.rightBarButtonItem
            popover.delegate = self

            let sheet = popover.adaptiveSheetPresentationController
            sheet.delegate = self
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true

        } else {

            emojiPicker.modalPresentationStyle = .pageSheet

            let sheet = emojiPicker.sheetPresentationController!
            sheet.delegate = self
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true

        }

        present(emojiPicker, animated: true)

    }

}

extension ViewController: EmojiPickerViewControllerDelegate {

    func emojiPickerViewController(_ emojiPickerViewController: EmojiPickerViewController, didPick emoji: Emoji) {

        print("The user picked \(emoji)")
        resultLabel.text!.append(emoji.character)

        /*
         Dismiss the `emojiPickerViewController` here if you don't want to allow multiple picking.
         */

        // emojiPickerViewController.dismiss(animated: true, completion: nil)
    }

    func emojiPickerViewController(_ emojiPickerViewController: EmojiPickerViewController, didReceiveError error: Error) {
        print(error)
    }

}

extension ViewController: UISheetPresentationControllerDelegate {

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("EmojiPickerViewController did dismiss.")
    }

}

extension ViewController: UIPopoverPresentationControllerDelegate {

}
