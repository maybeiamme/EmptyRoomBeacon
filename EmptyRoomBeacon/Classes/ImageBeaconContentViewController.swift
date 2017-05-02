//
//  ImageBeaconContentViewController.swift
//  Pods
//
//  Created by Shepherd on 2017. 5. 2..
//
//

import UIKit

class ImageBeaconContentViewController: BeaconContentViewController {

    let imageFile: String
    
    init(imageFile: String) {
        self.imageFile = imageFile
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadWebview() {
        let bundle = Bundle(for: type(of: self))
        
        guard let url = (bundle.resourceURL as NSURL?)?.appendingPathComponent("EmptyRoomBeacon.bundle") else {
            return
        }
        
        webView.loadHTMLString(self.generateHtmlString(fileName: self.imageFile), baseURL: url)
    }
    
    func generateHtmlString(fileName: String) -> String {
        return "<html><head><script src=\"https://aframe.io/releases/0.5.0/aframe.min.js\"></script></head><body><a-scene><a-sky src=\"\(fileName)\" rotation=\"0 -130 0\"></a-sky></a-scene></body></html>"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadWebview()
        // Do any additional setup after loading the view.
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
