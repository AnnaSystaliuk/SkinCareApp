//
//  BookAppointmentViewController.swift
//  SkincareApp
//
//  Created by Anna on 11/13/21.
//

import UIKit

class BookAppointmentViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    
    var services = [
        Service(image: UIImage(named: "faceMassage")!, name: "Face Massage", description: "Facial massage helps promote healthy skin while relaxing your facial muscles. It has a relaxing and rejuvenating effect, helping you look and feel better.", price: "$120"),
        Service(image: UIImage(named: "signatureFacial")!, name: "Signature Facial", description: "Designed to increase the skin’s moisture levels, hydrating facials are an ideal winter skin treat. Nourishing, collagen-infused lotions are often used to rid the skin of dry and flaky patches, and to ‘plump’ the skin for a youthful appearance.", price: "$150"),
        Service(image: UIImage(named: "microdermabrasion")!, name: "Microdermabrasion", description: "Typically offered by medical spas, resurfacing facials utilise laser therapy, and/or a chemical peel and microdermabrasion to rid the skin of dead cells to the greatest possible degree to reduce the appearance of wrinkles and skin irregularities, such as discolouration and acne scars. ", price: "$140"),
        Service(image: UIImage(named: "facePeel")!, name: "Face Peel", description: "This term is used to describe a variety of facials designed to remove one or more layers of the skin to reveal a brighter complexion with less blemishes. The chemical peels offered at medical spas are the most obvious example, but an increasing number of peel facials featuring natural ingredients are becoming available. Learn more about peel facials", price: "$130"),
        Service(image: UIImage(named: "antiAge")!, name: "Anti-Aging Treatment", description: "Designed to reduce the appearance of wrinkles and fine lines, firming facials often see tightening skin gels used. Painless, anti-ageing electrotherapy is also becoming more common within this category of facial. ", price: "$160"),
        Service(image: UIImage(named: "bodyMassage")!, name: "Body Massage", description: "A body massage involves working and applying pressure on the muscles of the body, on the skin surface. ", price: "$200"),
        Service(image: UIImage(named: "hotStones")!, name: "Hot Stone Massage", description: "A hot stone massage is a type of massage therapy. It's used to help you relax and ease tense muscles and damaged soft tissues throughout your body. During a hot stone massage, smooth, flat, heated stones are placed on specific parts of your body.", price: "$220"),
        Service(image: UIImage(named: "bodyScrub")!, name: "Body Scrub", description: "A body scrub massage is a type of massage where a body scrub is used on the skin instead of regular massage oil.", price: "$230"),
        Service(image: UIImage(named: "aromatherapy")!, name: "Aromatherapy Session", description: "Aromatherapy is a specific type of therapy that incorporates the use of scented essential oils into a massage.", price: "$200"),
    ]
    
    var serviceViews: [PlaceServiceView] = []
    var selectedServices: [PlaceServiceView] = []
    var selectedDay = 0
    var selectedDate = Date()
    var selectedTime = ""
    
    //set for 4 days
    var times = [
        ["7:30 pm"],
        ["9:00 am","12:00pm", "3:00 pm", "4:15 pm"],
        ["10:00 am","10:15 am", "11:00 am", "11:45 am", "1:00 pm", "2:15 pm"],
        ["11:40 am","11:55 am",  "1:00 pm", "2:15 pm","3:00 pm", "3:15pm" ],
        ["9:00 am","9:45 am","10:00 am","10:30 am", "11:10 am","11:55 am",  "1:00 pm", "2:15 pm","3:00 pm", "3:15pm" ]
        
    ]
    lazy var layout = UICollectionViewFlowLayout()
    lazy var timesCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addServiceViews()
        layout.scrollDirection = .horizontal
        
    }
    
    func addServiceViews(){
        //StackView
        var stackView = UIStackView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis  = NSLayoutConstraint.Axis.vertical
        stackView.distribution  = UIStackView.Distribution.equalSpacing
        stackView.alignment = UIStackView.Alignment.leading
        stackView.spacing   = 16.0
        
        var selectService = UILabel()
        selectService.text = "Select service(s):"
        selectService.font = UIFont.boldSystemFont(ofSize: 20)
        selectService.textAlignment = .left
        stackView.addArrangedSubview(selectService)
        
        var indx = 0
        for service in services{
            
            var serviceView = PlaceServiceView()

            serviceView.nameLabel.text = service.name
            serviceView.descriptionLbel.text = service.description
            serviceView.priceLabel.text = service.price
            serviceView.image.image = service.image
            serviceViews.append(serviceView)
            
            stackView.addArrangedSubview(serviceView)
            serviceView.rightAnchor.constraint(equalTo: stackView.rightAnchor,constant: -10).isActive = true
            serviceView.leftAnchor.constraint(equalTo: stackView.leftAnchor,constant: 10).isActive = true
            serviceView.tag = indx

            indx = indx + 1

        }
        
        var dateLabel = UILabel()
        dateLabel.text = "Select day:"
        dateLabel.font = UIFont.boldSystemFont(ofSize: 20)
        stackView.addArrangedSubview(dateLabel)
        
        var datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.maximumDate = Date().addingTimeInterval(TimeInterval.init(300000))
        datePicker.heightAnchor.constraint(equalToConstant: 60).isActive = true
        datePicker.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
        stackView.addArrangedSubview(datePicker)
        
        scrollView.addSubview(stackView)
        
        var timeLabel = UILabel()
        timeLabel.text = "Availabile times:"
        timeLabel.font = UIFont.boldSystemFont(ofSize: 20)
        stackView.addArrangedSubview(timeLabel)
        
        stackView.addArrangedSubview(timesCollectionView)
        
        timesCollectionView.delegate   = self
        timesCollectionView.dataSource = self
        timesCollectionView.translatesAutoresizingMaskIntoConstraints = false
        timesCollectionView.backgroundColor = .white
        timesCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "timeCellIdentifier")
        
        var buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        var bookButton = UIButton()
        
        bookButton.setTitle("Book", for: .normal)
        bookButton.backgroundColor = .systemBlue
        bookButton.translatesAutoresizingMaskIntoConstraints = false
        bookButton.addTarget(self, action: #selector(bookAction), for: .touchUpInside)
        bookButton.tag = 1
        buttonView.addSubview(bookButton)
        stackView.addArrangedSubview(buttonView)
        
        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        
        timesCollectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        timesCollectionView.widthAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
        timesCollectionView.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 0).isActive = true
        timesCollectionView.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: 0).isActive = true
        
        buttonView.heightAnchor.constraint(equalToConstant: 65).isActive = true
        buttonView.leftAnchor.constraint(equalTo: stackView.leftAnchor).isActive = true
        buttonView.rightAnchor.constraint(equalTo: stackView.rightAnchor).isActive = true
        
        bookButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        bookButton.widthAnchor.constraint(equalTo: buttonView.widthAnchor, multiplier: 0.7).isActive = true
        bookButton.centerXAnchor.constraint(equalTo: buttonView.centerXAnchor).isActive = true
        bookButton.layer.cornerRadius = 5
        bookButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        scrollView.contentSize.equalTo(stackView.intrinsicContentSize)
        scrollView.contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 20, right: 0)
        
        
        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide
        NSLayoutConstraint.activate([
          frameGuide.leadingAnchor.constraint(equalTo: view.leadingAnchor),
          frameGuide.topAnchor.constraint(equalTo: view.topAnchor),
          frameGuide.trailingAnchor.constraint(equalTo: view.trailingAnchor),
          frameGuide.bottomAnchor.constraint(equalTo: view.bottomAnchor),
          contentGuide.leadingAnchor.constraint(equalTo: stackView.leadingAnchor),
          contentGuide.topAnchor.constraint(equalTo: stackView.topAnchor),
          contentGuide.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
          contentGuide.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
        contentGuide.widthAnchor.constraint(equalTo: frameGuide.widthAnchor)
            ])

    }
    
    @objc func dateSelected(sender: UIDatePicker!) {
        selectedDay = sender.date.interval(ofComponent: .day, fromDate: Date())
        selectedDate = sender.date
        timesCollectionView.reloadData()
    }
    
    
    @objc func bookAction(sender: UIButton!) {

        UIView.animate(withDuration: 0.33, delay: 0.0, options: [.autoreverse, .beginFromCurrentState, .overrideInheritedDuration, .preferredFramesPerSecond60]) {
            sender.transform = CGAffineTransform.init(scaleX: 0.95, y: 0.95)
        } completion: { _ in
            sender.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
 
        selectedServices = serviceViews.filter { service in
            return service.isViewSelected == true
        }
        var message = ""
        var title = ""
        if selectedServices.isEmpty || selectedTime == "" {
            title = "Appointment not booked"
            message = "Please select service(s) and time!"
        } else{
            title = "Appointment booked"
            message = "Service(s): \n"
            for service in selectedServices{
                message.append(service.nameLabel.text! + "\n")
            }
            message = message + "Date & Time: \n"
            message = message + selectedDate.description.prefix(10) + " " + selectedTime
        }
        
        
            let btnsendtag: UIButton = sender
            if btnsendtag.tag == 1 {

                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: { [weak alert] (_) in
                    alert?.dismiss(animated: true, completion: nil)
                    
                    if title == "Appointment booked"{
                        self.navigationController?.popToRootViewController(animated: true)
                    }
            
                })
                alert.addAction(cancelAction)
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
}

extension BookAppointmentViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if selectedDay == -1 {
            return 0
        } else {
            return times[selectedDay].count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = timesCollectionView.dequeueReusableCell(withReuseIdentifier: "timeCellIdentifier", for: indexPath)
        cell.backgroundColor = .blue
        
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
        content.text = times[selectedDay][indexPath.row]
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
        selectedTime = times[selectedDay][indexPath.row]
    }
 
}

extension BookAppointmentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 45)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}

extension Date {

    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}
