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
    
    @IBOutlet weak var swCat: UISegmentedControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tbItems: UITableView!
    
    var paging: Int!
    var isLoading: Bool = false
    let refreshControl = UIRefreshControl()
    let searchController = UISearchController(searchResultsController: nil)
    var selectedItem: ItemModel!
    
    var bl: BLProtocol!
    var mainBL: MainCoreDataBL = MainCoreDataBL()
    
    fileprivate var viewModel: ItemViewModel = ItemViewModel() {
        didSet {
            self.loading(aLoading: false)
            
            self.refreshControl.endRefreshing()
            self.tbItems.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.paging = 0
        self.bl = MainFactory.getMainBL()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        self.refreshControl.beginRefreshing()
        self.tbItems.addSubview(self.refreshControl)
        self.tbItems.bringSubview(toFront: self.refreshControl)
        
        self.tbItems.dataSource = self
        self.tbItems.delegate = self
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        self.tbItems.tableHeaderView = searchController.searchBar

        self.loading(aLoading: true)
        self.reloadData()
    }
    
    @IBAction func switchCategories(_ sender: Any) {
        if self.swCat.selectedSegmentIndex == 0 {
            self.viewModel.update(aItems: [])
        }
        else {
            let items: [ItemModel] = self.mainBL.queryFavourites()
            self.viewModel.updateFavourite(aItems: items)
        }
    }

    func refresh(_ aSender: UIRefreshControl) {
        self.reloadData()
    }

    fileprivate func reloadData() {
        self.bl.requestData(aPage: self.paging) { (aItems: [ItemModel]) in
            if aItems.count > 0 {
                self.viewModel.update(aItems: aItems)
            }
            else {
                let alertController = UIAlertController(title: "Opps!!", message: "Something Error", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert: UIAlertAction) in
                    self.loading(aLoading: false)
                    
                    self.refreshControl.endRefreshing()
                    self.tbItems.reloadData()
                })
                alertController.addAction(action)
                self.present(alertController, animated: true, completion: nil)
            }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "main_detail" {
            let vc = segue.destination as? DetailViewController
            vc?.selectedItem = self.selectedItem
        }
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.viewModel.filteredItems.count > 0) {
            return 1
        }
        else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.swCat.selectedSegmentIndex == 0 ? self.viewModel.filteredItems.count + 1 : self.viewModel.filteredItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == self.viewModel.filteredItems.count {
            return 44
        }
        else {
            return 250
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.viewModel.filteredItems.count {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreTableViewCell", for: indexPath) as? LoadMoreTableViewCell  else {
                fatalError("The dequeued cell is not an instance of LoadMoreTableViewCell.")
            }
            return cell
        }
        else {
            let cellIdentifier = "ItemTableViewCell"
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ItemTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
            }
            
            let item: ItemModel = self.viewModel.filteredItems[indexPath.row];
            cell.bDidSelect = {
                () -> Void in
                if item.isFavourited {
                    self.mainBL.removeFavourited(aItemModel: item)
                }
                else {
                    self.mainBL.addFavourited(aItemModel: item)
                }
                self.viewModel.updateItemAtIndex(aIndex: indexPath.row, aItem: item)
            }
            cell.btnFavourite.setTitle(item.isFavourited ? "U" : "F", for: .normal)
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
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRow = self.viewModel.filteredItems.count
        if !isLoading && indexPath.row == lastRow {
            self.isLoading = true
            self.paging = self.viewModel.filteredItems.last?.id
            self.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedItem = self.viewModel.filteredItems[indexPath.row]
        self.performSegue(withIdentifier: "main_detail", sender: self)
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
