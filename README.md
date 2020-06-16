# PGCPickerViewController

[![Swift](https://img.shields.io/badge/swift-5.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![License](https://img.shields.io/badge/license-MIT-71787A.svg)](https://tldrlegal.com/license/mit-license)
[![Platform](https://img.shields.io/badge/platform-ios-lightgrey.svg)](https://developer.apple.com/ios/)

## Installation

### Manual

Add PGCPickerViewController folder into your project.

## Usage

Check folder Example :)

### Single (one component)

Conforms to `PickerSingleOption` protocol


``` Swift

let pickerSource: PickerSingleOption!

// ...

let controller = PGCPickerViewController.with(pickerOption: pickerSource) { [weak self] (indexSelected) in

    self?.pickerSource.currentIndexSelected = indexSelected // Save selection
    
    // Do stuff with indexSelected
    // self?.select(index: indexSelected)
}

self.present(controller, animated: false, completion: nil)
```

### Multiple

// TODO

## Images

### Single choice

![Single](https://github.com/aguilarpgc/PGCPickerController/blob/master/Images/simple.gif)

### Multiple choice

![Multiple](https://github.com/aguilarpgc/PGCPickerController/blob/master/Images/multiple.gif)

## License

This program is free software; you can redistribute it and/or modify it under the terms of the MIT License.
