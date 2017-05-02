//
//  ConsumerViewController.swift
//  EmptyRoomBeacons
//
//  Created by Jin Hyong Park on 2/5/17.
//  Copyright © 2017 PropertyGuru. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

public class AgentViewController: UIViewController {
    
    var localBeacon: CLBeaconRegion?
    var beaconPeripheralData: NSDictionary?
    var peripheralManager: CBPeripheralManager?
    
    let uuidTitleLabel = UILabel()
    
    let uuidLabel = UILabel()
    let uuidButton = UIButton()
    let majorLabel = UILabel()
    let majorTextField = UITextField()
    let minorLabel = UILabel()
    let minorTextField = UITextField()
    let broadcastButton = UIButton(type: .roundedRect)
    let pickerView = UIPickerView()
    
    var broadcasting : Bool = false
    var uuid : String? {
        let bundle = Bundle(for: type(of: self))
        guard let url = (bundle.resourceURL as NSURL?)?.appendingPathComponent("EmptyRoomBeacon.bundle") else {
            return nil
        }
        
        guard let resourcebundle = Bundle(url: url) else {
            return nil
        }
        
        guard let path = resourcebundle.path(forResource: "UUIDs", ofType: "plist") else {
            return nil
        }
        guard let _dict = NSDictionary(contentsOfFile: path) as? [String : Any] else {
            return nil
        }
        guard let _uuid = _dict["uuid"] as? String else {
            return nil
        }
        
        return _uuid
    }
    var uuids : Array<String> {
        
        guard let path = Bundle(for: type(of: self)).path(forResource: "UUIDs", ofType: "plist") else {
            return Array<String>()
        }
        guard let _dict = NSDictionary(contentsOfFile: path) as? [String : NSArray] else {
            return Array<String>()
        }
        
        guard let _uuids = _dict["uuids"] as? Array<String> else {
            return Array<String>()
        }
        
        return _uuids
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(uuidTitleLabel)
        uuidTitleLabel.text = "Service UUID"
        
        self.view.addSubview(uuidLabel)
        uuidLabel.text = self.uuid//"B0702880-A295-A8AB-F734-031A98A512DE"
        
        self.view.addSubview(majorLabel)
        majorLabel.text = "Major"
        
        self.view.addSubview(majorTextField)
        minorTextField.keyboardType = .numberPad
        
        self.view.addSubview(minorLabel)
        minorLabel.text = "Minor"
        
        self.view.addSubview(minorTextField)
        minorTextField.keyboardType = .numberPad
        
        self.view.addSubview(uuidButton)
        uuidButton.addTarget(self, action: #selector( AgentViewController.selectUUIDs(sender:)), for: .touchUpInside)
        
//        self.view.addSubview(pickerView)
//        pickerView.dataSource = self
//        pickerView.delegate = self
//        pickerView.isHidden = true
        
        self.view.addSubview(broadcastButton)
        broadcastButton.addTarget(self, action: #selector(AgentViewController.broadcast(sender:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    override public func viewDidLayoutSubviews() {
        let screen = UIScreen.main.bounds
        
        uuidTitleLabel.frame = CGRect(x: 20.0, y: 104.0, width: screen.size.width - 20.0 * 2, height: 44.0 )
        uuidLabel.frame = CGRect(x: uuidTitleLabel.frame.origin.x, y: uuidTitleLabel.frame.origin.y + uuidTitleLabel.frame.size.height + 10.0, width: uuidTitleLabel.frame.size.width, height: uuidTitleLabel.frame.size.height )
        uuidLabel.layer.borderWidth = 1.0
        uuidLabel.layer.borderColor = UIColor.black.cgColor
        
        majorLabel.frame = CGRect(x: uuidLabel.frame.origin.x, y: uuidLabel.frame.origin.y + uuidLabel.frame.size.height + 20.0, width: screen.size.width / 2.0 - 40.0, height: 44.0)
        majorTextField.frame = CGRect(x: majorLabel.frame.origin.x, y: majorLabel.frame.origin.y + majorLabel.frame.size.height + 10.0, width: majorLabel.frame.size.width, height: majorLabel.frame.size.height )
        majorTextField.layer.borderColor = UIColor.black.cgColor
        majorTextField.layer.borderWidth = 1.0
        
        
        minorLabel.frame = CGRect(x: majorLabel.frame.origin.x + majorLabel.frame.size.width + 40.0, y: uuidLabel.frame.origin.y + uuidLabel.frame.size.height + 20.0, width: screen.size.width / 2.0 - 40.0, height: 44.0)
        minorTextField.frame = CGRect(x: minorLabel.frame.origin.x, y: minorLabel.frame.origin.y + minorLabel.frame.size.height + 10.0, width: minorLabel.frame.size.width, height: minorLabel.frame.size.height )
        minorTextField.layer.borderColor = UIColor.black.cgColor
        minorTextField.layer.borderWidth = 1.0
        
        pickerView.frame = CGRect(x: 0.0, y: screen.height - pickerView.frame.size.height, width: screen.size.height, height: pickerView.frame.size.height)
        
        broadcastButton.setTitle(localBeacon == nil ? "Start Broadcast" : "Stop Broadcast", for: .normal)
        broadcastButton.frame = CGRect(x: screen.size.width / 2.0 - 200.0 / 2.0, y: minorTextField.frame.origin.y + minorTextField.frame.size.height + 20.0, width: 200.0, height: 88.0)
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func selectUUIDs( sender : UIButton ) {
        
    }
    
    func broadcast( sender : UIButton ) {
        if localBeacon != nil {
            stopLocalBeacon()
            self.viewDidLayoutSubviews()
        } else {
            startLocalBeacon()
            self.viewDidLayoutSubviews()
        }
    }
    
    func startLocalBeacon() {
        let localBeaconUUID = self.uuid
        let localBeaconMajor: CLBeaconMajorValue = UInt16(majorTextField.text ?? "1" ) ?? 1
        let localBeaconMinor: CLBeaconMinorValue = UInt16(minorTextField.text ?? "1" ) ?? 1
        
        let uuid = UUID(uuidString: localBeaconUUID!)!
        localBeacon = CLBeaconRegion(proximityUUID: uuid, major: localBeaconMajor, minor: localBeaconMinor, identifier: "Beacon")
        
        beaconPeripheralData = localBeacon?.peripheralData(withMeasuredPower: nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
//        peripheralManager?.stopAdvertising()
    }
    
    func stopLocalBeacon() {
        peripheralManager?.stopAdvertising()
        peripheralManager = nil
        beaconPeripheralData = nil
        localBeacon = nil
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

extension AgentViewController : CBPeripheralManagerDelegate {
    /*!
     *  @method peripheralManagerDidUpdateState:
     *
     *  @param peripheral   The peripheral manager whose state has changed.
     *
     *  @discussion         Invoked whenever the peripheral manager's state has been updated. Commands should only be issued when the state is 
     *                      <code>CBPeripheralManagerStatePoweredOn</code>. A state below <code>CBPeripheralManagerStatePoweredOn</code>
     *                      implies that advertisement has paused and any connected centrals have been disconnected. If the state moves below
     *                      <code>CBPeripheralManagerStatePoweredOff</code>, advertisement is stopped and must be explicitly restarted, and the
     *                      local database is cleared and all services must be re-added.
     *
     *  @see                state
     *
     */
    @available(iOS 6.0, *)
    public func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            peripheralManager?.startAdvertising(beaconPeripheralData as! [String: AnyObject]!)
        } else if peripheral.state == .poweredOff {
            peripheralManager?.stopAdvertising()
        }
    }

    
}

extension AgentViewController : UIPickerViewDataSource {
    @available(iOS 2.0, *)
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return uuids.count
    }
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}

extension AgentViewController : UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return uuids[row]
    }
}
