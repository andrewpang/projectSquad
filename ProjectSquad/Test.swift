//
//  Test.swift
//  ProjectSquad
//
//  Created by Andrew Pang on 2/21/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import Foundation

class Test: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func test(){
        NetManager.sharedManager.addFriend("alsfj;", friendID: "4")
        NetManager.sharedManager.addFriend("alsfj;", friendID: "5")
        NetManager.sharedManager.addFriend("alsfj;", friendID: "6")
    }
    
}
