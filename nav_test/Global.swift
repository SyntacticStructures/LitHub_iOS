//
//  Global.swift
//  LitHub
//
//  Created by mac on 10/18/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import Socket_IO_Client_Swift
import Parse

class Main {
    var userID : String?
    
    var cart = [Reservation]()
    var reservationStatus = "0"
    var progressBarView: UIProgressView?
    var reservationStatusLabel: UILabel?
    var shopAgainButton: UIButton?
    
    
    var color = UIColor(red: 255/255, green: 167/255, blue: 18/255, alpha: 1.0)
    let socket = SocketIOClient(socketURL: "192.168.1.67:8888", options: [.Log(true)])
    let keychain = KeychainSwift()
    
    
    
    var deviceToken: String?
    var firstConnect = true
    
    init() {
        print("global")
//        self.socket.connect()
//        self.keychain.clear()
        if self.keychain.get("userID") != nil {
            self.userID = self.keychain.get("userID")
        }
        
        self.socket.on("connect") { data, ack in
            self.firstConnect = false
            print("iOS connected")
            let currentInstallation = PFInstallation.currentInstallation()
            if let userId = self.userID {
                let userData: [String: AnyObject] = [
                    "userID": userId,
                    "device_id": currentInstallation.objectId!
                ]
                self.socket.emit("UserLoggedIn", userData)
            }
        }
    }
    
    func setReservationStatus() {
        print("in setReservationStatus")
        let endPoint = "http://getlithub.herokuapp.com/getReservations"
        let userData: [String: AnyObject] = [
            "id": self.userID!
        ]
        Alamofire.request(.POST, endPoint, parameters: userData as! [String: AnyObject], encoding: .JSON)
            .responseJSON { response in
                if response.result.isSuccess {
                    let arrayOfReservations = JSON(response.result.value!)
                    if arrayOfReservations.count > 0 {
                        self.reservationStatus = arrayOfReservations[0]["status"].string!
                        
                        if self.reservationStatus == "1" {
                            self.progressBarView?.setProgress(0.75, animated: true)
                            self.reservationStatusLabel?.text = "Your order is ready for pickup!"
                        } else if self.reservationStatus == "2" {
                            self.progressBarView?.setProgress(1.0, animated: true)
                            self.reservationStatusLabel?.text = "You picked up"
                            self.shopAgainButton?.hidden = false
                        }
                    }
                } else {
                    print("error setting reservation status")
                }
        }
        
    }
    
    
}

var mainInstance = Main()
