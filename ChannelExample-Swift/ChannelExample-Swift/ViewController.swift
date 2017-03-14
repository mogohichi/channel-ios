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
        
        Channel.checkNewMessages { (numberOfNewMessages) in
            if numberOfNewMessages > 0 {
                let alert = UIAlertController(title: "", message: "You have \(numberOfNewMessages) new mesage", preferredStyle: .alert)
                let viewAction = UIAlertAction(title: "View", style: .default, handler: { (_) in
                    self.openChatView()
                })
                alert.addAction(viewAction)
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                    
                })
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openChatView() {
        let userID = "ThisIsTheID"
        let userData = ["screen":"main",
                        "button":"contact"]
        let vc = Channel.chatViewController(withUserID: userID, userData: userData)
        vc.title = "Your title"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didTapContact(_ sender: Any) {
        openChatView()
    }
}

