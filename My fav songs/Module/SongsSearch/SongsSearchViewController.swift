//
//  SongsSearchViewController.swift
//  My fav songs
//
//  Created by Karol Ch on 15/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import UIKit
import KCHModalStatus

class SongsSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let CELL_ID = "songCell"
    let CELL_NIB_NAME = "SongCell"
    let DEFAULT_ERROR_TEXT = "Couldn't find songs"
    
    lazy var viewModel: SongsSearchViewModel = {
        return SongsSearchViewModel(appDelegate: UIApplication.shared.delegate as! AppDelegate)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        initVM()
    }
    
    func initView() {
        searchBar.delegate = self
        songsTableView.isHidden = true
        activityIndicator.isHidden = true
    }
    
    func initVM() {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                let message = self?.viewModel.alertMessage ?? self?.DEFAULT_ERROR_TEXT
                self?.showAlert(with: message!)
                self?.showEmptyListLabel()
                }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.showLoadingIndicator()
                } else {
                    self?.showTableView()
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.songsTableView.reloadData()
            }
        }
        
        viewModel.saveSongModal = { [weak self] in
            DispatchQueue.main.async {
                let modalView = KCHModalStatusView(frame: (self?.view.frame)!)
                modalView.set(image: UIImage(named: "saveIcon")!)
                modalView.set(title: "Saving song")
                self?.view.addSubview(modalView)
            }
        }
    }
    
    func showTableView() {
        emptyListLabel.isHidden = true
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        songsTableView.isHidden = false
    }
    
    func showEmptyListLabel() {
        songsTableView.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        emptyListLabel.isHidden = false
    }
    
    func showLoadingIndicator() {
        emptyListLabel.isHidden = true
        songsTableView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error",
                                                    message: message,
                                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SongsSearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        songsTableView.register(UINib(nibName: CELL_NIB_NAME, bundle: nil), forCellReuseIdentifier: CELL_ID)
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID) as! SongTableViewCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        
        cell.artistNameLabel.text = cellVM.artistNameText
        cell.songTitleLabel.text = cellVM.songTitleText
        cell.songGenreLabel.text = cellVM.genreText
        cell.artworkImageView.loadImageFrom(url: cellVM.artworkUrl)
        cell.songButton.tag = indexPath.row
        cell.songButton.addTarget(self, action: #selector(saveSong(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func saveSong(_ sender: UIButton) {
        viewModel.saveSong(at: sender.tag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

extension SongsSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)! { return }
        
        viewModel.searchForSongs(searchBar.text!)
        searchBar.resignFirstResponder()
    }
}
