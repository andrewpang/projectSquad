//
//  Map.swift
//  ProjectSquad
//
//  Created by Karen Oliver on 2/21/16.
//  Copyright © 2016 Squad Up App. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class Map: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager!
    var squadId: String = "-KFp1qT2nHW1pWSwqzz4"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let containerView = UIView()
        let arrow = UIImageView(image: UIImage(named: "ForwardArrow"))
        arrow.contentMode = .ScaleAspectFit
        let titleLabel = UILabel()
        titleLabel.font = Themes.Fonts.bigBold
        titleLabel.attributedText = NSAttributedString(string: "SQUAD NAME")
        titleLabel.kern(Themes.Fonts.kerning)
        titleLabel.textColor = Themes.Colors.light
        titleLabel.sizeToFit()
        
        arrow.frame = CGRect(x: titleLabel.frame.size.width, y: 4, width: titleLabel.frame.size.height, height: titleLabel.frame.size.height-8)
        containerView.frame.size.height = titleLabel.frame.size.height
        containerView.frame.size.width = titleLabel.frame.size.width + titleLabel.frame.size.height
        //containerView.userInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(Map.toSquadOverview))
        
        containerView.addSubview(titleLabel)
        containerView.addSubview(arrow)
        
        self.navigationItem.titleView = containerView
        self.navigationItem.titleView?.userInteractionEnabled = true
        self.navigationItem.titleView?.addGestureRecognizer(tap)

        NetManager.sharedManager.getSquad(squadId, block: {squad in
            for(memberId, memberName) in squad.members{
                NetManager.sharedManager.listenForLocationUpdates(memberId, block: { location in
                                let dropPin = MKPointAnnotation()
                                dropPin.coordinate = location.coordinate
                                dropPin.title = "New York City"
                                self.map.addAnnotation(dropPin)
                })
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        
//        NetManager.sharedManager.listenForLocationUpdates("facebook:10153631255636387", block: {snapshot in
//            print(snapshot.coordinate.latitude)
//            
//            let dropPin = MKPointAnnotation()
//            dropPin.coordinate = snapshot.coordinate
//            dropPin.title = "New York City"
//            self.map.addAnnotation(dropPin)
//        })
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        map.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        NetManager.sharedManager.updateCurrentLocation(locationObj)
        
//        var coord = locationObj.coordinate
//        print(coord.latitude)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func toSquadOverview () {
        self.performSegueWithIdentifier("showSquadOverview", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
