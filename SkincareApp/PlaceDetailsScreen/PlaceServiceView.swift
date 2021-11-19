//
//  PlaceServiceView.swift
//  SkincareApp
//
//  Created by Anna on 11/11/21.
//

import Foundation
import UIKit

class PlaceServiceView: UIView {
    var view: UIView!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var descriptionLbel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    var isViewSelected = false
    
    
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
            nameLabel.text = "I'm the Label!"
            descriptionLbel.text = ""
            priceLabel.text = "$20.00"
            image.image = UIImage(named: "signatureFacial")
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            view.addGestureRecognizer(tap)
        }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        
        if isViewSelected{
            self.view.backgroundColor = .white
            isViewSelected = false
        }else{
            self.view.backgroundColor = .systemBlue
            isViewSelected = true
        }
        

        
    }
}
