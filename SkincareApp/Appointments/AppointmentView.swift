//
//  AppointmentView.swift
//  SkincareApp
//
//  Created by Anna on 11/17/21.
//

import Foundation

import UIKit

class AppointmentView: UIView {
    var view: UIView!
    
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var rootStack: UIStackView!
    @IBOutlet weak var monthYearLabel: UILabel!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var dayOfWeekLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var infoStack: UIStackView!
    
    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    
    @IBOutlet weak var servicesView: UIView!
    
    required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            loadViewFromNib()
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            loadViewFromNib()
        }

        func loadViewFromNib() {
            let bundle = Bundle(for: type(of: self))
            let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
            let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
            view.frame = bounds
            view.autoresizingMask = [
                UIView.AutoresizingMask.flexibleWidth,
                UIView.AutoresizingMask.flexibleHeight
            ]
            view.layer.cornerRadius = 10
            view.layer.cornerRadius = 10
            view.layer.borderWidth = 1
            view.layer.borderColor = UIColor.lightGray.cgColor
            
            view.backgroundColor = .white

            addSubview(view)
            self.view = view
            
            monthYearLabel.text = "July 2021"
            dayLabel.text = "12"
            dayOfWeekLabel.text = "WED"
            timeLabel.text = "5:00 PM"
            
            locationNameLabel.text = "San Francisco SPA"
//            addressLabel.text = "2044 Fillmore Street, 2nd Floor, San Francisco, CA 94115"
            locationImageView.image = UIImage(named: "locationImageExample")
            


        }

}

