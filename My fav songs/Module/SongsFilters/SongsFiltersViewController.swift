//
//  SongsFiltersViewController.swift
//  My fav songs
//
//  Created by Karol Ch on 18/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import UIKit

// Consider introducing another layer, something that contains filters state.
// This filters state object could be passed to the filters screen so that filters screen
// can fill it's fields with the current state (imagine that user made a typo and only wants to correct it,
// without entering the whole config from scratch)
// On the other side, the saved songs VC could somehow observe the changes in the filters state object and reload itself once
// it changes. This would also loosen the dependencies beetween filters vc and savedsongs vc.

// I've added singleton which holds filters user edited so coming back to this view shows previously entered data.
// My tries to loosen the dependencies between filters vc and searched songs vc but only solution I came out with was to move delegate
// from this vc to singleton holding filters states. If filters states values' would change, I'd trigger reloading saved songs but it doesn't
// seems like improvement.
protocol SongsFiltersDelegate {
    func filterSongsBy(_ songDataType: SongKeys, _ ascending: Bool)
    func searchSongBy(_ text: String, _ songDataType: SongKeys)
}

class SongsFiltersViewController: UIViewController {
    
    var delegate: SongsFiltersDelegate?
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var filterView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var ascendingSwitch: UISwitch!
    @IBOutlet weak var pickerView: UIPickerView!
    
    lazy var viewModel: SongsFiltersViewModel = {
        return SongsFiltersViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchPickerComponents()
        super.viewWillAppear(true)
    }
    private func setView() {
        mainView.roundCorners(with: 10.0)
        searchTextField.delegate = self
    }
    
    private func setVM() {
        viewModel.restoreFilters = { (keyIndex, inputData, isDescending,view) in
            guard let vc = self as SongsFiltersViewController? else {
                return
            }
            DispatchQueue.main.async {
                vc.searchTextField.text = inputData
                vc.ascendingSwitch.isOn = isDescending
                vc.pickerView.selectRow(keyIndex, inComponent: 0, animated: false)
                if (view == SongsFiltersView.filter.hashValue) {
                    vc.replace(currentView: vc.searchTextField, with: vc.filterView)
                }
            }
            
        }
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
                viewModel.saveSearch(text)
                delegate?.searchSongBy(text, viewModel.getSelectedComponent())
                viewModel.saveCurrentView(SongsFiltersView.search)
            }
        } else {
            delegate?.filterSongsBy(viewModel.getSelectedComponent(), ascendingSwitch.isOn)
            viewModel.saveCurrentView(SongsFiltersView.filter)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func switchChangeAction(_ sender: Any) {
        viewModel.saveSwitchChange(ascendingSwitch.isOn)
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
        return viewModel.numberOfPickerComponents()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.getPickerComponent(at: row).prettyDescription()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.setSelectedKey(at: row)
    }
    
}

extension SongsFiltersViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
