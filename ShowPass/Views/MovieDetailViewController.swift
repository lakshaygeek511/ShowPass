//
//  MovieDetailViewController.swift
//  ShowPass
//
//  Created by Lakshay Garg on 06/06/25.
//  Email: lakshay.511garg@gmail.com
//

import UIKit

class MovieDetailViewController: UIViewController {
    private let movie: Movie
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backdropImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray6
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureContent()
        setupNavigationBar()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.contentInsetAdjustmentBehavior = .never
        
        scrollView.addSubview(contentView)
        contentView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 1000) // Initial height
        
        setupSubviews()
    }
    
    private func setupSubviews() {
        contentView.addSubview(backdropImageView)
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(overviewLabel)
        
        backdropImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 250)
        
        posterImageView.frame = CGRect(x: 16, y: backdropImageView.frame.maxY - 75,
                                     width: 100, height: 150)
        
        titleLabel.frame = CGRect(x: posterImageView.frame.maxX + 16,
                                y: backdropImageView.frame.maxY + 8,
                                width: view.frame.width - posterImageView.frame.maxX - 32,
                                height: 60)
        
        releaseDateLabel.frame = CGRect(x: posterImageView.frame.maxX + 16,
                                      y: titleLabel.frame.maxY + 8,
                                      width: 200, height: 20)
        
        ratingLabel.frame = CGRect(x: posterImageView.frame.maxX + 16,
                                 y: releaseDateLabel.frame.maxY + 4,
                                 width: 200, height: 20)
        
        overviewLabel.frame = CGRect(x: 16, y: max(posterImageView.frame.maxY, ratingLabel.frame.maxY) + 24,
                                   width: view.frame.width - 32, height: 0)
        overviewLabel.sizeToFit()
        
        contentView.frame.size.height = overviewLabel.frame.maxY + 32
        scrollView.contentSize = contentView.frame.size
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "bookmark"),
            style: .plain,
            target: self,
            action: #selector(bookmarkTapped)
        )
        
        if CoreDataManager.shared.isMovieBookmarked(movieId: movie.id) {
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bookmark.fill")
        }
    }
    
    private func configureContent() {
        titleLabel.text = movie.title
        releaseDateLabel.text = "Release Date: \(movie.releaseDate)"
        ratingLabel.text = "Rating: ⭐️ \(String(format: "%.1f", movie.voteAverage)) (\(movie.voteCount) votes)"
        overviewLabel.text = movie.overview
        
        if let backdropPath = movie.backdropPath {
            ImageLoader.shared.loadImage(from: "https://image.tmdb.org/t/p/w500\(backdropPath)") { [weak self] image in
                DispatchQueue.main.async {
                    self?.backdropImageView.image = image
                }
            }
        }
        
        if let posterPath = movie.posterPath {
            ImageLoader.shared.loadImage(from: "https://image.tmdb.org/t/p/w500\(posterPath)") { [weak self] image in
                DispatchQueue.main.async {
                    self?.posterImageView.image = image
                }
            }
        }
    }
    
    @objc private func bookmarkTapped() {
        let isBookmarked = CoreDataManager.shared.isMovieBookmarked(movieId: movie.id)
        
        if isBookmarked {
            CoreDataManager.shared.removeBookmark(movieId: movie.id)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bookmark")
        } else {
            CoreDataManager.shared.saveBookmark(movie: movie)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "bookmark.fill")
        }
    }
} 