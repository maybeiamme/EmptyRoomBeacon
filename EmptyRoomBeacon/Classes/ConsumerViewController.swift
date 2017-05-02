//
//  ConsumerViewController.swift
//  Pods
//
//  Created by Jin Hyong Park on 2/5/17.
//
//

import UIKit
import AudioToolbox

public class ConsumerViewController: UIViewController {

    var currentImageName = ""
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 194.0/255.0, alpha: 1)
        
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 50, width: 300, height: 300))
        titleLabel.textColor = UIColor.black
        titleLabel.text = "The\nEmpty\nRoom"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 70)
        
        
        let subTitleLabel = UILabel(frame: CGRect(x: 20, y: 290, width: 300, height: 250))
        subTitleLabel.textColor = UIColor.darkGray
        subTitleLabel.text = "Kenneth Poon\nSampath Kumar\nJin Hyuong Park"
        subTitleLabel.numberOfLines = 0
        subTitleLabel.textAlignment = .left
        subTitleLabel.font = UIFont.systemFont(ofSize: 20)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(subTitleLabel)
        PGBeaconManager.sharedInstance.delegate = self
        PGBeaconManager.sharedInstance.setupBeacons()
        
        // Do any additional setup after loading the view.
    }

    public override func didReceiveMemoryWarning() {
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

extension ConsumerViewController: PGBeaconManagerDelegate {
    
    func didReceiveBeaconImage(imageName: String){
        if self.currentImageName == imageName {
            return
        }
        if let _ = self.presentedViewController {
            return
        }
        self.currentImageName = imageName
        let contentViewController = BeaconContentViewController(imageFile: imageName)
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        self.present(contentViewController, animated: true, completion: nil)
    }
}
