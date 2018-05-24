//
//  SavedSongsViewController.swift
//  My fav songs
//
//  Created by Karol Ch on 15/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import UIKit
import KCHModalStatus

class SavedSongsViewController: UIViewController {

    @IBOutlet weak var noSongsLabel: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let CELL_BUTTON_TEXT = "Delete"
    let CELL_ID = "songCell"
    let CELL_NIB_NAME = "SongCell"
    
    lazy var viewModel: SavedSongsViewModel = {
        return SavedSongsViewModel(appDelegate: UIApplication.shared.delegate as! AppDelegate)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        setVM()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchSongs()
        super.viewWillAppear(true)
    }
    
    func setViews() {
        showEmptyListLabel()
    }
    
    func setVM() {
        viewModel.showAlertClosure = { (error) in
            guard let vc = self as SavedSongsViewController? else {
                return
            }
            DispatchQueue.main.async {
                vc.showEmptyListLabel()
                vc.showAlert(with: error.localizedDescription)
            }
        }
        
        viewModel.updateLoadingStatus = { (isLoading) in
            guard let vc = self as SavedSongsViewController? else {
                return
            }
            DispatchQueue.main.async {
                if isLoading {
                    vc.showLoadingIndicator()
                } else {
                    vc.viewModel.getNumberOfCells() > 0 ? vc.showTableView() : vc.showEmptyListLabel()
                }
            }

        }
        
        viewModel.reloadTableViewClosure = {
            if let vc = self as SavedSongsViewController? {
                DispatchQueue.main.async {
                    vc.songsTableView.reloadData()
                }
            }
        }
        
        viewModel.deleteSongModal = {
            guard let vc = self as SavedSongsViewController? else {
                return
            }
            DispatchQueue.main.async {
                let modalView = KCHModalStatusView(frame: (vc.view.frame))
                modalView.set(image: UIImage(named: "deleteIcon")!)
                modalView.set(title: "Deleting song")
                vc.view.addSubview(modalView)
                vc.viewModel.fetchSongs()
            }
        }
    }
    
    func showEmptyListLabel() {
        songsTableView.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        noSongsLabel.isHidden = false
    }
    
    func showLoadingIndicator() {
        noSongsLabel.isHidden = true
        songsTableView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func showTableView() {
        noSongsLabel.isHidden = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        songsTableView.isHidden = false
    }
    
    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SongsFilterViewController" {
            let vc = segue.destination as? SongsFiltersViewController
            vc?.delegate = viewModel
        }
    }
}

extension SavedSongsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfCells();
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        songsTableView.register(UINib(nibName: CELL_NIB_NAME, bundle: nil), forCellReuseIdentifier: CELL_ID)
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID) as! SongTableViewCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        
        cell.artistNameLabel.text = cellVM.artistNameText
        cell.songTitleLabel.text = cellVM.songTitleText
        cell.songGenreLabel.text = cellVM.genreText
        cell.artworkImageView.loadImageFrom(url: cellVM.artworkUrl)
        cell.songButton.setTitle(CELL_BUTTON_TEXT, for: .normal)
        cell.songButton.tag = indexPath.row
        cell.songButton.addTarget(self, action: #selector(deleteSong(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func deleteSong(_ sender: UIButton) {
        viewModel.deleteSong(at: sender.tag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
}
