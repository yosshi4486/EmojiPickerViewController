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
            resultLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

        resultLabel.text = ""

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let emojiPicker = EmojiPickerViewController()
        emojiPicker.delegate = self

        /*
         You can specify a language for searching and voiceover.
         */
        emojiPicker.emojiContainer.annotationLocale = .init(languageIdentifier: "ja")!
        
        let navigationController = UINavigationController(rootViewController: emojiPicker)
        navigationController.modalPresentationStyle = .pageSheet

        let sheet = navigationController.sheetPresentationController!
        sheet.delegate = self
        sheet.detents = [.medium(), .large()]

        present(navigationController, animated: true)
    }


}

extension ViewController: EmojiPickerViewControllerDelegate {

    func emojiPickerViewController(_ emojiPickerViewController: EmojiPickerViewController, didPick emoji: Emoji) {
        print("The user picked \(emoji)")
        resultLabel.text!.append(emoji.character)
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
