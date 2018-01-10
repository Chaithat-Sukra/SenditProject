//
//  MainViewController.swift
//  SenditProject
//
//  Created by Chaithat Sukra on 10/1/18.
//  Copyright © 2018 Chaithat Sukra. All rights reserved.
//

import UIKit
import AlamofireImage

class MainViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tbItems: UITableView!
    
    var isLoading: Bool = false
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    
    let bl: InitBL = InitBL()
    
    fileprivate var viewModel: ItemViewModel = ItemViewModel() {
        didSet {
            self.loading(aLoading: false)
            
            self.refreshControl.endRefreshing()
            self.tbItems.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.refreshControl.beginRefreshing()
        self.tbItems.addSubview(self.refreshControl)
        self.tbItems.bringSubview(toFront: self.refreshControl)
        
        self.tbItems.dataSource = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        self.tbItems.tableHeaderView = searchController.searchBar

        self.loading(aLoading: true)
        self.reloadData()
    }

    func refresh(_ aSender: UIRefreshControl) {
        self.reloadData()
    }

    private func reloadData() {
        self.bl.requestData { (aItems: [ItemModel]) in
            self.viewModel.update(aItems: aItems)
        }
    }
    
    func loading(aLoading: Bool) {
        self.activityIndicator.isHidden = !aLoading
        if aLoading {
            self.activityIndicator.startAnimating()
        }
        else {
            self.activityIndicator.stopAnimating()
        }
        self.isLoading = aLoading
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ItemTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        let item: ItemModel = self.viewModel.filteredItems[indexPath.row];
        
        let placeholderImage = UIImage(named: "placeholder")!
        cell.imgvItem.af_setImage(withURL: URL(string: item.image)!, placeholderImage: placeholderImage)
        cell.lbName.text = item.name
        cell.lbName.textAlignment = .center
        cell.lbDesc.text = item.desc
        cell.lbDesc.textAlignment = .center
        cell.lbURL.text = item.url
        cell.lbURL.textAlignment = .center
        
        return cell

    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            self.viewModel.filteredItems = self.viewModel.items
        }
        else {
            self.viewModel.filteredItems = self.viewModel.items.filter {
                $0.name.contains(searchController.searchBar.text!)
            }
        }
        self.tbItems.reloadData()
    }
}
