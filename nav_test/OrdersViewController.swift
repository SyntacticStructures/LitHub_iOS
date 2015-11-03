//
//  OrdersViewController.swift
//  nav_test
//
//  Created by Computer on 9/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import Alamofire

class OrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    //@IBOutlet weak var orderStatusLabel: UILabel!
    //@IBOutlet weak var orderNumberLabel: UILabel!
    //@IBOutlet weak var orderProgressBar: UIProgressView!
    //@IBOutlet weak var dispensaryLabel: UILabel!
    //@IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var ordersTable: UITableView!
    @IBOutlet weak var reservationIDLabel: UILabel!
    @IBOutlet weak var totalItemsLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var placeReservationButton: UIButton!
    @IBOutlet weak var reservationStatusLabel: UILabel!
    @IBOutlet weak var progressBarView: UIProgressView!
    
    var cartItems = [Reservation]()
    var reservations = Array<Reservation>()
    var totalPrice = 0.00
    //var prices = Array<String>()
    //var email = String()
    //var id = String()
    var orderId = String()
    var userID: Int?
    //    var currentUser = Array<NSDictionary>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBarView.tintColor = UIColor(red: 0, green: 0.8, blue: 0.2, alpha: 1.0)
        //print("reservations view load")
        ordersTable.dataSource = self
        ordersTable.delegate = self
        
        //let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        getCurrentUser()
        //getOrder()
        //print("view did load")
        //print(reservations.count)
        //view.addGestureRecognizer(tap)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
        tabItem.badgeValue = nil
        
        self.cartItems = mainInstance.cart
        if self.cartItems.count > 0 {
            reservationStatusLabel.text = "Order pending..."
            progressBarView.setProgress(0.25, animated: true)
        }
        self.ordersTable.reloadData()
        
        updateReservationsView()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell") as! OrderCell
        let cartItem = cartItems[indexPath.row]
        //print(reservation)
        //let price = prices[0]
        cell.strainLabel.text = cartItem.strainName
        if cartItem.quantityGram != 0 {
            cell.quantityLabel.text = "\(cartItem.quantityGram) Gram(s)"
            let gramTotal = cartItem.priceGram * Double(cartItem.quantityGram)
            self.totalPrice += gramTotal
            cell.priceLabel.text = "$" + String(format: "%.2f", gramTotal)
        } else if cartItem.quantityEigth != 0 {
            cell.quantityLabel.text = "\(cartItem.quantityEigth) Eigth(s)"
            let eigthTotal = cartItem.priceEigth * Double(cartItem.quantityEigth)
            //print(eigthTotal)
            self.totalPrice += eigthTotal
            //print(self.totalPrice)
            cell.priceLabel.text = "$" + String(format: "%.2f", eigthTotal)
        } else if cartItem.quantityQuarter != 0 {
            cell.quantityLabel.text = "\(cartItem.quantityQuarter) Quarter(s)"
            let quarterTotal = cartItem.priceQuarter * Double(cartItem.quantityQuarter)
            cell.priceLabel.text = "$" + String(format: "%.2f", quarterTotal)
        } else if cartItem.quantityHalf != 0 {
            cell.quantityLabel.text = "\(cartItem.quantityHalf) Half(s)"
            let halfTotal = cartItem.priceHalf * Double(cartItem.quantityHalf)
            cell.priceLabel.text = "$" + String(format: "%.2f", halfTotal)
        } else if cartItem.quantityOz != 0 {
            cell.quantityLabel.text = "\(cartItem.quantityOz) Oz(s)"
            let ozTotal = cartItem.priceOz * Double(cartItem.quantityOz)
            cell.priceLabel.text = "$" + String(format: "%.2f", ozTotal)
        }
        //cell.priceLabel.text = price
        return cell
    }
    
    func updateReservationsView() {
        //print("getting reservations count")
        if cartItems.count > 0 {
            print("hello")
            self.totalPrice = 0.00
            //print(self.totalPrice)
            let cartItem = cartItems[0]
            //let reservationID = reservation.id
            //let vendorName = reservation.vendor
            //reservationIDLabel.text = "\(vendorName) #\(reservationID)"
            totalItemsLabel.text = "Total: \(cartItems.count) item(s)"
            for var i = 0; i < cartItems.count; ++i {
                if cartItems[i].quantityGram != 0 {
                    let gramTotal = cartItems[i].priceGram * Double(cartItems[i].quantityGram)
                    self.totalPrice += gramTotal
                } else if cartItems[i].quantityEigth != 0 {
                    let eigthTotal = cartItems[i].priceEigth * Double(cartItems[i].quantityEigth)
                    self.totalPrice += eigthTotal
                } else if cartItems[i].quantityQuarter != 0 {
                    let quarterTotal = cartItems[i].priceQuarter * Double(cartItems[i].quantityQuarter)
                    self.totalPrice += quarterTotal
                } else if cartItems[i].quantityHalf != 0 {
                    let halfTotal = cartItems[i].priceHalf * Double(cartItems[i].quantityHalf)
                    self.totalPrice += halfTotal
                } else if cartItems[i].quantityOz != 0 {
                    let ozTotal = cartItems[i].priceOz * Double(cartItems[i].quantityOz)
                    self.totalPrice += ozTotal
                }
            }
            totalPriceLabel.text = "$" + String(format: "%.2f", self.totalPrice)
        }
    }

    
    func getCurrentUser() {
        self.userID = mainInstance.userID
    }
    
    @IBAction func placeReservationButtonPressed(sender: UIButton) {
        //print("place reservation pressed")
        let status = 0
        let date = String(NSDate())
        let userID = self.userID!
        let vendorID = cartItems[0].vendorID
        //print(vendorID)
        for var i = 0; i < cartItems.count; ++i {
            let strainID = cartItems[i].strainID
            var quantityGram = 0
            var quantityEigth = 0
            var quantityQuarter = 0
            var quantityHalf = 0
            var quantityOz = 0
            if cartItems[i].quantityGram == 1 {
                quantityGram = 1
            }
            if cartItems[i].quantityEigth == 1 {
                quantityEigth = 1
            }
            if cartItems[i].quantityQuarter == 1 {
                quantityQuarter = 1
            }
            if cartItems[i].quantityHalf == 1 {
                quantityHalf = 1
            }
            if cartItems[i].quantityOz == 1 {
                quantityOz = 1
            }
            let orderData = ["status": status, "created_at": date, "updated_at": date,
                             "user_id": userID, "vendor_id": vendorID, "quantity_gram": quantityGram,
                             "quantity_eigth": quantityEigth, "quantity_quarter": quantityQuarter,
                             "quantity_half": quantityHalf, "quantity_oz": quantityOz, "strain_id": strainID]
            print(orderData)
            Alamofire.request(.POST, "http://getlithub.herokuapp.com/addOrder", parameters: orderData as! [String: AnyObject], encoding: .JSON)
                .responseJSON { response in
                    print("in alamofire")
                    print(response.result.value!)
                    
                }
            reservationStatusLabel.text = "Order processing..."
            progressBarView.setProgress(0.5, animated: true)

            
        }
        
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

    
    @IBAction func cancelOrder(sender: UIButton) {
        if let urlToReq = NSURL(string: "http://getlithub.herokuapp.com/cancelOrder"){
            let request: NSMutableURLRequest = NSMutableURLRequest(URL: urlToReq)
            request.HTTPMethod = "POST"
            let bodyData = "id=\(Int(orderId)!)"
            request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response, data, error) in
                let realasdfData = JSON(data: data!)
                print(realasdfData)
            }
            //self.orderStatusLabel.hidden = true
            self.ordersTable.hidden = true
            //self.orderProgressBar.hidden = true
            //self.cancelButton.hidden = true
            //self.orderNumberLabel.text = "Your order has been canceled"
            //self.dispensaryLabel.text = "Thank you"
        }
    }
    
    func getOrder() {
        //print(id)
        let string = "http://getlithub.herokuapp.com/getReservations"
        let parameters = [
            "id": self.userID!
        ]
        Alamofire.request(.POST, string, parameters: parameters)
            .responseJSON { response in
                if response.data != nil {
                    //case .Success(let data):
                        let arrayOfReservations = JSON(response.result.value!)
                        self.reservations = [Reservation]()
                        //print(arrayOfReservations)
                        for var i = 0; i < arrayOfReservations.count; ++i {
                            let reservationID = arrayOfReservations[i]["id"].int
                            let status = arrayOfReservations[i]["status"].string
                            let vendorName = arrayOfReservations[i]["vendor"].string
                            let vendorID = arrayOfReservations[i]["vendor_id"].int
                            let strainName = arrayOfReservations[i]["name"].string
                            let strainID = arrayOfReservations[i]["strain_id"].int
                            let priceGram = arrayOfReservations[i]["price_gram"].double
                            let priceEigth = arrayOfReservations[i]["price_eigth"].double
                            let priceQuarter = arrayOfReservations[i]["price_quarter"].double
                            let priceHalf = arrayOfReservations[i]["price_half"].double
                            let priceOz = arrayOfReservations[i]["price_oz"].double
                            let quantityGram = arrayOfReservations[i]["quantity_gram"].int
                            let quantityEigth = arrayOfReservations[i]["quantity_eigth"].int
                            let quantityQuarter = arrayOfReservations[i]["quantity_quarter"].int
                            let quantityHalf = arrayOfReservations[i]["quantity_half"].int
                            let quantityOz = arrayOfReservations[i]["quantity_oz"].int
                            let reservation = Reservation(status: status!, vendor: vendorName!, vendorID: vendorID!, strainName: strainName!, strainID: strainID!,
                                                          priceGram: priceGram!, priceEigth: priceEigth!, priceQuarter: priceQuarter!, priceHalf: priceHalf!, priceOz: priceOz!,
                                                          quantityGram: quantityGram!, quantityEigth: quantityEigth!, quantityQuarter: quantityQuarter!, quantityHalf: quantityHalf!, quantityOz: quantityOz!)
                            reservation.id = reservationID
                            self.reservations.append(reservation)
                        }
                        self.updateReservationsView()
                        self.ordersTable.reloadData()
                    
                } else {
                //case .Failure(_, let error):
                    print("Request failed with error:")
                }
            }
        
    }
    
}
