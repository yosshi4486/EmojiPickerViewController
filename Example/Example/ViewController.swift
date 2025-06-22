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

        EmojiContainer.main.load()
        
    }

    func showPicker() {

        var configuration = EmojiPickerConfiguration()

        /*
         Enabling changes animation.
         */
        // configuration.animatingChanges = true

        /*
         Specifying the maximum number of recently used emojis.
         */
        configuration.numberOfItemsInRecentlyUsedSection = 10

        /*
         Changing each header appearance.
         */
        // configuration.headerAppearance.textAlignment = .center

        /*
         Changing each cell appearance.
         */
        // configuration.cellAppearance.size = .init(width: 30, height: 30)

        /*
         Enabling/disabling skin tone picker (enabled by default).
         Long-press an emoji with skin tone variations to see the context menu.
         */
        // configuration.enableSkinTonePicker = false

        let emojiPicker = EmojiPickerViewController(configuration: configuration)

        /*
         Receiving events from the picker view controller.
         */
        emojiPicker.delegate = self

        /*
         Activating an automatic-annotations-update option.
         */
        // emojiPicker.automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange = true

        /*
         Specifying the language for searching and voiceover.
         */
        // emojiPicker.emojiLocale = EmojiLocale(localeIdentifier: "ja")!

        /*
         Getting the loaded emoji.
         */

        // Getting the emoji via the emoji picker, or
        let bouncingBall = emojiPicker.emojiContainer.entireEmojiSet["⛹🏿‍♀"]!
        print(bouncingBall)

        // singleton main container.
        let grape = EmojiContainer.main.labeledEmojisForKeyboard[.foodDrink]![0]
        print(grape)

        // You can also run load() at any time earlier, such as UIApplicationDelegate, UISceneDelegate and so on.
        // EmojiContainer.main.load()
        
        /*
         This is recommended implementation. In iPad, presents the picker as a popover, otherwise presents it as a sheet.
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

         emojiPickerViewController.dismiss(animated: true, completion: nil)
    }

    func emojiPickerViewControllerDidEndSearching(_ emojiPickerViewController: EmojiPickerViewController) {

        if traitCollection.userInterfaceIdiom == .pad {

            let popover = emojiPickerViewController.popoverPresentationController!
            let sheet = popover.adaptiveSheetPresentationController
            sheet.selectedDetentIdentifier = .medium

        } else {

            let sheet = emojiPickerViewController.sheetPresentationController!
            sheet.selectedDetentIdentifier = .medium

        }

    }

}

extension ViewController: UISheetPresentationControllerDelegate {

    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("EmojiPickerViewController did dismiss.")
    }

}

extension ViewController: UIPopoverPresentationControllerDelegate {

}
