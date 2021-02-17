//
//  MapViewController.swift
//  Mentalist
//
//  Created by Juliette Bois on 16.02.21.
//

import UIKit
import MapKit

class MapViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var myCollection: UICollectionView!
    private let locationManager = LocationManager()
    
    var cellList:[String] = []
    
    @IBOutlet weak var myMap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myCollection.delegate = self
        myCollection.dataSource = self
        myCollection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "label")
    }
    
    @IBAction func readClicked(_ sender: Any) {
        BLEManager.instance.listenForMessages(UUID: "9DE0451B-4F87-4677-9FC4-2C81BDF27822", callback: { [self] (data) in
            if let deballe = data {
                let str = String(data: deballe, encoding: .utf8)!
                print(str)
                cellList.append(str)
                myCollection.reloadData()
                
                self.locationManager.getLocation(forPlaceCalled: str) { location in
                    guard let location = location else { return }
                    
        
                    
                    let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
                    self.myMap.setRegion(region, animated: true)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = center
                    self.myMap.addAnnotation(annotation)
                }
            }
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       return CGSize(width: 200, height: 200)
    }
  
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "label",for: indexPath)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        title.text = cellList[indexPath.row]
        title.font = UIFont(name: "AvenirNext-Bold", size: 15)
        title.textAlignment = .center
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        cell.contentView.addSubview(title)
        cell.layer.borderWidth=0.5
        cell.layer.cornerRadius = 8
        cell.layer.borderColor = UIColor.gray.cgColor

        return cell
    }
}
