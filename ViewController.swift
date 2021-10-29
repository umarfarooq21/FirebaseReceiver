//
//  ViewController.swift
//  ReceiverApp
//
//  Created by UmarFarooq on 04/10/2021.
//

import UIKit
import FirebaseDatabase
import GoogleMaps

class ViewController: UIViewController {

    var ref: DatabaseReference?
    var dbHandler: DatabaseHandle?
    var marker = GMSMarker()
    
    @IBOutlet weak var gsmView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ref = Database.database().reference()
        
        
        //Change Event Node
        //i.e my observer node
        
        if ref != nil {
            let firebase = "Drivers/driver2"
            
            dbHandler = ref?.child(firebase).observe(.value, with: { (snapshot) in
                //self.ref.child(firebase).removeValue()
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                var lat: String = ""
                var long: String = ""
                
                print("Observer received.........")
                
                if let latValue = postDict["driverLat"] as? String {
                    lat = latValue
                }
                
                if let longValue = postDict["driverLong"] as? String {
                    long = longValue
                }
                
                if lat == "" || long == "" {
                    return
                }
                
                
                //self.loadMap(lat: Double(lat)!, Long: Double(long)!)
                /*
                if let duration = postDict["duration"] as? String {
                    //showDialogWithOneButton(animated: true, viewControl: self, titleMsg: "" , msgTitle: "Your driver is \(duration) Away")
                }*/
                
                self.showDriverMarker(lat: Double(lat)!, long: Double(long)!)
                
            })
            
        }
        
        //detach listner
        //loadMap(lat: 24.9817, Long: 67.1162)
    }
    
    func showDriverMarker(lat: Double, long:Double) {
        
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.snippet = "Driver Umar"
        marker.map = self.gsmView
        marker.icon = UIImage(named: "map_marker")
        self.gsmView?.selectedMarker = marker
        /*
        marker.appearAnimation
        marker.infoWindowAnchor
        marker.isFlat
        marker.groundAnchor
        marker.position*/
        
        var bounds = GMSCoordinateBounds()
        let destination = CLLocationCoordinate2DMake(lat, long)
        bounds = bounds.includingCoordinate(destination)
        
        self.gsmView?.animate(toLocation: CLLocationCoordinate2D(latitude: lat, longitude: long))
        
    }
    
    func firebaseListner(lat: Double, Long: Double){
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: Long, zoom: 10)
        gsmView?.camera = camera
        gsmView?.animate(to: camera)
    }
    
    func firebaseNodeObserver(){
        ///observer receiver
        
    }


}

