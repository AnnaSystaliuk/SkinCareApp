//
//  MapViewViewController.swift
//  SkincareApp
//
//  Created by Anna on 10/22/21.
//

import UIKit
import MapKit
import Cosmos

class InterstingPlace: NSObject, MKAnnotation {

    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var title: String? = "Place Title"
    var address: String? = "unknown"
    var photos: Array<PlacePhoto>?
    var all_photos: Array<PlacePhoto>?
    var rating: Double = 0.0
    var user_ratings_total: Int = 0
    var open_now: Bool = false
//    var opening_hours : Array<Any> = Dictionary<Any>()
    var priceLevel: Int = 2
    var categories: [String] = []
    var place_id: String = ""
    var phoneNumber: String = ""
    var url: String = ""
    
    init(latitude: Double = 0.0, longitude: Double = 0.0, title: String? = nil,address: String? = nil,photos: Array<PlacePhoto>? = nil, open_now: Bool = false, priceLevel: Int = 1, categories: [String] = [], place_id : String = "", phoneNumber: String = "", url: String = "") {
        self.latitude   = latitude
        self.longitude = longitude
        self.title = title
        self.address = address
        self.photos = photos
        self.open_now = open_now
        self.priceLevel = priceLevel
        self.categories = categories
        self.place_id = place_id
        self.phoneNumber = phoneNumber
        self.url = url
    }
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

class PlacePhoto: NSObject {
    var height: Int?
    var width: Int?
    var html_attribution: Array<String>?
    var photo_reference: String?
    init(height: Int? = nil, width: Int? = nil, html_attribution: Array<String>? = nil, photo_reference: String? = nil){
        self.height = height
        self.width = width
        self.html_attribution = html_attribution
        self.photo_reference = photo_reference
    }
    
}

class FilterCollectionViewCell: UICollectionViewCell {
    
}


class MapViewViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    var places = [MKMapItem]()
    var locationManager: CLLocationManager?
    var previousLocation: CLLocation?
    var region = MKCoordinateRegion(center: CLLocation(latitude: 37.334722, longitude: -122.008889).coordinate, latitudinalMeters: 10000.0, longitudinalMeters: 10000.0)
    
    var myDatePicker:UIDatePicker = UIDatePicker()
    
    var selectedInterestingPlace : InterstingPlace?
    var filters = ["spa", "health", "beauty salon", "doctor", "store", "establishment"]
    var selectedFiltersIndx = Set<Int>()
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        searchBar.delegate = self

        mapView.delegate = self
        
        filterCollectionView.delegate = self
        filterCollectionView.dataSource = self
        filterCollectionView.isScrollEnabled = true
        filterCollectionView.showsHorizontalScrollIndicator = true
        filterCollectionView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        filterCollectionView.allowsMultipleSelection = true
        
    }
    
    private func activateLocationServices() {
        locationManager?.requestLocation()
    }
}
extension MapViewViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            activateLocationServices()
        } else {
            locationManager?.requestLocation()
            locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if previousLocation == nil {
            previousLocation = locations.first
            
            region = MKCoordinateRegion(center: previousLocation?.coordinate ?? CLLocation(latitude: 37.334722, longitude: -122.008889).coordinate, latitudinalMeters: 10000.0, longitudinalMeters: 10000.0)
            mapView.setRegion(region, animated: true)
            
        } else {
            guard let latest = locations.first else {return}
            let distanceInMeters = previousLocation?.distance(from: latest) ?? 0
//            print("distance in meters: \(distanceInMeters)")
            previousLocation = latest
            region = MKCoordinateRegion(center: previousLocation?.coordinate ?? CLLocation(latitude: 37.334722, longitude: -122.008889).coordinate, latitudinalMeters: 10000.0, longitudinalMeters: 10000.0)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed fetching location")
    }
}

