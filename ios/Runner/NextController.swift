//
//  NextController.swift
//  Runner
//
//  Created by 石井幸次 on 2018/04/13.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

import UIKit

class NextController: UIViewController {
    @IBOutlet var label: UILabel!

    var onClose: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func unwindToTop(segue _: UIStoryboardSegue) {
        dismiss(animated: true, completion: { [weak self] () in
            self?.onClose?()
        })
    }
}
