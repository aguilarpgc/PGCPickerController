//
//  PGCPickerViewController.swift
//
//
//  Created by Paul Aguilar on 10/13/18.
//

import UIKit

class PGCPickerViewController: UIViewController {
    
    enum PickerMode {
        
        case single(PickerSingleOption, PickerSingleHandler)
        case multiple(PickerMultipleOption, PickerMultipleHandler)
        
//        func update(option) {
//            
//        }
    }
    
    struct Animation {
        static let duration = 0.35
    }
    
    // MARK: - IBOutlets -
    
    @IBOutlet private weak var constraintPickerContainerTop: NSLayoutConstraint!
    @IBOutlet private weak var viewFadeBackground: UIView!
    @IBOutlet private weak var viewPickerContainer: UIView!
    @IBOutlet private weak var pickerView: UIPickerView!
    
    // MARK: - Properties -
    
    public var mode: PickerMode!
    
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
        
        setNewValues()
        hidePickerController()
    }
    
    @IBAction func actionTapFadeBackground(_ sender: Any) {
        
        setNewValues()
        hidePickerController()
    }
    
    // MARK: - Methods -
    
    public static func with(pickerOption options: PickerSingleOption, selectionHandler: @escaping PickerSingleHandler) -> PGCPickerViewController {
        
        let controller = UIStoryboard.instantiatePGCPickerController
        
        controller.mode = .single(options, selectionHandler)
        
        return controller
    }
    
    public static func with(pickerOptions options: PickerMultipleOption, selectionsHandler: @escaping PickerMultipleHandler) -> PGCPickerViewController {
        
        let controller = UIStoryboard.instantiatePGCPickerController
        
        controller.mode = .multiple(options, selectionsHandler)
        
        return controller
    }
    
    // MARK: - Private -
    
    private func hidePickerController() {
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: Animation.duration, animations: { [unowned self] in
            
            self.viewFadeBackground.alpha              = 0.0
            self.constraintPickerContainerTop.constant = 0.0
            
            self.view.layoutIfNeeded()
            
        }) { (finished) in
            
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    private func showPickerContainer() {
        
        self.view.layoutIfNeeded()
        
        UIView.animate(withDuration: Animation.duration, animations: {
            
            self.viewFadeBackground.alpha              = 1.0
            self.constraintPickerContainerTop.constant = -self.viewPickerContainer.bounds.size.height
            
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - Picker -
    
    private func setDefaultValues() {
        
        switch mode! {
            
        case PickerMode.single(let option, let handler):
            
            if let defaultIndexSelected = option.currentIndexSelected {
                handler(defaultIndexSelected)
            }
            
        case PickerMode.multiple(let options, let handler) :
            
            if let defaultIndexes = options.currentIndexesSelected {
                handler(defaultIndexes)
            }
        }
    }
    
//    private func runHandler() {
//
//
//
//    }
    
    private func setNewValues() {
        
        switch mode! {
            
        case PickerMode.single(_, let handler):
            
            handler(pickerView.selectedRow(inComponent: 0))
            
        case PickerMode.multiple(_, let handler) :
            
            let selections = (0..<pickerView.numberOfComponents).map { (component) in

                pickerView.selectedRow(inComponent: component)
            }
            
            handler(selections)
        }
    }
    
    private func setupPickerValues() {
        
        switch mode! {
            
        case PickerMode.single(let option, _):
            
            if let currentIndexSelected = option.currentIndexSelected {
                pickerView.selectRow(currentIndexSelected, inComponent: 0, animated: false)
            }
            
        case PickerMode.multiple(let options, _) :
            
            if let indexes = options.currentIndexesSelected {
                for (component, rowIndex) in indexes.enumerated() {
                    pickerView.selectRow(rowIndex, inComponent: component, animated: false)
                }
            }
        }
    }
}

// MARK: - Protocols -

extension PGCPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        switch self.mode! {
            
        case PickerMode.single(_,_):
            return 1
            
        case PickerMode.multiple(let options, _):
            return options.numberOfComponents
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch self.mode! {
            
        case PickerMode.single(let option,_):
            return option.numberOfRows()
            
        case PickerMode.multiple(let options, _):
            return options.numberOfRows(atComponent: component)
            
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var title: String
        
        switch self.mode! {
            
        case PickerMode.single(let option,_):
            title = option.title(forRow: row)
            
        case PickerMode.multiple(let options, _):
            title = options.title(forRow: row, atComponent: component)
            
        }
        
        let label = view as? UILabel ?? UILabel()
        
        label.font = .systemFont(ofSize: 15)
        label.text = title
        label.textAlignment = .center
        label.textColor = .black
        
        return label
    }
}

internal extension UIStoryboard {
    
    static var instantiatePGCPickerController: PGCPickerViewController {
        
        guard let pickerController = UIStoryboard(name: "PGCPickerViewController", bundle: nil).instantiateInitialViewController() as? PGCPickerViewController else {
            
            fatalError()
        }
        
        pickerController.modalPresentationStyle = .overCurrentContext
        
        return pickerController
    }
}

