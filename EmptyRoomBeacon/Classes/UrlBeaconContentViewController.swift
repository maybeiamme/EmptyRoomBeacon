//
//  UrlBeaconContentViewController.swift
//  Pods
//
//  Created by Shepherd on 2017. 5. 2..
//
//

import UIKit

class UrlBeaconContentViewController: BeaconContentViewController {

    let url: String
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebview()
        // Do any additional setup after loading the view.
    }
    
    init(url: String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    func loadWebview() {
        webView.loadRequest(URLRequest(url: URL(string: url)!))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
