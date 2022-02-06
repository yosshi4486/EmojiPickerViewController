//
//  ViewController.swift
//  Example
//
//  Created by yosshi4486 on 2022/02/06.
//

import UIKit
import EmojiPickerViewController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let emojiPicker = EmojiPickerViewController()
        let navigationController = UINavigationController(rootViewController: emojiPicker)
        navigationController.modalPresentationStyle = .pageSheet

        let sheet = navigationController.sheetPresentationController!
        sheet.detents = [.medium(), .large()]

        present(navigationController, animated: true)
    }


}

