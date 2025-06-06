//
//  LaunchScreenViewController.swift
//  ShowPass
//
//  Created by Lakshay Garg on 06/06/25.
//  Email: lakshay.511garg@gmail.com
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "LaunchIcon")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let appNameLabel: UILabel = {
        let label = UILabel()
        label.text = "ShowPass"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        label.textColor = .label
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your Movie Companion"
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.alpha = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLaunchScreen()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(iconImageView)
        view.addSubview(appNameLabel)
        view.addSubview(subtitleLabel)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            iconImageView.widthAnchor.constraint(equalToConstant: 120),
            iconImageView.heightAnchor.constraint(equalToConstant: 120),
            
            appNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appNameLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
            
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: appNameLabel.bottomAnchor, constant: 8)
        ])
        
        // Initial transform
        iconImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    }
    
    private func animateLaunchScreen() {
        // Animate icon
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.iconImageView.transform = .identity
        }
        
        // Animate app name
        UIView.animate(withDuration: 0.5, delay: 0.5) {
            self.appNameLabel.alpha = 1
        }
        
        // Animate subtitle
        UIView.animate(withDuration: 0.5, delay: 0.7) {
            self.subtitleLabel.alpha = 1
        } completion: { _ in
            self.navigateToMainScreen()
        }
    }
    
    private func navigateToMainScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            NotificationCenter.default.post(name: Notification.Name("ShowMainTabBar"), object: nil)
        }
    }
} 