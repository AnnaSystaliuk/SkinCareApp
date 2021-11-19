//
//  AppointmentsViewController.swift
//  SkincareApp
//
//  Created by Anna on 11/18/21.
//

import UIKit

struct AppointmentInfo {
    var dayOfWeek : String
    var monthYear: String
    var day: String
    var time: String
    var locationName: String
    var locationAddress: String
    var services: [String]
}

class AppointmentsViewController: UIViewController {
    
    var scrollView: UIScrollView = UIScrollView()
    
    var appointments = [
        AppointmentInfo(dayOfWeek: "WED", monthYear: "July, 2021", day: "23", time: "4:00 PM", locationName: "Senspa", locationAddress: " 2421 Larkspur Landing Circle, Suite 43, Larkspur", services: ["Facial", "Massage"]),
        AppointmentInfo(dayOfWeek: "TUE", monthYear: "March, 2021", day: "12", time: "1:00 PM", locationName: "INTERNATIONAL ORANGE", locationAddress: " 2421 Larkspur Landing Circle, Suite 43, Larkspur", services: ["Aromatherapy", "Hot Stone massage"])
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        addAppointmentViews()
        
    }
    
    func addAppointmentViews(){
        
        var stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis  = NSLayoutConstraint.Axis.vertical
//        stackView.distribution  = UIStackView.Distribution.fillProportionally
//        stackView.alignment = UIStackView.Alignment.center
        stackView.spacing   = 16.0
        
        for appointment in appointments{
            var appointmentView = AppointmentView()
            appointmentView.translatesAutoresizingMaskIntoConstraints = false
            appointmentView.dayOfWeekLabel.text = appointment.dayOfWeek
            appointmentView.dayLabel.text = appointment.day
            appointmentView.monthYearLabel.text = appointment.monthYear
            appointmentView.timeLabel.text = appointment.time
            appointmentView.locationNameLabel.text = appointment.locationName
//            appointmentView.addressLabel.text = appointment.locationAddress
            
            var servicesStack = UIStackView()
            servicesStack.translatesAutoresizingMaskIntoConstraints = false
            servicesStack.axis = NSLayoutConstraint.Axis.vertical
            servicesStack.distribution  = UIStackView.Distribution.fillEqually
            servicesStack.alignment = UIStackView.Alignment.leading
            servicesStack.spacing   = 5
            
            for service in appointment.services{
                var serviceLabel = UILabel()
                serviceLabel.translatesAutoresizingMaskIntoConstraints = false
                serviceLabel.numberOfLines = 0
                serviceLabel.text = service
                servicesStack.addArrangedSubview(serviceLabel)
            }
            
//            appointmentView.servicesView.translatesAutoresizingMaskIntoConstraints = false
            
            appointmentView.servicesView.addSubview(servicesStack)
            servicesStack.topAnchor.constraint(equalTo: appointmentView.servicesView.topAnchor).isActive = true
            servicesStack.bottomAnchor.constraint(equalTo: appointmentView.servicesView.bottomAnchor).isActive = true
            servicesStack.rightAnchor.constraint(equalTo: appointmentView.servicesView.rightAnchor).isActive = true
            servicesStack.leftAnchor.constraint(equalTo: appointmentView.servicesView.leftAnchor).isActive = true
            appointmentView.servicesView.heightAnchor.constraint(equalTo: servicesStack.heightAnchor).isActive = true
            
            stackView.addArrangedSubview(appointmentView)
        }
        
        
        
        

        scrollView.addSubview(stackView)
        
//
//        stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
//        stackView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
//        stackView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        
//        scrollView.contentSize.equalTo(stackView.intrinsicContentSize)
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
    
    
}
