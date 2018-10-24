//
//  PGCPickerViewController.swift
//  
//
//  Created by Paul Aguilar on 10/13/18.
//

import UIKit

public protocol PickerOptions {
    
    var currentIndexesSelected: [Int]? { set get }
    var numberOfComponents: Int { get }
    
    func numberOfRows(atComponent component: Int) -> Int
    func title(forRow row: Int, atComponent component: Int) -> String
    
}

typealias SelectionHandler = (_ selections: [Int]) -> Void

class PGCPickerViewController: UIViewController {
    
    // MARK: - IBOutlets -
    
    @IBOutlet private weak var constraintPickerContainerTop: NSLayoutConstraint!
    @IBOutlet private weak var viewFadeBackground: UIView!
    @IBOutlet private weak var viewPickerContainer: UIView!
    @IBOutlet private weak var pickerView: UIPickerView!

    // MARK: - Properties -
    
    public var pickerOptions: PickerOptions?
    public var selectionHandler: SelectionHandler? = nil
    
    private let animationDuration = 0.35

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
    
    @IBAction func actionCancel(_ sender: Any) {
        
        setDefaultValues()
        hidePickerController()
    }
    
    @IBAction func actionDone(_ sender: Any) {
        
        setNewValues(selections: pickerValuesSelected())
        hidePickerController()
    }
    
    @IBAction func actionTapFadeBackground(_ sender: Any) {
        
        setNewValues(selections: pickerValuesSelected())
        hidePickerController()
    }
    
    // MARK: - Methods -
    
    public static func presentFrom(pickerOptions: PickerOptions, selectionHandler: @escaping SelectionHandler) -> PGCPickerViewController {
        
        let controller = UIStoryboard.instantiatePickerController
        
        controller.modalPresentationStyle = .overCurrentContext
        controller.pickerOptions = pickerOptions
        controller.selectionHandler = selectionHandler
        
        return controller
    }
    
    // MARK: - Private -
    
    private func hidePickerController() {
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationDuration, animations: { [unowned self] in
            
            self.viewFadeBackground.alpha = 0.0
            self.constraintPickerContainerTop.constant = 0.0
            
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func pickerValuesSelected() -> [Int] {
        
        var selections: [Int] = []
        
        for index in 0..<pickerView.numberOfComponents {
            
            selections.append(pickerView.selectedRow(inComponent: index))
        }
        
        return selections
    }
    
    private func setDefaultValues() {
        
        guard let current = pickerOptions?.currentIndexesSelected else {
            return
        }
        
        self.setNewValues(selections: current)
    }
    
    private func setNewValues(selections: [Int]) {
        
        self.selectionHandler?(selections)
    }
    
    private func setupPickerValues() {
        
        guard let current = pickerOptions?.currentIndexesSelected else {
            return
        }
        
        for (index, option) in current.enumerated() {
            
            pickerView.selectRow(option, inComponent: index, animated: false)
        }
    }
    
    private func showPickerContainer() {
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationDuration, animations: {
            
            self.viewFadeBackground.alpha = 1.0
            self.constraintPickerContainerTop.constant = -self.viewPickerContainer.bounds.size.height
            
            self.view.layoutIfNeeded()
            
        })
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



internal extension UIStoryboard {
    
    static var instantiatePickerController: PGCPickerViewController {
        
        guard let pickerController = UIStoryboard(name: "PGCPickerViewController", bundle: nil).instantiateInitialViewController() as? PGCPickerViewController else {
            
            fatalError()
        }
        
        return pickerController
    }
}
