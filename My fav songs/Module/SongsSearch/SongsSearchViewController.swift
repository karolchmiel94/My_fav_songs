//
//  SongsSearchViewController.swift
//  My fav songs
//
//  Created by Karol Ch on 15/05/2018.
//  Copyright © 2018 Karol Chmiel. All rights reserved.
//

import UIKit

class SongsSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var emptyListLabel: UILabel!
    @IBOutlet weak var songsTableView: UITableView!
    
    lazy var viewModel: SongsSearchViewModel = {
        return SongsSearchViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.ź
        initView()
        initVM()
    }
    
    func initView() {
        searchBar.delegate = self as? UISearchBarDelegate
        songsTableView.isHidden = true
    }
    
    func initVM() {
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(with: message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] () in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.emptyListLabel.isHidden = false
                    self?.songsTableView.isHidden = true
                } else {
                    self?.emptyListLabel.isHidden = true
                    self?.songsTableView.isHidden = false
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.songsTableView.reloadData()
            }
        }
        
    }

    func showAlert(with message: String) {
        let alert = UIAlertController(title: "Error",
                                                    message: message,
                                                    preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alert.show(self, sender: nil)
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
        songsTableView.register(UINib(nibName: "SongCell", bundle: nil), forCellReuseIdentifier: "songCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "songCell") as! SongTableViewCell
        let cellVM = viewModel.getCellViewModel(at: indexPath)
        cell.artistNameLabel.text = cellVM.artistNameText
        cell.songTitleLabel.text = cellVM.songTitleText
        cell.songGenreLabel.text = cellVM.genreText
        cell.artworkImageView.loadImageFrom(url: cellVM.artworkUrl)
        return cell
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

