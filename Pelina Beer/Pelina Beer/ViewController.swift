//
//  ViewController.swift
//  Pelina Beer
//
//  Created by SaulUrias on 02/03/20.
//  Copyright © 2020 saulurias. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    private let movieServiceCaller = MovieServiceCaller()
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func feed(_ sender: Any) {
        movieServiceCaller.getMovies(state: .feed) { result in
            switch result {
            case .success(let response):
                print(response.movies)
                self.movies = response.movies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func filter(_ sender: Any) {
        movieServiceCaller.getMovies(state: .filtered(query: "son")) { result in
            switch result {
            case .success(let response):
                print(response.movies)
                self.movies = response.movies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func favorites(_ sender: Any) {
        movieServiceCaller.getMovies(state: .favorite) { result in
            switch result {
            case .success(let response):
                print(response.movies)
                self.movies = response.movies
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func markFavorite(_ sender: Any) {
        let movie = movies[Int.random(in: 0...movies.count - 1)]
        movieServiceCaller.markAsFavorite(movie: movie, isCurrentFavorite: false) { result in
            switch result {
            case .success(let response):
                print(response.statusMessage)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
