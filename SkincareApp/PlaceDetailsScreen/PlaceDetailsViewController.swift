//
//  PlaceDetailsViewController.swift
//  SkincareApp
//
//  Created by Anna on 10/25/21.
//

import UIKit
import MapKit
import Cosmos

class PlaceDetailsViewController: UIViewController {
    
    var interestingPlace: InterstingPlace?

    @IBOutlet weak var bookApptButton: UIButton!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openClosedLabel: UILabel!
    @IBOutlet weak var additionalOpenCloseLabel: UILabel!
    @IBOutlet weak var priceLevelLabel: UILabel!
    @IBOutlet weak var placeCategoriesLabel: UILabel!
    @IBOutlet weak var ratingsView: UIView!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
  
    @IBOutlet weak var servicesStackView: UIStackView!
    @IBOutlet weak var placeScrollView: UIScrollView!
    
    
    var place_images = [UIImage]()
    var childVC : MyPageViewController?
    var dayOfWeek: Int = -1
    var services = ["Consultation", "Facial","Microdermabrasion","Acne Treatment",
                    "Anti-Aging Treatment", "Chemical Peel","Waxing"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        bookAppointmentButton.isHidden = true
        childVC = self.children.first as? MyPageViewController
        
//        placeScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+300)
        
        
        bookApptButton.layer.cornerRadius = 5
        bookApptButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bookApptButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        
        var detailedRequest = MyRequestController()
        
        detailedRequest.sendDetailsRequest(placeId: interestingPlace?.place_id ?? "") { results in
            let searchResults = results["result"] as? Dictionary<String, Any>
            

            if searchResults != nil{
                if ((searchResults?.keys.contains("formatted_phone_number")) != nil){
                    self.interestingPlace?.phoneNumber = searchResults?["formatted_phone_number"] as! String
                }
                if searchResults!.keys.contains("website") {
                    self.interestingPlace?.url = searchResults?["website"] as! String
                }
                
                if searchResults!.keys.contains("opening_hours") {
                    var opening_hrs_info = searchResults?["opening_hours"] as! Dictionary<String, Any>
                    if let periods_info = opening_hrs_info["perids"] as? Array<Any>{
                        
                    }
                    
                }
                
                if searchResults!.keys.contains("photos"){
                    let photos_info = searchResults?["photos"] as! Array<Dictionary<String, Any>>
                    var place_photos : [PlacePhoto] = []
                    for photo in photos_info{
                        let place_photo = PlacePhoto(height: (photo["height"] as! Int), width: photo["width"] as! Int, html_attribution: photo["html_attributions"] as? Array<String>, photo_reference: photo["photo_reference"] as? String)
                        place_photos.append(place_photo)
                    }
                    self.interestingPlace?.all_photos = place_photos
                }
                
                self.place_images = []
                var req = MyPhotosRequestController()
                let group = DispatchGroup()
                if let photos = self.interestingPlace?.all_photos {
                    for photo in photos {
                        group.enter()
                        req.sendPhotoRequest(photo_reference: photo.photo_reference ?? ""){ [self] image in
                            if let image = image {
                                self.place_images.append(image)
                            }
                            group.leave()
                        }
                    }
                }
                
            
                group.notify(queue: DispatchQueue.main){
                    if self.place_images.count == 0{
                        
                        if let defaultImage = UIImage(named: "noImage"){
                            self.place_images.append(defaultImage)
                        }
                    }
                    
                    self.childVC?.populateItems(images: self.place_images)
                }
                
                
                DispatchQueue.main.async {
                    self.phoneNumberLabel.text = self.interestingPlace?.phoneNumber
                    self.websiteLabel.text = self.interestingPlace?.url
                }
            }
        }
        
        
        
    
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("hahah")
    }
        

    
    override func viewWillAppear(_ animated: Bool) {
        self.place_images = []
        placeNameLabel.text = interestingPlace?.title
        openClosedLabel.text = (interestingPlace?.open_now ?? false ? "Open" : "Closed")
        openClosedLabel.textColor = (interestingPlace?.open_now ?? false ? UIColor.systemGreen : UIColor.systemRed)
        priceLevelLabel.text = String(repeating: "$", count: interestingPlace?.priceLevel ?? 2)
        priceLevelLabel.textColor = UIColor.orange
        placeCategoriesLabel.text = interestingPlace?.categories.joined(separator: ", ").replacingOccurrences(of: "_", with: " ")
        
        var cosmosView = CosmosView(frame: ratingsView.bounds)
        // Change the cosmos view rating
        cosmosView.rating = interestingPlace?.rating ?? 0.0

        // Change the text
        cosmosView.text = "(\(Int(interestingPlace?.user_ratings_total ?? 0)))"
        
        // Do not change rating when touched
        // Use if you need just to show the stars without getting user's input
        cosmosView.settings.updateOnTouch = false

        // Show only fully filled stars
        cosmosView.settings.fillMode = .precise
        // Other fill modes: .half, .precise

        // Change the size of the stars
        cosmosView.settings.starSize = 25

        // Set the distance between stars
        cosmosView.settings.starMargin = 4

        // Set the color of a filled star
        cosmosView.settings.filledColor = UIColor.orange

        // Set the border color of an empty star
        cosmosView.settings.emptyBorderColor = UIColor.orange

        // Set the border color of a filled star
        cosmosView.settings.filledBorderColor = UIColor.orange
        
        ratingsView.addSubview(cosmosView)

        addressLabel.text = interestingPlace?.address
        
        for service in services{
            var newLabel = UILabel.init()
            newLabel.text = service
            servicesStackView.addArrangedSubview(newLabel)
        }
        
        

        
    }
    @IBAction func mapButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func displayOpening(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE" // OR "dd-MM-yyyy"
        let currentDateString: String = dateFormatter.string(from: date)
        
        switch currentDateString {
        case "Monday":
            dayOfWeek = 0
        case "Tuesday":
            dayOfWeek = 1
        case "Wednesday":
            dayOfWeek = 2
        case "Thursday":
            dayOfWeek = 3
        case "Friday":
            dayOfWeek = 4
        case "Saturday":
            dayOfWeek = 5
        case "Sunday":
            dayOfWeek = 6
        default:
            return
        }
    }
}


