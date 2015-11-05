//
//  MenuController.swift
//  nav_test
//
//  Created by mac on 9/16/15.
//  Copyright © 2015 mac. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import Alamofire

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {
    
    var menu = [Menu]()
    var menuFiltered = [Menu]()
    
    var didPressFilterButton: Bool = false
    var previousButtonTag = 5
    
    var myMarker: MKAnnotation?
    var dispensary: mkDispensary?
    
    @IBOutlet weak var productTableView: UITableView!
    @IBOutlet weak var dispensaryName: UINavigationItem!
    
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var indicaButton: UIButton!
    @IBOutlet weak var hybridButton: UIButton!
    @IBOutlet weak var sativaButton: UIButton!
    @IBOutlet weak var edibleButton: UIButton!
    
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var indicaLabel: UILabel!
    @IBOutlet weak var hybridLabel: UILabel!
    @IBOutlet weak var sativaLabel: UILabel!
    @IBOutlet weak var edibleLabel: UILabel!
    
    
    @IBOutlet weak var filterLabelDescription: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.productTableView.dataSource = self
        self.productTableView.delegate = self
        
        indicaLabel.hidden = true
        hybridLabel.hidden = true
        sativaLabel.hidden = true
        edibleLabel.hidden = true
        
        getMenu()
        productTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func filterButtonPressed(sender: UIButton) {
        if previousButtonTag == 1 {
            indicaButton.setBackgroundImage(UIImage(named: "IndicaDark"), forState: UIControlState.Normal)
        }
        if previousButtonTag == 2 {
            hybridButton.setBackgroundImage(UIImage(named: "HybridDark"), forState: UIControlState.Normal)
        }
        if previousButtonTag == 3 {
            sativaButton.setBackgroundImage(UIImage(named: "SativaDark"), forState: UIControlState.Normal)
        }
        if previousButtonTag == 4 {
            edibleButton.setBackgroundImage(UIImage(named: "EdibleDark"), forState: UIControlState.Normal)
        }
        if previousButtonTag == 5 {
            allButton.setBackgroundImage(UIImage(named: "BluntDark"), forState: UIControlState.Normal)
        }
        didPressFilterButton = true
        menuFiltered = [Menu]()
        if sender.tag == 1 {
            //print(NSThread.isMainThread() ? "Main Thread" : "Not on Main Thread")
            indicaButton.setBackgroundImage(UIImage(named: "Indica"), forState: UIControlState.Normal)
            indicaLabel.hidden = false
            //indicaButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            //hybridButton.setBackgroundImage(UIImage(named: "HybridDark"), forState: UIControlState.Normal)
            filter("Indica")
            filterLabelDescription.text = "Indica strains tend to be sedating and relaxing with full-body effects"
            
        } else if sender.tag == 2 {
            hybridButton.setBackgroundImage(UIImage(named: "Hybrid"), forState: UIControlState.Normal)
            hybridLabel.hidden = false
            //sender.titleLabel?.textColor = UIColor.blackColor()
            filter("Hybrid")
            filterLabelDescription.text = "Hybrid strains are a cross between Hybrid and Sativa dominant strains"
        } else if sender.tag == 3 {
            sativaButton.setBackgroundImage(UIImage(named: "Sativa"), forState: UIControlState.Normal)
            sativaLabel.hidden = false
            filter("Sativa")
            filterLabelDescription.text = "Sativa strains tend to be uplifting and creative with cerebrally-focused effects"
        } else if sender.tag == 4 {
            edibleButton.setBackgroundImage(UIImage(named: "Edible"), forState: UIControlState.Normal)
            edibleLabel.hidden = false
            filter("Edibles")
            filterLabelDescription.text = "An edible product that contains THC"
        } else if sender.tag == 5 {
            allButton.setBackgroundImage(UIImage(named: "Blunt"), forState: UIControlState.Normal)
            allLabel.hidden = false
            didPressFilterButton = false
            filterLabelDescription.text = "All items"
            //filter("Other")
        }
        previousButtonTag = sender.tag
        //print(NSThread.isMainThread() ? "Main Thread" : "Not on Main Thread")
        productTableView.reloadData()
    }
    
   func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if menuFiltered.count == 0 {
//            print("drawing the table, the count of menu is", menu.count)
//            return menu.count
//        } else {
//            return menuFiltered.count
//        }
        if didPressFilterButton == false {
            return menu.count
        } else {
            return menuFiltered.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = productTableView.dequeueReusableCellWithIdentifier("StrainCell") as? StrainCell
        cell!.tintColor = mainInstance.color
        
        if didPressFilterButton == false {
            cell!.nameLabel?.text = menu[indexPath.row].strainName
        } else {
            cell!.nameLabel?.text = menuFiltered[indexPath.row].strainName
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowProduct", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ShowProduct", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let productViewController = segue.destinationViewController as! ProductViewController
        if let indexPath = productTableView.indexPathForCell(sender as! UITableViewCell) {
            productViewController.menuItem = menu[indexPath.row]
        }

        
    }
    
    func filter(filter: String) {
        print(filter)
        for product in menu {
            if product.category == filter {
                menuFiltered.append(product)
            }
        }
    }
    
    func getMenu() {
        let dispensaryID = self.dispensary!.id
        
//        if myMarker?.userData != nil {
//            dispensary = myMarker!.userData! as! Dispensary
//            print(dispensary!)
//            dispensaryID = String(dispensary!.id)
//            print(dispensaryID)
//        } else {
//            //dispensaryID = String(dispensary!.id)
//            dispensaryID = "1"
//        }
        //print("this is the id", dispensaryID)
        
        
        //Alamo fire http request for the items disp carries
        let string = "http://getlithub.herokuapp.com/getMenu/\(dispensaryID)"
        print(string)
        Alamofire.request(.GET, string)
            .responseJSON { response in
            //Runs if success
            if response.data != nil {
                print("Checked for disp items, success")
                let arrOfProducts = JSON(response.result.value!)
                    if arrOfProducts.count != 0 {
                        for var i = 0; i < arrOfProducts.count; ++i {
                            let dispensaryName = arrOfProducts[i]["name"].string
                            let strainID = arrOfProducts[i]["strain_id"].int
                            let strainName = arrOfProducts[i]["strain_name"].string
                            let vendorID = arrOfProducts[i]["vendor_id"].int
                            let priceGram = arrOfProducts[i]["price_gram"].double
                            let priceEigth = arrOfProducts[i]["price_eigth"].double
                            let priceQuarter = arrOfProducts[i]["price_quarter"].double
                            let priceHalf = arrOfProducts[i]["price_half"].double
                            let priceOz = arrOfProducts[i]["price_oz"].double
                            let category = arrOfProducts[i]["category"].string
//                          let symbol = arrOfProducts[i]["symbol"].string
                            let description = arrOfProducts[i]["description"].string
                            let fullImage = arrOfProducts[i]["fullsize_img1"].string
                            let dispensaryMenu = Menu(dispensaryName: dispensaryName!, strainID: strainID!, vendorID: vendorID!, priceGram: priceGram!, priceEigth: priceEigth!, priceQuarter: priceQuarter!, priceHalf: priceHalf!, priceOz: priceOz!, strainName: strainName!, category: category!, description: description!)
                            dispensaryMenu.fullsize_img1 = fullImage
                            self.menu.append(dispensaryMenu)
                        }
                        self.dispensaryName.title = self.menu[0].dispensaryName
                        print("printing the menu count", self.menu.count)
                        self.productTableView.reloadData()
                } else {
                    print("there were no items")
                }

            //Failure case
            } else {
                print("There was an error getting your user information")
            }
        }
        //End alamofire
    }
    //end getMenu func
    
    @IBAction func backToMenuViewController(segue: UIStoryboardSegue) {
        let menuViewController = segue.sourceViewController as? MenuViewController
        print("attempting to go to menu")
    }
}
