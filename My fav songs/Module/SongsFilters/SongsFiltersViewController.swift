//
//  SongsFiltersViewController.swift
//  My fav songs
//
//  Created by Karol Ch on 18/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import UIKit

protocol DataDelegate {
    func filterSongsBy(_ songDataType: SongKeys, _ ascending: Bool)
    func searchSongBy(_ text: String, _ songDataType: SongKeys)
}

class SongsFiltersViewController: UIViewController {
    
    let pickerComponents = [SongKeys.artistName,
                            SongKeys.trackName,
                            SongKeys.primaryGenreName]
    var selectedKey: SongKeys?
    var delegate: DataDelegate?
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var filterView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var ascendingSwitch: UISwitch!
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.roundCorners(with: 10.0)
        selectedKey = pickerComponents[0]
        searchTextField.delegate = self
    }

    @IBAction func filterButtonAction(_ sender: Any) {
        replace(currentView: searchTextField, with: filterView)
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        replace(currentView: filterView, with: searchTextField)
    }
    
    func replace(currentView: UIView, with newView: UIView) {
        UIView.animate(withDuration: 0.5, animations: {
            currentView.alpha = 0
            newView.alpha = 1
        }, completion: {
            finished in
            currentView.isHidden = true
            newView.isHidden = false
        })
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if searchTextField.alpha == 1.0 {
            if let text = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if text.isEmpty { return }
                delegate?.searchSongBy(text, selectedKey!)
            }
        } else {
            delegate?.filterSongsBy(selectedKey!, ascendingSwitch.isOn)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SongsFiltersViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerComponents.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerComponents[row].prettyDescription()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedKey = pickerComponents[row]
    }
    
}

extension SongsFiltersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
