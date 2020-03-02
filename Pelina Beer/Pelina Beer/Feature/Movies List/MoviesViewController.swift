//
//  MoviesViewController.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import UIKit

final class MoviesViewController: UIViewController, Alertable {
    // MARK: Constants and Variables
    private var viewModel = MovieViewModel()
    
    private enum DesignConstants {
        static let movieCollectionViewCellId = "MovieCollectionViewCellId"
        static let collectionViewLayoutInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        static let collectionViewMiniumLineSpacing: CGFloat = 25
        static let collectionViewCellHeight: CGFloat = 270
    }
    
    private let segmentControl = UISegmentedControl(items: ["Feed", "Favorites"])
    
    private lazy var filterItem = UIBarButtonItem(image: UIImage(named: "search-icon"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(filterItemTapped))
    
    private lazy var sortItem = UIBarButtonItem(image: UIImage(named: "sort-icon"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(sortItemTapped))
    
    private let searchBar = UISearchBar()
    
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = DesignConstants.collectionViewLayoutInsets
        layout.minimumLineSpacing = DesignConstants.collectionViewMiniumLineSpacing
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout)
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .onDrag
        collectionView.register(MovieCollectionViewCell.self,
                                forCellWithReuseIdentifier: DesignConstants.movieCollectionViewCellId)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpView()
        setUpBindings()
        viewModel.loadMovies()
    }
    
    // MARK: Functions
    private func setUpNavigationBar() {
        viewModel.movieListState = .feed
        segmentControl.selectedSegmentIndex = .zero
        segmentControl.addTarget(self, action: #selector(segmentControlTapped), for: .valueChanged)
        navigationItem.titleView = segmentControl
        navigationItem.rightBarButtonItem = filterItem
        navigationItem.leftBarButtonItem = sortItem
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.showsScopeBar = true
        searchBar.searchTextField.delegate = self
        searchBar.placeholder = "Search"
        navigationItem.titleView = self.searchBar
        searchBar.becomeFirstResponder()
    }
    
    private func setUpView() {
        view.backgroundColor = .white
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setUpBindings() {
        viewModel.didLoadMovies.bind { [weak self] _ in
            guard let self = self else { return }
            self.collectionView.reloadData()
        }
        
        viewModel.networkError.bind { [weak self] error in
            guard let self = self, let error = error else { return }
            self.showAlert(title: "Oh no, Bad Luck!", message: error.localizedDescription)
        }
        
        viewModel.addedToWatchList.bind { [weak self] addedToWatchList in
            guard let self = self, addedToWatchList != nil else { return }
            self.showAlert(title: "Added To Watch List")
        }
    }
    
    @objc private func segmentControlTapped() {
        loadMoviesForSelectedSection()
    }
    
    private func loadMoviesForSelectedSection() {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            viewModel.movieListState = .feed
        case 1:
            viewModel.movieListState = .favorite
        default: break
        }
        
        viewModel.loadMovies()
    }
    
    @objc private func filterItemTapped() {
        setUpSearchBar()
    }
    
    @objc private func sortItemTapped() {
        displaySortingOptions()
    }
    
    private func displaySortingOptions() {
        let alert = UIAlertController(title: "Select option to sort", message: "", preferredStyle: .actionSheet)
        
        let sortByTitleAction = UIAlertAction(title: "Sort By Title", style: .default) { _ in
            self.viewModel.sortMovies(by: .title)
        }
        
        let sortByDateAction = UIAlertAction(title: "Sort By Date", style: .default) { _ in
            self.viewModel.sortMovies(by: .date)
        }
        
        let sortByRateAction = UIAlertAction(title: "Sort By Rate", style: .default) { _ in
            self.viewModel.sortMovies(by: .rate)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(sortByTitleAction)
        alert.addAction(sortByDateAction)
        alert.addAction(sortByRateAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

// MARK: UICollectionView Delegate and Datasource
extension MoviesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.totalMovies()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DesignConstants.movieCollectionViewCellId,
                                                            for: indexPath) as? MovieCollectionViewCell else {
            assertionFailure("Unable to parse MovieCollectionViewCell at MoviesViewController")
            return UICollectionViewCell()
        }
        
        guard let movie = viewModel.getMovie(at: indexPath.row) else { return UICollectionViewCell() }
        let isFavorite = viewModel.isFavorite(movie: movie)
        cell.configure(with: movie, isFavorite: isFavorite)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = viewModel.getMovie(at: indexPath.row) else { return }
        let detailViewController = MovieDetailViewController(movie: movie, viewModel: viewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width/2) - 20
        return CGSize(width: width, height: DesignConstants.collectionViewCellHeight)
    }
}

// MARK: UISearchBarDelegate
extension MoviesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        setUpNavigationBar()
        viewModel.loadMovies()
    }
}

// MARK: UITextFieldDelegate
extension MoviesViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text, !searchText.isEmpty {
            collectionView.reloadData()
            viewModel.movieListState = .filtered(query: searchText)
            viewModel.loadMovies()
        }
        textField.resignFirstResponder()
        return true
    }
}

// MARK: MovieCellDelegate
extension MoviesViewController: MovieCellDelegate {
    func movieCollectionViewCell(_ collectionViewCell: MovieCollectionViewCell, tappedFavorite button: UIButton) {
        guard let index = collectionView.indexPath(for: collectionViewCell)?.row else { return }
        guard let movie = viewModel.getMovie(at: index) else { return }
        collectionViewCell.configure(with: movie, isFavorite: !viewModel.isFavorite(movie: movie))
        viewModel.markAsFavorite(movie)
    }
}
