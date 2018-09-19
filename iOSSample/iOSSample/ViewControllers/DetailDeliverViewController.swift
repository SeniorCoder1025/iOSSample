//
//  DetailDeliverViewController.swift
//  iOSSample
//
//  Created by apple on 9/19/18.
//  Copyright © 2018 ken. All rights reserved.
//

import UIKit
import MapKit

class DetailDeliverViewController: UIViewController, MKMapViewDelegate {
    
    var deliver: Deliver?
    
    // UI Components
    let mapView = MKMapView()
    let imageView = UIImageView()
    let titleView = UILabel()
    let addressView = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "Delivery Detail"
        setupViews()
    }
    
    func setupViews() {
        // mapView
        self.view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        let margins = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: margins.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: -150)
            ])
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: (deliver?.lat)!, longitude: (deliver?.lng)!)
        mapView.addAnnotation(annotation)
        let viewRegion = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 400, 400)
        mapView.setRegion(viewRegion, animated: true)
        
        // imageView
        self.view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 15)
        ])
        imageView.af_setImage(withURL: URL(string: (deliver?.imageUrl)!)!, placeholderImage: UIImage(named: "img_default"))
        
        // titleView
        self.view.addSubview(titleView)
        titleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            titleView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
        titleView.text = deliver?.desc
        
        // Address
        self.view.addSubview(addressView)
        addressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addressView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 10),
            addressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)
        ])
        addressView.text = deliver?.address
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
