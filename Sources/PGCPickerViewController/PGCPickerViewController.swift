//
//  PGCPickerViewController.swift
//  
//
//  Created by Paul Aguilar on 10/13/18.
//

import UIKit

public protocol PickerOptions {
    
    // MARK: - Properties -
    
    var previousSelections: [Int]? { set get }
    var numberOfComponents: Int { get }
    
    // MARK: - Methods -
    
    func numberOfRows(atComponent: Int) -> Int
    func title(forRow row: Int, atComponent component: Int) -> String
    
}

class PGCPickerViewController: UIViewController {

    // MARK: - IBOutlets -
    
    @IBOutlet private weak var constraintPickerTop: NSLayoutConstraint!
    @IBOutlet private weak var viewFadeBackground: UIView!
    @IBOutlet private weak var viewPickerContainer: UIView!
    @IBOutlet private weak var pickerView: UIPickerView!

    // MARK: - Properties -
    
    public var pickerOptions: PickerOptions?
    public var selectionHandler: ((_ selections: [Int]) -> Void)? = nil
    
    private let animationDuration = 0.4

    // MARK: - Life cycle -
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        
        setupPickerValues()
        showPickerContainer()
    }

    // MARK: - Actions -
    
    @IBAction func actionTapFadeBackground(_ sender: Any) {
        
        setNewValues(selections: pickerValuesSelected())
        hidePickerController()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        
        setDefaultValues()
        hidePickerController()
    }
    
    @IBAction func actionDone(_ sender: Any) {
        
        setNewValues(selections: pickerValuesSelected())
        hidePickerController()
    }
    
    // MARK: - Methods -
    
    public static func presentFrom(pickerOptions: PickerOptions, selectionHandler: @escaping ([Int]) -> Void) -> PGCPickerViewController {
        
        let controller = UIStoryboard(name: "PGCPickerViewController", bundle: nil).instantiateInitialViewController() as! PGCPickerViewController
        controller.modalPresentationStyle = .overCurrentContext
        controller.pickerOptions = pickerOptions
        controller.selectionHandler = selectionHandler
        
        return controller
    }
    
    private func showPickerContainer() {
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            self.viewFadeBackground.alpha = 1.0
            self.constraintPickerTop.constant = -self.viewPickerContainer.bounds.size.height
            
            self.view.layoutIfNeeded()
            
        })
    }
    
    private func hidePickerController() {
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: 0.5, animations: { [unowned self] in
            
            self.viewFadeBackground.alpha = 0.0
            self.constraintPickerTop.constant = 0.0
            
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func setupPickerValues() {
        
        guard let previous = pickerOptions?.previousSelections else {
            return
        }
        
        for (index, option) in previous.enumerated() {
            
            pickerView.selectRow(option, inComponent: index, animated: false)
        }
    }
    
    private func setDefaultValues() {
        
        guard let previous = pickerOptions?.previousSelections else {
            return
        }
        
        self.setNewValues(selections: previous)
    }
    
    private func setNewValues(selections: [Int]) {
        
        self.selectionHandler?(selections)
    }
    
    private func pickerValuesSelected() -> [Int] {
        
        var selections: [Int] = []
        
        for index in 0..<pickerView.numberOfComponents {
            
            selections.append(pickerView.selectedRow(inComponent: index))
        }
        
        return selections
    }

}

// MARK: - Protocols -

extension PGCPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return pickerOptions?.numberOfComponents ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return pickerOptions?.numberOfRows(atComponent: component) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let label = view as? UILabel ?? UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.text = pickerOptions?.title(forRow: row, atComponent: component)
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }
}
