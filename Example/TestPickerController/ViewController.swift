//
//  ViewController.swift
//  TestPickerController
//
//  Created by Paul Aguilar on 10/12/18.
//  Copyright © 2018 Paul Aguilar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var labelSelection: UILabel!
    
    // MARK: - Properties -
    private var source = ItemsSource(currentIndexSelected: nil)
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    // MARK: - IBActions -
    
    @IBAction func actionChoose(_ sender: Any) {
        
        let controller = PGCPickerViewController.presentFrom(pickerOptions: source) { [weak self] (selections) in
            
            self?.select(atIndex: selections[0])
        }
        
        self.present(controller, animated: false, completion: nil)
    }
    
    // MARK: - Methods -
    
    private func select(atIndex index: Int) {
        
        source.currentIndexSelected = [index]
        
        update()
    }
    
    private func update() {
        
        guard let currentIndex = source.currentIndexSelected?.first else {
            return
        }
        
        labelSelection.text = source.items[currentIndex]
    }
}

struct ItemsSource: PickerOptions {
    
    let items = ["Audi", "BMW", "Chevrolet", "Ford", "Honda", "Hyundai", "Jeep", "KIA", "Mazda", "Mitsubishi", "Nissan", "Peugeot", "Renault", "Subaru", "Suzuki", "Toyota", "Volkswagen", "Volvo"]
    
    // MARK: - Protocol PickerOptions
    
    var currentIndexSelected: [Int]?
    
    var numberOfComponents: Int {
        
        return 1
    }
    
    func numberOfRows(atComponent: Int) -> Int {
        
        return self.items.count
    }
    
    func title(forRow row: Int, atComponent component: Int) -> String {
        
        return self.items[row]
    }
}

