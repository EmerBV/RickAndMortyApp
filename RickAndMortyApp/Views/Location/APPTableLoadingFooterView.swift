//
//  APPTableLoadingFooterView.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import UIKit

final class APPTableLoadingFooterView: UIView {

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        spinner.color = UIColor(named: "RickAndMortyBlue")
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(spinner)
        spinner.startAnimating()

        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 55),
            spinner.heightAnchor.constraint(equalToConstant: 55),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

        ])
    }

}
