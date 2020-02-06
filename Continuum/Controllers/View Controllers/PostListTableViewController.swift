//
//  PostListTableViewController.swift
//  Continuum
//
//  Created by Devin Singh on 2/5/20.
//  Copyright © 2020 Devin Singh. All rights reserved.
//

import UIKit

class PostListTableViewController: UITableViewController {
    // MARK: - Properties
    
    var resultsArray: [SearchableRecord] = []
    var isSearching = false
    var dataSource: [SearchableRecord] { return isSearching ? resultsArray : PostController.shared.posts }
    
    // MARK: - Outlets
    
    @IBOutlet weak var postListSearchBar: UISearchBar!
    
    // MARK: - Lifestyle Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postListSearchBar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resultsArray = PostController.shared.posts
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataSource.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        
        let postToSend = dataSource[indexPath.row] as? Post
        
        cell.post = postToSend
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPostDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow, let destinationVC = segue.destination as? PostDetailTableViewController else { return }
            
            let postToSend = PostController.shared.posts[indexPath.row]
            
            destinationVC.post = postToSend
        }
    }
}


// MARK: - UISearchBarDelegate

extension PostListTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultsArray = PostController.shared.posts.filter { $0.matches(searchTerm: searchText) }
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        resultsArray = PostController.shared.posts
        tableView.reloadData()
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
      isSearching = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
      isSearching = false
    }
    
}
