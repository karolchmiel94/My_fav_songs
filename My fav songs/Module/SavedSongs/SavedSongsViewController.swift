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
        initView()
        initVM()
    }
    
    // You shouldn't omit the call to superclass in ViewController's lifecycle methods.
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchSongs()
    }
    
    // Consider replacing word "init" in the below methods with something else. It's confusing because you're not actually initializing anything.
    func initView() {
        songsTableView.isHidden = true
        activityIndicator.isHidden = true
    }
    
    func initVM() {
        // [weak self] is required, but instead of using optional self in the closures, why not unwrap it?
        viewModel.showAlertClosure = { [weak self] () in
            DispatchQueue.main.async {
                if let message = self?.viewModel.alertMessage {
                    self?.showAlert(with: message)
                }
            }
        }
        
        viewModel.updateLoadingStatus = { [weak self] in
            DispatchQueue.main.async {
                let isLoading = self?.viewModel.isLoading ?? false
                if isLoading {
                    self?.noSongsLabel.isHidden = true
                    self?.songsTableView.isHidden = true
                    self?.activityIndicator.isHidden = false
                    self?.activityIndicator.startAnimating()
                } else {
                    if (self?.viewModel.numberOfCells)! > 0 {
                        self?.noSongsLabel.isHidden = true
                        self?.songsTableView.isHidden = false
                    } else {
                        self?.noSongsLabel.isHidden = false
                        self?.songsTableView.isHidden = true
                    }
                    self?.activityIndicator.isHidden = true
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.reloadTableViewClosure = { [weak self] in
            DispatchQueue.main.async {
                self?.songsTableView.reloadData()
            }
        }
        
        viewModel.deleteSongModal = { [weak self] in
            DispatchQueue.main.async {
                let modalView = KCHModalStatusView(frame: (self?.view.frame)!)
                modalView.set(image: UIImage(named: "deleteIcon")!)
                modalView.set(title: "Deleting song")
                self?.view.addSubview(modalView)
                self?.viewModel.fetchSongs()
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
    
    @IBAction func showModal(_ sender: Any) {
        // Why not do it through storyboard segue?
        let modalVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SongsFiltersViewController") as! SongsFiltersViewController
        modalVC.delegate = viewModel
        modalVC.modalPresentationStyle = .overFullScreen
        modalVC.modalTransitionStyle = .crossDissolve
        self.present(modalVC, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SavedSongsViewController: UITableViewDelegate, UITableViewDataSource {
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

