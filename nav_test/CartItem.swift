//
//  Cart.swift
//  LitHub
//
//  Created by mac on 10/23/15.
//  Copyright © 2015 mac. All rights reserved.
//

import Foundation

//let orderData = ["status": 0, "created_at": date, "updated_at": date, "user_id": currentUserId!, "vendor_id": menuItem.vendorID, "quantity_gram": gram, "quantity_eigth": eight, "quantity_quarter": quarter, "quantity_half": half, "quantity_oz": oz, "strain_id": menuItem.strainID]

class CartItem {
    var userID: Int
    var vendorID: Int
    var strainID: Int
    var quantityGram: Int
    var quantityEigth: Int
    var quantityQuarter: Int
    var quantityHalf: Int
    var quantityOz: Int
    
    init(userID: Int, vendorID: Int, strainID: Int) {
        self.userID = userID
        self.vendorID = vendorID
        self.strainID = strainID
        self.quantityGram = 0
        self.quantityEigth = 0
        self.quantityQuarter = 0
        self.quantityHalf = 0
        self.quantityOz = 0
    }
    
}