class MyPhotosRequestController {
    
    func searchPlacesNearby(){
        let sessionConfig = URLSessionConfiguration.default
    }
    
    func sendPhotoRequest(photo_reference: String, _ completion: @escaping ((UIImage?)->())) {
        /* Configure session, choose between:
           * defaultSessionConfiguration
           * ephemeralSessionConfiguration
           * backgroundSessionConfigurationWithIdentifier:
         And set session-wide properties, such as: HTTPAdditionalHeaders,
         HTTPCookieAcceptPolicy, requestCachePolicy or timeoutIntervalForRequest.
         */
        var img : UIImage?
        let sessionConfig = URLSessionConfiguration.default

        /* Create session, and optionally set a URLSessionDelegate. */
        let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)

        /* Create the Request:
           Request (GET https://maps.googleapis.com/maps/api/place/photo)
         */

        guard var URL = URL(string: "https://maps.googleapis.com/maps/api/place/photo") else {return }
        let URLParams = [
            "maxwidth": "700",
            "photo_reference": photo_reference,
            "key": "AIzaSyBgEOygxuVz-_FMQT66jUSiv9WT0riD8tI",
        ]
        URL = URL.appendingQueryParameters(URLParams)
        var request = URLRequest(url: URL)
        request.httpMethod = "GET"

        /* Start a new Task */
        let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if (error == nil) {
                // Success
                img = UIImage(data: data!)
                let statusCode = (response as! HTTPURLResponse).statusCode
                print("URL Session Task Succeeded: HTTP \(statusCode)")
                completion(img)
            }
            else {
                // Failure
                print("URL Session Task Failed: %@", error!.localizedDescription);
            }
        })
        task.resume()
        session.finishTasksAndInvalidate()
    }
}