extension MapViewViewController: MKMapViewDelegate{
    //when we want to know when app will start rendering
//    func mapViewWillStartRenderingMap(_ mapView: MKMapView) {
//        print("rendering...")
//    }
//
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "InterestingPlace") as? MKMarkerAnnotationView
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "InterestingPlace")
        } else {
            annotationView?.annotation = annotation
        }
        
        annotationView?.markerTintColor = UIColor(red: 0.08, green: 0.5, blue: 0.2, alpha: 1)
        return annotationView
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let annotationSubtitle = view.annotation?.subtitle
        let interestingPlace = view.annotation as? InterstingPlace
        self.selectedInterestingPlace = interestingPlace
        var place_images = [UIImage]()
        
        var req = MyPhotosRequestController()
        let group = DispatchGroup()
        if let photos = interestingPlace?.photos {
            for photo in photos {
                group.enter()
                req.sendPhotoRequest(photo_reference: photo.photo_reference ?? ""){ [self] image in
                    if let image = image {
                        place_images.append(image)
                    }
                    group.leave()
                }
            }
        }
        
     
        
        group.notify(queue: DispatchQueue.main){
            
            if place_images.count == 0{
                
                if let defaultImage = UIImage(named: "noImage"){
                    place_images.append(defaultImage)
                }
            }
            
            if let annotationTitle = view.annotation?.title
            {
                print("User tapped on annotation with title: \(annotationTitle!)")
                
                let alert = UIAlertController(title: annotationTitle!, message: interestingPlace?.address, preferredStyle: .alert)

                var addressLabel = UILabel()
                addressLabel.translatesAutoresizingMaskIntoConstraints = false
                addressLabel.text = interestingPlace?.address ?? ""
                addressLabel.numberOfLines = 3
                addressLabel.textAlignment = .center
    //            addressLabel.backgroundColor = .green
                addressLabel.setContentHuggingPriority(UILayoutPriority.required, for: .vertical)
                
                var cosmosView = CosmosView()
                // Change the cosmos view rating
                cosmosView.rating = interestingPlace?.rating ?? 0.0

                // Change the text
                cosmosView.text = "(\(Int(interestingPlace?.user_ratings_total ?? 0)))"
                
                cosmosView.settings.textColor = .yellow
                cosmosView.settings.emptyBorderWidth = 1.5
                
                
                // Do not change rating when touched
                // Use if you need just to show the stars without getting user's input
                cosmosView.settings.updateOnTouch = false

                // Show only fully filled stars
                cosmosView.settings.fillMode = .precise
                // Other fill modes: .half, .precise

                // Change the size of the stars
                cosmosView.settings.starSize = 20

                // Set the distance between stars
                cosmosView.settings.starMargin = 4

                // Set the color of a filled star
                cosmosView.settings.filledColor = UIColor.yellow.withAlphaComponent(0.85)

                // Set the border color of an empty star
                cosmosView.settings.emptyBorderColor = UIColor.yellow

                // Set the border color of a filled star
                cosmosView.settings.filledBorderColor = UIColor.yellow
                
                cosmosView.translatesAutoresizingMaskIntoConstraints = false
                
                
                var stackView: UIStackView = {
                    let stack = UIStackView()
                    stack.axis = .vertical
                    stack.spacing = 10.0
                    stack.alignment = .center
                    stack.translatesAutoresizingMaskIntoConstraints = false
                    stack.distribution = .equalCentering
                    
                    [ ].forEach { stack.addArrangedSubview($0) }
                    return stack
                }()
                
                var placeImage = UIImageView(image: place_images.first)
                placeImage.contentMode = .scaleAspectFill
                placeImage.clipsToBounds = true
                placeImage.translatesAutoresizingMaskIntoConstraints = false
                
                var overlayImage = UIImageView(image: UIImage(named: "blackGradient"))
                overlayImage.contentMode = .bottom
                overlayImage.clipsToBounds = true
                
                overlayImage.alpha = 0.6
                
                
                var horizontalStackView: UIStackView = {
                    let stack = UIStackView()
                    stack.axis = .horizontal
                    stack.spacing = 10.0
                    stack.alignment = .center
                    stack.translatesAutoresizingMaskIntoConstraints = false
                    stack.distribution = .fill
                    
                    [placeImage].forEach { stack.addArrangedSubview($0) }
                    return stack
                }()
                
                overlayImage.frame = .init(origin: .init(x: 0, y: 0), size: .init(width: 270, height: 100.0))

                horizontalStackView.addSubview(overlayImage)
                horizontalStackView.addSubview(cosmosView)

                alert.view.addSubview(horizontalStackView)
                
                NSLayoutConstraint.activate(
                    [
                        horizontalStackView.topAnchor.constraint(equalTo: alert.view.topAnchor
                                                       , constant: 83),
                        horizontalStackView.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
                        horizontalStackView.bottomAnchor.constraint(equalTo: alert.view.bottomAnchor, constant: 100),
                        horizontalStackView.heightAnchor.constraint(equalToConstant: 100),
                        horizontalStackView.widthAnchor.constraint(equalToConstant: 270),

                        cosmosView.bottomAnchor.constraint(equalTo: overlayImage.bottomAnchor, constant: -10),
                        cosmosView.leftAnchor.constraint(equalTo: horizontalStackView.leftAnchor, constant: 10),
                        alert.view.heightAnchor.constraint(equalTo: horizontalStackView.heightAnchor, multiplier: 1.0, constant: 135),
                    ])
                
                let selectAction = UIAlertAction(title: "Details", style: .default, handler: { [weak alert] (_) in
                    self.performSegue(withIdentifier: "openDetailsScreen", sender: nil)
                    view.setSelected(false, animated: true)
                    
                    })
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak alert] (_) in
                    view.setSelected(false, animated: true)
            
                })
                alert.addAction(selectAction)
                alert.addAction(cancelAction)
                
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                
            }
            
            
        }
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "openDetailsScreen") {
            let vc = segue.destination as! PlaceDetailsViewController
            vc.interestingPlace = self.selectedInterestingPlace
        }
    }
}

