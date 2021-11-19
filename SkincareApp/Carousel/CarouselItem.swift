//
//  CarouselItem.swift
//  SkincareApp
//
//  Created by Anna on 10/28/21.
//

import Foundation
import Foundation
import UIKit

@IBDesignable
class CarouselItem: UIView {
    static let CAROUSEL_ITEM_NIB = "CarouselItem"
    
    @IBOutlet var vwContent: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initWithNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initWithNib()
    }
    
    convenience init(titleText: String? = "", background: UIColor? = .red,image: UIImage?, frame: CGRect) {
        self.init(frame: frame)
        initWithNib()
        lblTitle.text = titleText
        vwContent.backgroundColor = background
        imageView.image = image
    }
    
    fileprivate func initWithNib() {
        Bundle.main.loadNibNamed(CarouselItem.CAROUSEL_ITEM_NIB, owner: self, options: nil)
        vwContent.frame = bounds
        addSubview(vwContent)
    }
}
