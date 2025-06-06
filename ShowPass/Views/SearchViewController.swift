//
//  SearchViewController.swift
//  ShowPass
//
//  Created by Lakshay Garg on 06/06/25.
//  Email: lakshay.511garg@gmail.com
//

import UIKit

class SearchViewController: UIViewController {
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchBar.placeholder = "Search movies..."
        controller.obscuresBackgroundDuringPresentation = false
        return controller
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 10
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return cv
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "Search for movies..."
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.isHidden = true
        return label
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>?
    private var searchWorkItem: DispatchWorkItem?
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureDataSource()
        setupSearchController()
    }
    
    private func setupUI() {
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(collectionView)
        view.addSubview(noResultsLabel)
        
        collectionView.frame = view.bounds
        collectionView.delegate = self
        
        noResultsLabel.frame = CGRect(x: 20, y: view.center.y - 40,
                                    width: view.frame.width - 40, height: 80)
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
    }
    
    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: collectionView) { collectionView, indexPath, movie in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: movie)
            return cell
        }
        
        updateDataSource(with: [])
    }
    
    private func updateDataSource(with movies: [Movie]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.trending]) // Using trending section for search results
        snapshot.appendItems(movies)
        dataSource?.apply(snapshot, animatingDifferences: true)
        
        noResultsLabel.isHidden = !movies.isEmpty || searchController.searchBar.text?.isEmpty == true
        if movies.isEmpty && !(searchController.searchBar.text?.isEmpty == true) {
            noResultsLabel.text = "No results found"
        } else {
            noResultsLabel.text = "Search for movies..."
        }
    }
    
    private func searchMovies(with query: String) {
        // Cancel previous search if any
        searchWorkItem?.cancel()
        
        let workItem = DispatchWorkItem { [weak self] in
            NetworkManager.shared.searchMovies(query: query) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        self?.updateDataSource(with: response.results)
                    case .failure(let error):
                        print("Search error: \(error)")
                        self?.updateDataSource(with: [])
                    }
                }
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: workItem)
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            updateDataSource(with: [])
            return
        }
        
        searchMovies(with: query)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = dataSource?.itemIdentifier(for: indexPath) else { return }
        let detailVC = MovieDetailViewController(movie: movie)
        navigationController?.pushViewController(detailVC, animated: true)
    }
} 