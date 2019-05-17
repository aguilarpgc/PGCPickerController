//
//  FirstViewController.swift
//  TestPickerController
//
//  Created by Paul Aguilar on 10/12/18.
//  Copyright © 2018 Paul Aguilar. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    // MARK: - Outlets -
    
    @IBOutlet weak var labelSelection: UILabel!
    
    // MARK: - Properties -
    
    private var source = FirstPickerSource(currentIndexSelected: nil)
    
    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    // MARK: - IBActions -
    
    @IBAction func actionChoose(_ sender: Any) {
        
        let controller = PGCPickerViewController.with(pickerOption: source) { [weak self] (selection) in
            
            self?.source.currentIndexSelected = selection
            self?.select(index: selection)
        }
        
        self.present(controller, animated: false, completion: nil)
    }
    
    // MARK: - Methods -
    
    private func select(index: Int) {
        update()
    }
    
    private func update() {
        
        guard let currentIndex = source.currentIndexSelected else {
            return
        }
        
        labelSelection.text = source.items[currentIndex]
    }
}

struct FirstPickerSource: PickerSingleOption {
    
    let items = ["Audi", "BMW", "Chevrolet", "Ford", "Honda", "Hyundai", "Jeep", "KIA", "Mazda", "Mitsubishi", "Nissan", "Peugeot", "Renault", "Subaru", "Suzuki", "Toyota", "Volkswagen", "Volvo"]
    
    // MARK: - Protocol PickerOptions
    
    var currentIndexSelected: Int?
    
    func numberOfRows() -> Int {
        return self.items.count
    }
    
    func title(forRow row: Int) -> String {
        return self.items[row]
    }
}

