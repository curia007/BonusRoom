//
//  ViewController.swift
//  Bonus Room
//
//  Created by Carmelo I. Uria on 12/1/15.
//  Copyright © 2015 Carmelo I. Uria. All rights reserved.
//

import UIKit

import HomeKit

class ViewController: UIViewController, HMHomeManagerDelegate
{
    private let homeManager: HMHomeManager = HMHomeManager()
    
    private var currentHome: HMHome?

    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.homeManager.delegate = self
    
        /*
        if (self.homeManager.homes.count < 1)
        {
            self.homeManager.addHomeWithName("My Home", completionHandler: { (home, error) -> Void in
                
                if (error == nil)
                {
                    debugPrint("home: \(self.homeManager.primaryHome?.name)")
                    self.currentHome = self.homeManager.primaryHome
                    
                    self.currentHome?.addRoomWithName("Bonus Room", completionHandler: { (room, roomError) -> Void in
                        if (roomError == nil)
                        {
                            guard let accessories:[HMAccessory] =  room?.accessories else { return }
                            debugPrint("\(accessories)")
                        }
                        else
                        {
                            print("\(__FUNCTION__)::  error:  \(error)")
                        }
                    })
                }
                else
                {
                    print("\(__FUNCTION__)::  error:  \(error)")
                }
                
            })
        }
        else
        {
            self.currentHome = self.homeManager.homes[0]
        }
        */
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func remoteAccessories (home: HMHome)
    {
        for accessory in home.accessories
        {
            home.removeAccessory(accessory, completionHandler: { (error) -> Void in
                if (error == nil)
                {
                    debugPrint("\(__FUNCTION__)::  accessory \(accessory.name) removed...")
                }
                else
                {
                    debugPrint("\(__FUNCTION__)::  error:  \(error)")
                }
            })
        }
    }
    
    // MARK: - HMHomeManagerDelegate
    
    func homeManagerDidUpdateHomes(manager: HMHomeManager)
    {
        self.test()
    }
    
    // MARK: - private methods
    
    private func test ()
    {
        self.currentHome = self.homeManager.homes[0]
        
        debugPrint("\(__FUNCTION__):  home: \(self.currentHome)")
        debugPrint("\(__FUNCTION__): \(self.currentHome?.accessories.count)")
        
        let accessories: [HMAccessory] = self.currentHome!.accessories
        
        for accessory in accessories
        {
            debugPrint("accessory: \(accessory)")
            self.accessoryInformation(accessory)
        }
        
        //self.remoteAccessories(self.currentHome!)
    }
    
    private func accessoryInformation (accessory: HMAccessory)
    {
        let services: [HMService] = accessory.services
        
        for service in services
        {
            let characteristics: [HMCharacteristic] = service.characteristics
            
            for characteristic in characteristics
            {
                if ( characteristic.value != nil)
                {
                    if (characteristic.metadata != nil)
                    {
                        if (characteristic.metadata?.format == HMCharacteristicMetadataFormatBool)
                        {
                            if (characteristic.value as! Bool == true)
                            {
                                characteristic.writeValue(false, completionHandler: { (error) -> Void in
                                    if (error != nil)
                                    {
                                        debugPrint("\(__FUNCTION__):  ")
                                    }
                                })
                            }
                            else
                            {
                                characteristic.writeValue(true, completionHandler: { (error) -> Void in
                                    if (error != nil)
                                    {
                                        debugPrint("\(__FUNCTION__):  ")
                                    }

                                })
                            }
                        }
                    }
                 }
                
            }
        }
    }

}

