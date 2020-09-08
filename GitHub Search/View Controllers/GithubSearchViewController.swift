//
//  GithubSearchViewController.swift
//  GitHub Search
//
//  Created by Blake Boxberger on 9/6/20.
//  Copyright © 2020 Blake Boxberger. All rights reserved.
//

import UIKit
import SDWebImage

class GithubSearchViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let searchController = UISearchController(searchResultsController: nil)
    var userCells:[GithubUserCellStyle] = []
    var currentQuery:String = ""
    var currentPage:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search GitHub Users"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    /// Searches the GitHub API for users, assigns the results to one of three cell styles, and reloads the collection view
    /// - Parameters:
    ///   - query: A String that represents the search for Github users
    ///   - page: An Int that represents the page of results for the search
    func searchGithubAPIForUsersWith(query:String, page:Int) {
        // Template URL - https://api.github.com/search/users?q=BlakeBoxberger&type=Users&page=0
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.github.com"
        urlComponents.path = "/search/users"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: "Users"),
            URLQueryItem(name: "page", value: "\(page)")
        ]
        let taskUrl = urlComponents.url
        if let taskUrl = taskUrl {
            let task = URLSession.shared.githubSearchTask(with: taskUrl) { (githubSearch, response, error) in
                guard let githubSearch = githubSearch, error == nil else {
                    if let error = error {
                        print("\(#file), Line: \(#line) - " + error.localizedDescription)
                    }
                    return
                }
                if !githubSearch.incompleteResults {
                    let users = githubSearch.items
                    
                    // Use a for-loop to randomly assign users to a cell style
                    // If we get the first style, we must assign two users to the style and skip an iteration of the loop
                    var skipIteration = false
                    for i in 0..<users.count {
                        if skipIteration { skipIteration = false; continue; }
                        let randomStyle = Int.random(in: 1...3)
                        if randomStyle == 1 {
                            skipIteration = true
                            if (i + 1) < users.count { // Make sure we don't get an IndexOutOfBoundsException when we select the second user
                                self.userCells.append(.GithubUserCellStyleOne(userOne: users[i], userTwo: users[i + 1]))
                            } else { // If it's the last user in the list, pick style two
                                self.userCells.append(.GithubUserCellStyleTwo(users[i]))
                            }
                        } else if randomStyle == 2 {
                            self.userCells.append(.GithubUserCellStyleTwo(users[i]))
                        } else {
                            self.userCells.append(.GithubUserCellStyleThree(users[i]))
                        }
                    }
                    
                    // Reload collection view from main thread
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
            task.resume()
        }
    }

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let userCellStyle = userCells[indexPath.row]
    
        switch userCellStyle {
        case let .GithubUserCellStyleOne(userOne, userTwo):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "user-style-one", for: indexPath) as! GithubUserStyleOneCollectionViewCell
            cell.userOne = userOne
            cell.userTwo = userTwo
            return cell
        case let .GithubUserCellStyleTwo(user):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "user-style-two", for: indexPath) as! GithubUserStyleTwoCollectionViewCell
            cell.user = user
            return cell
        case let .GithubUserCellStyleThree(user):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "user-style-three", for: indexPath) as! GithubUserStyleThreeCollectionViewCell
            cell.user = user
            return cell
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let userCellStyle = userCells[indexPath.row]
        
        switch userCellStyle {
        case .GithubUserCellStyleOne(_, _):
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width/2)
        case .GithubUserCellStyleTwo(_):
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width/2)
        case .GithubUserCellStyleThree(_):
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.width)
        }
    }
    
    // MARK: - UICollectionViewDelegate (inherited from UICollectionViewDelegateFlowLayout)
    // Pagination, automatically loading next page
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == userCells.count - 1 { // If it's about to display the last cell, load the next page of results
            currentPage += 1
            searchGithubAPIForUsersWith(query: currentQuery, page: currentPage)
        }
    }
}

extension GithubSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchQuery = searchController.searchBar.text, !searchQuery.isEmpty {
            userCells = []
            currentQuery = searchQuery
            currentPage = 0
            searchGithubAPIForUsersWith(query: searchQuery, page: 0)
        }
    }
}
