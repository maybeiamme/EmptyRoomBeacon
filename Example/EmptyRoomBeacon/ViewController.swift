//
//  ViewController.swift
//  EmptyRoomBeacon
//
//  Created by maybeiamme on 05/02/2017.
//  Copyright (c) 2017 maybeiamme. All rights reserved.
//

import UIKit
import EmptyRoomBeacon

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func consumerAction(_ sender: Any) {
        let vc = ConsumerViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func agentAction(_ sender: Any) {
        let vc = AgentViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

