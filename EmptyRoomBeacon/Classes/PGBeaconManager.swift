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
    var uuidToUrl = [String:String]()
    
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
                if let beaconDict = _dict["Beacons"] as? [String: Any] {
                    if let beaconsForUrl = beaconDict["Image"] as? [[String:Any]] {
                        for beaconDictionary in beaconsForUrl {
                            
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
                            
                            self.uuidToImageFileDictionary[uuid+"\(major)"+"\(minor)"] = imageFile
                            self.locationManager.startRangingBeacons(in: aBeaconRegion)
                        }
                    }
                    
                    if let beaconsForImage = beaconDict["Url"] as? [[String:Any]] {
                        for beaconDictionary in beaconsForImage {
                            
                            guard let enabled = beaconDictionary["enabled"] as? Bool else { continue }
                            guard enabled else { continue }
                            
                            guard let name = beaconDictionary["Name"] as? String else { continue }
                            guard let uuid = beaconDictionary["UUID"] as? String else { continue }
                            
                            guard let major = beaconDictionary["major"] as? NSNumber else { continue }
                            guard let minor = beaconDictionary["minor"] as? NSNumber else { continue }
                            guard let url = beaconDictionary["url"] as? String else { continue }
                            
                            let aBeaconRegion = CLBeaconRegion(
                                proximityUUID: UUID(uuidString: uuid)!,
                                major: major.uint16Value, minor: minor.uint16Value, identifier: name)
                            
                            self.uuidToUrl[uuid+"\(major)"+"\(minor)"] = url
                            self.locationManager.startRangingBeacons(in: aBeaconRegion)
                        }
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
                if let imageFile = self.uuidToImageFileDictionary[firstBeacon.proximityUUID.uuidString+"\(firstBeacon.major)"+"\(firstBeacon.minor)"] {
                    self.delegate?.didReceiveBeaconImage(imageName: imageFile)
                } else if let url = self.uuidToUrl[firstBeacon.proximityUUID.uuidString+"\(firstBeacon.major)"+"\(firstBeacon.minor)"] {
                    self.delegate?.didReceiveUrl(url: url)
                }
            }
            
        }
    }
}


protocol PGBeaconManagerDelegate {
    func didReceiveBeaconImage(imageName: String)
    func didReceiveUrl( url : String )
}
