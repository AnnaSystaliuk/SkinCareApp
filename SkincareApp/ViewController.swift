//
//  ViewController.swift
//  SkincareApp
//
//  Created by Anna on 10/19/21.
//

import UIKit
import CoreData
import SwiftUI

class SkinCareTableViewCell: UITableViewCell {
    @IBOutlet weak var weekdayLabel: UILabel!

    @IBOutlet weak var morningCleanserLabel: UILabel!
    @IBOutlet weak var morningTonerLabel: UILabel!
    @IBOutlet weak var morningTreatmentLabel: UILabel!
    @IBOutlet weak var morningMoisturizerLabel: UILabel!
    @IBOutlet weak var sunscreenLabel: UILabel!
    @IBOutlet weak var nightCleanserLabel: UILabel!
    @IBOutlet weak var nightExfoilatorLabel: UILabel!
    @IBOutlet weak var nightTonerLabel: UILabel!
    @IBOutlet weak var nightTreatmentLabel: UILabel!
    @IBOutlet weak var nightMoisturizerLabel: UILabel!
    
    
    @IBOutlet weak var morningCleanserStackView: UIStackView!
    @IBOutlet weak var morningTonerStackView: UIStackView!
    @IBOutlet weak var morningTreatmentStackView: UIStackView!
    @IBOutlet weak var morningMoisturizerStackView: UIStackView!
    @IBOutlet weak var sunscreenStackView: UIStackView!
    @IBOutlet weak var rootView: UIStackView!
    
    weak var table: UITableView!
    
    
    @IBAction func productInfoPressed(_ sender: UIButton) {
        
        //1. Create the alert controller.
        
        let alert = UIAlertController(title: "New Product", message: "Please enter information: ", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "Product name"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            
            
            var day = Weekday.Monday
            switch self.weekdayLabel.text {
            case "Monday":
                day = Weekday.Monday
            case "Tuesday":
                day = Weekday.Tuesday
            case "Wednesday":
                day = Weekday.Wednesday
            case "Thursday":
                day = Weekday.Thursday
            case "Friday":
                day = Weekday.Friday
            case "Saturday":
                day = Weekday.Saturday
            case "Sunday":
                day = Weekday.Sunday
            default:
                break
            }
            
            var product = ProductType.Cleanser
            var time = ProductTime.Day
            
            switch sender.tag {
            case 0:
                product = ProductType.Cleanser
                time = ProductTime.Day
            case 1:
                product = ProductType.Toner
                time = ProductTime.Day
            case 2:
                product = ProductType.Treatment
                time = ProductTime.Day
            case 3:
                product = ProductType.Moisturizer
                time = ProductTime.Day
            case 4:
                product = ProductType.Sunscreen
                time = ProductTime.Day
            case 5:
                product = ProductType.Cleanser
                time = ProductTime.Night
            case 6:
                product = ProductType.Toner
                time = ProductTime.Night
            case 7:
                product = ProductType.Treatment
                time = ProductTime.Night
            case 8:
                product = ProductType.Moisturizer
                time = ProductTime.Night
            case 9:
                product = ProductType.Exfoliator
                time = ProductTime.Night
            default:
                break
            }
            
            Task.createTask(with: day, product: product, time: time, name: textField.text ?? "no name")
            
            self.table.reloadData()
        }))

        // 4. Present the alert.
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        
    }
    
    @objc func viewPressed(sender: UITapGestureRecognizer) {
        
        
    }
    
}

class ViewController: UIViewController {
    @IBOutlet weak var skincareTableView: UITableView!
    
    let daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var tasks: [Task] {Task.fetchData()}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        skincareTableView.delegate = self
        skincareTableView.dataSource = self
        }
  
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "skincareTableViewCell",for: indexPath) as! SkinCareTableViewCell
        cell.weekdayLabel.text = daysOfWeek[indexPath.row]
        
        let morningCleanser = tasks.filter { task in
            
            return task.weekday == Weekday.init(rawValue: Int16(indexPath.row)) && task.product == ProductType.Cleanser && task.productTime == ProductTime.Day
        }
        let morningToner = tasks.filter { task in
            
            return task.weekday == Weekday.init(rawValue: Int16(indexPath.row)) && task.product == ProductType.Toner && task.productTime == ProductTime.Day
        }
        let morningTreatment = tasks.filter { task in
            
            return task.weekday == Weekday.init(rawValue: Int16(indexPath.row)) && task.product == ProductType.Treatment && task.productTime == ProductTime.Day
        }
        let morningMoisturizer = tasks.filter { task in
            
            return task.weekday == Weekday.init(rawValue: Int16(indexPath.row)) && task.product == ProductType.Moisturizer && task.productTime == ProductTime.Day
        }
        let sunscreen = tasks.filter { task in
            
            return task.weekday == Weekday.init(rawValue: Int16(indexPath.row)) && task.product == ProductType.Sunscreen && task.productTime == ProductTime.Day
        }
        
        let nightCleanser = tasks.filter { task in
            
            return task.weekday == Weekday.init(rawValue: Int16(indexPath.row)) && task.product == ProductType.Cleanser && task.productTime == ProductTime.Night
        }
        let nightExfoliator = tasks.filter { task in
            
            return task.weekday == Weekday.init(rawValue: Int16(indexPath.row)) && task.product == ProductType.Exfoliator && task.productTime == ProductTime.Night
        }
        let nightToner = tasks.filter { task in
            
            return task.weekday == Weekday.init(rawValue: Int16(indexPath.row)) && task.product == ProductType.Toner && task.productTime == ProductTime.Night
        }
        let nightTreatment = tasks.filter { task in
            
            return task.weekday == Weekday.init(rawValue: Int16(indexPath.row)) && task.product == ProductType.Treatment && task.productTime == ProductTime.Night
        }
        let nightMoisturizer = tasks.filter { task in
            
            return task.weekday == Weekday.init(rawValue: Int16(indexPath.row)) && task.product == ProductType.Moisturizer && task.productTime == ProductTime.Night
        }
        
        
        cell.morningCleanserLabel.text = morningCleanser.last?.name
        cell.morningTonerLabel.text = morningToner.last?.name
        cell.morningTreatmentLabel.text = morningTreatment.last?.name
        cell.morningMoisturizerLabel.text = morningMoisturizer.last?.name
        cell.sunscreenLabel.text = sunscreen.last?.name
        cell.nightCleanserLabel.text =
            nightCleanser.last?.name
        cell.nightExfoilatorLabel.text = nightExfoliator.last?.name
        cell.nightTonerLabel.text = nightToner.last?.name
        cell.nightTreatmentLabel.text = nightTreatment.last?.name
        cell.nightMoisturizerLabel.text = nightMoisturizer.last?.name
        
        cell.table = tableView

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
    
    
}
