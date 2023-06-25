//
//  APPFooterLoadingCollectionReusableView.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import UIKit

final class APPFooterLoadingCollectionReusableView: UICollectionReusableView {
    static let identifier = "APPFooterLoadingCollectionReusableView"

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.color = UIColor(named: "RickAndMortyBlue")
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    public func startAnimating() {
        spinner.startAnimating()
    }
}
