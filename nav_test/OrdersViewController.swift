//
//  OrdersViewController.swift
//  nav_test
//
//  Created by Computer on 9/17/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import Alamofire
import Socket_IO_Client_Swift
import Parse

class OrdersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let keychain = KeychainSwift()

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
    @IBOutlet weak var shopAgainButton: UIButton!
    @IBOutlet weak var reservationStatusLabel: UILabel!
    @IBOutlet weak var progressBarView: UIProgressView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var cartItems = [Reservation]()
    var reservations = [Reservation]()
    var totalPrice = 0.00
    //var prices = Array<String>()
    //var email = String()
    //var id = String()
    var orderId = String()

    //var userID: Int?
    var global = mainInstance

    var userID = String()

    
    var didPlaceReservation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(keychain.get("userID"))
        if keychain.get("userID") != nil {
            //print("got user id from key chain")
            let userId = keychain.get("userID")!
            print("this is the userId: ", userId)
        }
        
        
        self.global.socket.on("MadeAvailable") { data, ack in
            print("vendor made available")
            self.reservationStatusLabel.text = "Your order is ready for pickup!"
            self.progressBarView.setProgress(0.75, animated: true)
//            let push = PFPush()
//            push.setMessage("Your order has now been made available")
//            push.sendPushInBackground()
        }
        
        self.global.socket.on("PickedUp") { data, ack in
            print("user picked up")
            self.reservationStatusLabel.text = "You picked up!"
            self.progressBarView.setProgress(1.0, animated: true)
            self.shopAgainButton.hidden = false
//            let push = PFPush()
//            push.setMessage("You picked up your order! Please rate your experience.")
//            push.sendPushInBackground()
        }
        
        
        //self.global.socket.connect()
        
        
        
        progressBarView.tintColor = UIColor(red: 0, green: 0.8, blue: 0.2, alpha: 1.0)
        placeReservationButton.backgroundColor = mainInstance.color
        //print("reservations view load")
        ordersTable.dataSource = self
        ordersTable.delegate = self
        getCurrentUser()
        getOrder()
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tabArray = self.tabBarController?.tabBar.items as NSArray!
        let tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
        tabItem.badgeValue = nil
        
        self.cartItems = mainInstance.cart
        if self.cartItems.count > 0 &&  didPlaceReservation == false {
            reservationStatusLabel.text = "Shopping..."
            progressBarView.setProgress(0.25, animated: true)
        }
        self.ordersTable.reloadData()
        if userID != "" {
            updateReservationsView()
        }
        
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var totalReservations = 0
        if reservations.count > 0 {
            totalReservations = reservations.count
        } else if cartItems.count > 0 {
            totalReservations = cartItems.count
        }
        return totalReservations
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OrderCell") as! OrderCell
        if reservations.count > 0 {
            let reservationItem = reservations[indexPath.row]
            //print(reservation)
            //let price = prices[0]
            cell.strainLabel.text = reservationItem.strainName
            if reservationItem.quantityGram != 0 {
                cell.quantityLabel.text = "\(reservationItem.quantityGram) Gram(s)"
                let gramTotal = reservationItem.priceGram * Double(reservationItem.quantityGram)
                self.totalPrice += gramTotal
                cell.priceLabel.text = "$" + String(format: "%.2f", gramTotal)
            } else if reservationItem.quantityEigth != 0 {
                cell.quantityLabel.text = "\(reservationItem.quantityEigth) Eigth(s)"
                let eigthTotal = reservationItem.priceEigth * Double(reservationItem.quantityEigth)
                //print(eigthTotal)
                self.totalPrice += eigthTotal
                //print(self.totalPrice)
                cell.priceLabel.text = "$" + String(format: "%.2f", eigthTotal)
            } else if reservationItem.quantityQuarter != 0 {
                cell.quantityLabel.text = "\(reservationItem.quantityQuarter) Quarter(s)"
                let quarterTotal = reservationItem.priceQuarter * Double(reservationItem.quantityQuarter)
                cell.priceLabel.text = "$" + String(format: "%.2f", quarterTotal)
            } else if reservationItem.quantityHalf != 0 {
                cell.quantityLabel.text = "\(reservationItem.quantityHalf) Half(s)"
                let halfTotal = reservationItem.priceHalf * Double(reservationItem.quantityHalf)
                cell.priceLabel.text = "$" + String(format: "%.2f", halfTotal)
            } else if reservationItem.quantityOz != 0 {
                cell.quantityLabel.text = "\(reservationItem.quantityOz) Oz(s)"
                let ozTotal = reservationItem.priceOz * Double(reservationItem.quantityOz)
                cell.priceLabel.text = "$" + String(format: "%.2f", ozTotal)
            }
            //cell.priceLabel.text = price
        } else if cartItems.count > 0 {
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
            
        }
        return cell
    }
    
    func updateReservationsView() {
        //print("getting reservations count")
        if reservations.count > 0 {
            print("update reservations view for existing order")
            self.totalPrice = 0.00
            totalItemsLabel.text = "Total: \(reservations.count) items(s)"
            for var i = 0; i < reservations.count; ++i {
                if reservations[i].quantityGram != 0 {
                    let gramTotal = reservations[i].priceGram * Double(reservations[i].quantityGram)
                    self.totalPrice += gramTotal
                } else if reservations[i].quantityEigth != 0 {
                    let eigthTotal = reservations[i].priceEigth * Double(reservations[i].quantityEigth)
                    self.totalPrice += eigthTotal
                } else if reservations[i].quantityQuarter != 0 {
                    let quarterTotal = reservations[i].priceQuarter * Double(reservations[i].quantityQuarter)
                    self.totalPrice += quarterTotal
                } else if reservations[i].quantityHalf != 0 {
                    let halfTotal = reservations[i].priceHalf * Double(reservations[i].quantityHalf)
                    self.totalPrice += halfTotal
                } else if reservations[i].quantityOz != 0 {
                    let ozTotal = reservations[i].priceOz * Double(reservations[i].quantityOz)
                    self.totalPrice += ozTotal
                }
                totalPriceLabel.text = "$" + String(format: "%.2f", self.totalPrice)

            }
        
        } else if cartItems.count > 0 {
            //print("hello")
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
        if mainInstance.userID != nil {
            self.userID = mainInstance.userID!
        } else if keychain.get("userID") != nil {
            self.userID = keychain.get("userID")!
            mainInstance.userID = self.userID
        } else {
            
        }
    }
    
    @IBAction func placeReservationButtonPressed(sender: UIButton) {
        didPlaceReservation = true
        //print("place reservation pressed")
        let status = 0
        let date = String(NSDate())
        let userID = self.userID
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
            print("This is the order data: ", orderData)
            let currentInstallation = PFInstallation.currentInstallation()
            let userOrder = ["vendor_id": vendorID, "device_id": currentInstallation.objectId!]
            Alamofire.request(.POST, "http://getlithub.herokuapp.com/addOrder", parameters: orderData as? [String: AnyObject], encoding: .JSON)
                .responseJSON { response in
                    print("in alamofire")
                    print(response.result.value!)
                    self.global.socket.emit("NewReservation", userOrder)
                    currentInstallation.addUniqueObject(currentInstallation.objectId!, forKey: "channels")
                    currentInstallation.saveInBackground()
                }
            reservationStatusLabel.text = "Order processing..."
            progressBarView.setProgress(0.5, animated: true)
            //activityIndicator.startAnimating()

//            if userID != "" {
//                let orderData = ["status": status, "created_at": date, "updated_at": date,
//                    "user_id": userID, "vendor_id": vendorID, "quantity_gram": quantityGram,
//                    "quantity_eigth": quantityEigth, "quantity_quarter": quantityQuarter,
//                    "quantity_half": quantityHalf, "quantity_oz": quantityOz, "strain_id": strainID]
//                print(orderData)
//                Alamofire.request(.POST, "http://getlithub.herokuapp.com/addOrder", parameters: orderData as! [String: AnyObject], encoding: .JSON)
//                    .responseJSON { response in
//                        print("in alamofire")
//                        print(response.result.value!)
//                        
//                }
//                reservationStatusLabel.text = "Order processing"
//                progressBarView.setProgress(0.5, animated: true)
//                //activityIndicator.startAnimating()
//
//            } else {
//                var alert = UIAlertView()
//                alert.title = "Unknown User"
//                alert.message = "Please sign in before continuing"
//                alert.addButtonWithTitle("Proceed")
//                alert.show()
//            }

            
        }
        
    }
    
    @IBAction func shopAgainButtonPressed(sender: UIButton) {
        print("user wants to shop again")
        let userData: [String: AnyObject] = [
            "userId": global.userID!
        ]
        Alamofire.request(.POST, "http://192.168.1.145:8888/orderComplete", parameters: userData as! [String: AnyObject], encoding: .JSON)
            .responseJSON { response in
                print("order complete:")
                
                let vendorId = self.cartItems[0].vendorID
                self.global.socket.emit("OrderCompleted", vendorId)
                
                self.shopAgainButton.hidden = true
                self.progressBarView.setProgress(0, animated: false)
                self.reservationStatusLabel!.text = "No items in cart"
                self.totalItemsLabel!.text = "Total: 0 items"
                self.totalPriceLabel!.text = "$00.00"
                self.totalPrice = 0.00
                self.cartItems = [Reservation]()
                self.reservations = [Reservation]()
                self.ordersTable.reloadData()
                
        }
        
    }

    
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
    
    //THIS FUNCTION WONT WORK UNTIL THE STRING VARIABLE POINTS TO THE ACTUAL SERVER
    func getOrder() {
        print("at get order", self.userID)
        let string = "http://getlithub.herokuapp.com/getReservations"
        let userData: [String: AnyObject] = [
            "id": self.global.userID!
        ]
        Alamofire.request(.POST, string, parameters: userData as! [String: AnyObject], encoding: .JSON)
            .responseJSON { response in
                print(response)
                if response.result.isSuccess {
                    print("there is cart items")
                    //case .Success(let data):
                    print(response.result)
                    let arrayOfReservations = JSON(response.result.value!)
                    self.reservations = [Reservation]()
                        if arrayOfReservations.count != 0 {
                            print("this is the orders,", arrayOfReservations)
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
                        }
                    
                } else {
                //case .Failure(_, let error):
                    print("Request failed with error:")
                }
            }
    }
    
}
