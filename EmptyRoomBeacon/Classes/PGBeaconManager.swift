//
//  PGBeaconManager.swift
//  Test360
//
//  Created by Kenneth Poon on 26/4/17.
//  Copyright © 2017 Kenneth Poon. All rights reserved.
//

import Foundation
import AudioToolbox
import CoreLocation
import CoreBluetooth

class PGBeaconManager: NSObject {
    public static let sharedInstance: PGBeaconManager = PGBeaconManager()
    let locationManager = CLLocationManager()
    var delegate: PGBeaconManagerDelegate?
    var uuidToImageFileDictionary = [String: String]()
    
    private override init(){
        
    }
    
    func setupBeacons(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        self.loadIBeacons()

    }
    
    func loadIBeacons(){
        let bundle = Bundle(for: type(of: self))
        guard let url = (bundle.resourceURL as NSURL?)?.appendingPathComponent("EmptyRoomBeacon.bundle") else {
            return
        }
        
        guard let resourcebundle = Bundle(url: url) else {
            return
        }
        
        if let path = resourcebundle.path(forResource: "iBeacon", ofType: "plist") {
            if let _dict = NSDictionary(contentsOfFile: path) as? [String : Any] {
                if let beaconArray = _dict["Beacons"] as? [[String: Any]] {
                    for beaconDictionary in beaconArray {
                        
                        guard let enabled = beaconDictionary["enabled"] as? Bool else { continue }
                        guard enabled else { continue }
                        
                        guard let name = beaconDictionary["Name"] as? String else { continue }
                        guard let uuid = beaconDictionary["UUID"] as? String else { continue }
                        
                        guard let major = beaconDictionary["major"] as? NSNumber else { continue }
                        guard let minor = beaconDictionary["minor"] as? NSNumber else { continue }
                        guard let imageFile = beaconDictionary["imageFile"] as? String else { continue }
                        
                        let aBeaconRegion = CLBeaconRegion(
                            proximityUUID: UUID(uuidString: uuid)!,
                            major: major.uint16Value, minor: minor.uint16Value, identifier: name)
                        
                        self.uuidToImageFileDictionary[uuid] = imageFile
                        self.locationManager.startRangingBeacons(in: aBeaconRegion)
                    }
                }
            }
        }
    }
}


extension PGBeaconManager : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let firstBeacon = beacons.first {
            if firstBeacon.accuracy <= 1{
                if let imageFile = self.uuidToImageFileDictionary[firstBeacon.proximityUUID.uuidString] {
                    self.delegate?.didReceiveBeaconImage(imageName: imageFile)
                }
            }
            
        }
    }
}


protocol PGBeaconManagerDelegate {
    func didReceiveBeaconImage(imageName: String)
}