extension MapViewViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        var filterStrings : [String] = []
        for filterIndx in selectedFiltersIndx{
            filterStrings.append(filters[filterIndx])
        }
        var filtersString = filterStrings.joined(separator: ",")
        
        
        // NEW SEARCH LOGIC
        var newRequest = MyRequestController()
        newRequest.sendRequest(lat: "\(previousLocation!.coordinate.latitude)", long: "\(previousLocation!.coordinate.longitude)", keyword: searchBar.text ?? "", filters: filtersString) { results in
            let searchResults = results["results"] as? Array<Dictionary<String, Any>>
            

            if searchResults != nil{
                for item in searchResults! {
                    var place = InterstingPlace()
                    
                    if item.keys.contains("name"){
                        place.title = item["name"] as! String
                    }
                    
                    place.latitude = ((item["geometry"] as! Dictionary<String, Any>)["location"] as! Dictionary<String, Any>)["lat"] as! Double
                    
                    place.longitude = ((item["geometry"] as! Dictionary<String, Any>)["location"] as! Dictionary<String, Any>)["lng"] as! Double
                    
                    
                    if item.keys.contains("vicinity"){
                        place.address = item["vicinity"] as! String
                    }
                    if item.keys.contains("user_ratings_total"){
                        place.user_ratings_total = item["user_ratings_total"] as! Int
                    }
                    if item.keys.contains("rating"){
                        place.rating = item["rating"] as! Double
                    }
                    if item.keys.contains("opening_hours"){
                        let opening_hours = item["opening_hours"] as! Dictionary<String, Any>
                        if let openNow = opening_hours["open_now"]{
                            place.open_now = opening_hours["open_now"] as! Bool
                        }
                        
                    }
                    if item.keys.contains("price_level"){
                        place.priceLevel = item["price_level"] as! Int
                    }
                    if item.keys.contains("types"){
                        var types = item["types"] as! Array<String>
                        for type in types{
                            place.categories.append(type)
                        }
                    }
                    
                    if item.keys.contains("place_id"){
                        place.place_id = item["place_id"] as! String
                    }
                    
                    if item.keys.contains("photos"){
                        let photos_info = item["photos"] as! Array<Dictionary<String, Any>>
                        var place_photos : [PlacePhoto] = []
                        for photo in photos_info{
                            let place_photo = PlacePhoto(height: (photo["height"] as! Int), width: photo["width"] as! Int, html_attribution: photo["html_attributions"] as? Array<String>, photo_reference: photo["photo_reference"] as? String)
                            place_photos.append(place_photo)
                        }
                        place.photos = place_photos
                    }
                    self.mapView.addAnnotation(place)
                }
                
                DispatchQueue.main.async {
                    self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                }
            }
        }

    }
}

extension MapViewViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
              withReuseIdentifier: "filterCollectionViewCell",
              for: indexPath) as! FilterCollectionViewCell
        
        
        var background = UIBackgroundConfiguration.listPlainCell()
        background.backgroundColorTransformer = UIConfigurationColorTransformer { [weak cell] c in
            if let state = cell?.configurationState {
                if state.isSelected || state.isHighlighted {
                    return .blue
                }
            }
            return .white
        }
        background.cornerRadius = 10
       
        var content = UIListContentConfiguration.sidebarCell()
        content.text = filters[indexPath.row]
        content.textProperties.colorTransformer  = UIConfigurationColorTransformer{ [weak cell] c in
            if let state = cell?.configurationState {
                if state.isSelected || state.isHighlighted {
                    return .white
                }
            }
            return .systemBlue
        }

        cell.contentConfiguration = content
        cell.backgroundConfiguration = background
        
        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.lightGray.cgColor.copy(alpha: 0.3)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedFiltersIndx.insert(indexPath.row)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.selectedFiltersIndx.remove(indexPath.row)
    }
}

extension MapViewViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // dataArary is the managing array for your UICollectionView.
//        let item = filterCollectionView.cellForItem(at: indexPath) as! FilterCollectionViewCell
        let item = filters[indexPath.row]
        var itemSize = item.size(withAttributes: [
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)
        ])
        itemSize.height = 30
        return itemSize
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        var inset = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        return inset
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    
}
