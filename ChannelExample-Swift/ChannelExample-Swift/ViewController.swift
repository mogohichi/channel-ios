//
//  ViewController.swift
//  ChannelExample-Swift
//
//  Created by Apisit Toompakdee on 3/5/17.
//  Copyright © 2017 Mogohichi, Inc. All rights reserved.
//

import UIKit
import Channel

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func didTapContact(_ sender: Any) {
        let userID = "ThisIsTheID"
        let userData = ["screen":"main",
                        "button":"contact"]
        let vc = Channel.chatViewController(withUserID: userID, userData: userData)
        vc.title = "Your title"
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

