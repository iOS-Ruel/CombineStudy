//
//  SearchViewController.swift
//  CombineTest
//
//  Created by Chung Wussup on 5/6/24.
//

import UIKit
import SnapKit
import Combine

class SearchViewController: UIViewController {
    let viewModel = SearchViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return rc
    }()

    lazy var searchTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "SearchTableViewCell")
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "도서명/저자/출판사으로 검색해주세요."
        // hidesNavigationBarDuringPresentation -> 검색시 (키보드가 올라왔을때) 네비게이션 타이틀을 가릴지 안가릴지
        searchController.hidesNavigationBarDuringPresentation = true
        searchController.searchResultsUpdater = self
        
        return searchController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchController()
        
        viewModel.fetchBookList(searchText: "iOS")
        
//        viewModel.booksList
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] book in
//                self?.searchTableView.reloadData()
//            }
//            .store(in: &cancellables)
    
        
        viewModel.$bookList
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.searchTableView.reloadData()
            }
            .store(in: &cancellables)
        
//        viewModel.fetchBooks(searchText: "iOS") { [weak self] in
//            DispatchQueue.main.async {
//                self?.searchTableView.reloadData()
//                
//            }
//        }
    }
    
    private func setupSearchController() {
        self.navigationItem.searchController = searchController
        self.navigationItem.title = "도서 검색"
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    private func setupUI() {
        self.view.addSubview(searchTableView)
        
        searchTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    
    @objc func refresh() {
        viewModel.fetchBookList(searchText: "iOS", isRefresh: true)
//        viewModel.fetchBooks(searchText: "iOS", isRefresh: true) {
//            DispatchQueue.main.async { [weak self] in
//                self?.searchTableView.reloadData()
//                self?.refreshControl.endRefreshing()
//            }
//        }
    }
    
}


extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.books.count
        return viewModel.bookList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell",
                                                    for: indexPath) as? SearchTableViewCell {
//            cell.bindCell(book: viewModel.books[indexPath.row])
            cell.bindCell(book: viewModel.bookList[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let viewModel = BookDetailViewModel(book: viewModel.books[indexPath.row])
        let viewModel = BookDetailViewModel(book: viewModel.bookList[indexPath.row])
        let vc = BookDetailViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            let searchText = searchController.searchBar.text == "" ? "iOS" : searchController.searchBar.text
            viewModel.fetchBookList(searchText: searchText)
//            viewModel.fetchBooks(searchText: searchText) { [weak self] in
//                DispatchQueue.main.async {
//                    self?.searchTableView.reloadData()
//                }
//            }
        }
    }
    
    
}


extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        viewModel.fetchBookList(searchText: text == "" ? "iOS" : text.lowercased(), isRefresh: true)
        
//        viewModel.fetchBooks(searchText: text == "" ? "iOS" : text.lowercased(), isRefresh: true) { [weak self] in
//            DispatchQueue.main.async {
//                self?.searchTableView.reloadData()
//            }
//        }
    }
}


