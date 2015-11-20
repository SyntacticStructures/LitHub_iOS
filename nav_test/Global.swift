//
//  Global.swift
//  LitHub
//
//  Created by mac on 10/18/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation
import UIKit
import Socket_IO_Client_Swift

class Main {
    var userID : String?
    var cart = [Reservation]()
    var color = UIColor(red: 255/255, green: 167/255, blue: 18/255, alpha: 1.0)
    let socket = SocketIOClient(socketURL: "192.168.1.4:8888", options: [.Log(true)])
    
    init() {
        self.socket.on("connect") { data, ack in
            print("iOS connected")
        }
        
        self.socket.connect()
    }
    
    func signInAuth() {
        
    }
}

var mainInstance = Main()
