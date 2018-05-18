//
//  SongsFiltersViewController.swift
//  My fav songs
//
//  Created by Karol Ch on 18/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import UIKit

class SongsFiltersViewController: UIViewController {
    
    let pickerComponents = [SongKeys.artistName.prettyDescription(), SongKeys.trackName.prettyDescription(), SongKeys.primaryGenreName.prettyDescription()]
    
    @IBOutlet weak var filterView: UIStackView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var ascendingSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        return pickerComponents[row]
    }
    
}
