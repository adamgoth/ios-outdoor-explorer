//
//  ViewController.swift
//  national-adventure-poc
//
//  Created by Adam Goth on 12/1/16.
//  Copyright © 2016 Adam Goth. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterSiteTypes))
        
        createAnnotations()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        refreshAnnotations()
    }
    
    func filterSiteTypes() {
        performSegue(withIdentifier: "showSitesFilter", sender: self)
    }
    
    func createAnnotations() {
        var selectedSiteTypes: [DataService.SiteType]!
        let defaults = UserDefaults.standard
        if let previousFilter = defaults.object(forKey: "filteredSiteTypes") as? [String] {
            let mappedSites = previousFilter.map { return DataService.SiteType(rawValue: $0)! }
            print(mappedSites)
            selectedSiteTypes = mappedSites
        } else {
            print("nah")
            selectedSiteTypes = DataService.allSiteTypes
        }
        if selectedSiteTypes.contains(DataService.SiteType.NationalPark) {
                for park in DataService.allNationalParks {
                let anno = park
                mapView.addAnnotation(anno)
            }
        }
        if selectedSiteTypes.contains(DataService.SiteType.NationalMonument) {
            for park in DataService.allNationalMonuments {
                let anno = park
                mapView.addAnnotation(anno)
            }
        }
    }
    
    func refreshAnnotations() {
        mapView.removeAnnotations(mapView.annotations)
        createAnnotations()
    }

}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"

        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
        } else {
            view?.annotation = annotation
        }
        
        switch annotation {
        case is NationalPark:
            view?.image = UIImage(named: "tree")
        case is NationalMonument:
            view?.image = UIImage(named: "monument")
        default:
            view?.image = nil
        }
        view?.frame.size = CGSize(width: 20.0, height: 20.0)
        
        return view
    }
}

