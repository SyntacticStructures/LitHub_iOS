//
//  ProductViewController.swift
//  nav_test
//
//  Created by mac on 9/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import Alamofire

class ProductViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var menuItem: Menu!
    var amountSelectedData = [String]()
    var email: String?
    var userID: Int?
    
    
    @IBOutlet weak var productName: UINavigationItem!
    @IBOutlet weak var productImage: UIImageView!
    //@IBOutlet weak var productDescription: UITextView!
    //@IBOutlet weak var indicaPercentage: UILabel!
    //@IBOutlet weak var sativaPercentage: UILabel!
    //@IBOutlet weak var thcPercentage: UILabel!
    //@IBOutlet weak var growDifficulty: UILabel!
    @IBOutlet weak var amountSelected: UIPickerView!
    
    @IBAction func removeButtonPressed(sender: UIButton) {
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUser()
        //        getOrder()
        self.amountSelected.delegate = self
        self.amountSelected.dataSource = self
        
        productName.title = menuItem.strainName
        //self.amountSelected.setValue(UIColor.whiteColor(), forKeyPath: "textColor")
        //productDescription.text = menuItem.description
        //growDifficulty.text = menuItem.growDifficulty
        let priceGram = "Price per gram: $" + String(format: "%.2f", menuItem.priceGram)
        let priceEigth = "Price per eigth: $" + String(format: "%.2f", menuItem.priceEigth)
        let priceQuarter = "Price per quarter: $" + String(format: "%.2f", menuItem.priceQuarter)
        let priceHalf = "Price per half: $" + String(format: "%.2f", menuItem.priceHalf)
        let priceOz = "Price per oz: $" + String(format: "%.2f", menuItem.priceOz)
        self.amountSelectedData.append(priceGram)
        self.amountSelectedData.append(priceEigth)
        self.amountSelectedData.append(priceQuarter)
        self.amountSelectedData.append(priceHalf)
        self.amountSelectedData.append(priceOz)
        //print(menuItem.fullsize_img1)
        
        //        if let url = NSURL(string: self.menuItem.fullsize_img1! ) {
        //            if let data = NSData(contentsOfURL: url){
        //                self.productImage.contentMode = UIViewContentMode.ScaleAspectFit
        //                self.productImage.image = UIImage(data: data)
        //            }
        //        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    //get current user
    func getCurrentUser() {
        self.userID = mainInstance.userID
//        let string = "http://getlithub.herokuapp.com/currentUser"
//        Alamofire.request(.GET, string)
//            .responseJSON { request, response, result in switch result {
//                case .Success(let data):
//                    let user = JSON(data)
//                    print("user info", user)
//                    self.currentUserId = String(user["id"])
//                    self.email = String(user["email"])
//                    print("current user ID", self.currentUserId)
//                    print("current user email", self.email)
//                case .Failure(_, let error):
//                    print("There was an error getting your user information")
//                    }
//            }
    }
    
    @IBAction func addToCartPressed(sender: UIButton) {
        let amount = amountSelected.selectedRowInComponent(0)
        let status = "0"
        let dispensaryName = menuItem.dispensaryName
        let strainName = menuItem.strainName
        let priceGram = menuItem.priceGram
        let priceEigth = menuItem.priceEigth
        let priceQuarter = menuItem.priceQuarter
        let priceHalf = menuItem.priceHalf
        let priceOz = menuItem.priceOz
        var quantityGram = 0
        var quantityEigth = 0
        var quantityQuarter = 0
        var quantityHalf = 0
        var quantityOz = 0
        if amount == 0 {
            quantityGram = 1
        } else if amount == 1 {
            quantityEigth = 1
        } else if amount == 2 {
            quantityQuarter = 1
        } else if amount == 3 {
            quantityHalf = 1
        } else if amount == 4 {
            quantityOz = 1
        }
        
        let reservation = Reservation(status: status, vendor: dispensaryName, strainName: strainName,
                                    priceGram: priceGram, priceEigth: priceEigth, priceQuarter: priceQuarter, priceHalf: priceHalf, priceOz: priceOz,
                                    quantityGram: quantityGram, quantityEigth: quantityEigth, quantityQuarter: quantityQuarter, quantityHalf: quantityHalf, quantityOz: quantityOz)
        mainInstance.cart.append(reservation)
        print(mainInstance.cart.count)
        
    }
    
    
    //add an order
//    @IBAction func addButtonPressed(sender: UIButton) {
//        let row = amountSelected.selectedRowInComponent(0)
//        let string = "http://getlithub.herokuapp.com/addOrder"
//        var gram = "0"
//        var eight = "0"
//        var quarter = "0"
//        var half = "0"
//        var oz = "0"
//        switch row {
//        case 0:
//            gram = "1"
//        case 1:
//            eight = "1"
//        case 2:
//            quarter = "1"
//        case 3:
//            half = "1"
//        case 4:
//            oz = "1"
//        default:
//            print("error. default thrown in switch case in productViewController")
//        }
//        print("this is the item row selected", row)
//        let date = String(NSDate())
//        let orderData = ["status": 0, "created_at": date, "updated_at": date, "user_id": currentUserId!, "vendor_id": menuItem.vendorID, "quantity_gram": gram, "quantity_eigth": eight, "quantity_quarter": quarter, "quantity_half": half, "quantity_oz": oz, "strain_id": menuItem.strainID]
//        //Alamofire request
//        Alamofire.request(.POST, string, parameters: orderData as! [String : AnyObject], encoding: .JSON)
//            .responseJSON { request, response, result in switch result {
//            case .Success(let data):
//                print("Order input was a success. This should be empty", data)
//            case .Failure(_, let error):
//                print("There was an error submitting order information")
//                }
//        }
//
//    }
    
    
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = amountSelectedData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        return myTitle
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return amountSelectedData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return amountSelectedData[row]
    }
    
//    modularize this later DRY :)
    
//    func getOrder() {
//        if let urlToReq = NSURL(string: "http://192.168.1.146:8081/getReservations"){
//            let request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq)
//            request.HTTPMethod = "POST"
//            let bodyData = "id=\(Int(id)!)"
//            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
//            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
//                (response, data, error) in
//                let realData = JSON(data: data!)
//                print(realData)
//            }
//        }
//    }
    
}
