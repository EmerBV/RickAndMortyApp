//
//  APPSearchView.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import UIKit

protocol APPSearchViewDelegate: AnyObject {
    func appSearchView(_ searchView: APPSearchView, didSelectOption option: APPSearchInputViewViewModel.DynamicOption)

    func appSearchView(_ searchView: APPSearchView, didSelectLocation location: APPLocation)
    func appSearchView(_ searchView: APPSearchView, didSelectCharacter character: APPCharacter)
    func appSearchView(_ searchView: APPSearchView, didSelectEpisode episode: APPEpisode)
}

final class APPSearchView: UIView {

    weak var delegate: APPSearchViewDelegate?

    private let viewModel: APPSearchViewViewModel

    // MARK: - Subviews

    private let searchInputView = APPSearchInputView()

    private let noResultsView = APPNoSearchResultsView()

    private let resultsView = APPSearchResultsView()

    // Results collectionView

    // MARK: - Init

    init(frame: CGRect, viewModel: APPSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultsView, noResultsView, searchInputView)
        addConstraints()

        searchInputView.configure(with: APPSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self

        setUpHandlers(viewModel: viewModel)

        resultsView.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setUpHandlers(viewModel: APPSearchViewViewModel) {
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }

        viewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: result)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }

        viewModel.registerNoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),

            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),

            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

// MARK: - CollectionView

extension APPSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)


    }
}

// MARK: - APPSearchInputViewDelegate

extension APPSearchView: APPSearchInputViewDelegate {
    func appSearchInputView(_ inputView: APPSearchInputView, didSelectOption option: APPSearchInputViewViewModel.DynamicOption) {
        delegate?.appSearchView(self, didSelectOption: option)
    }

    func appSearchInputView(_ inputView: APPSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }

    func appSearchInputViewDidTapSearchKeyboardButton(_ inputView: APPSearchInputView) {
        viewModel.executeSearch()
    }
}

// MARK: - APPSearchResultsViewDelegate

extension APPSearchView: APPSearchResultsViewDelegate {
    func appSearchResultsView(_ resultsView: APPSearchResultsView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else {
            return
        }
        delegate?.appSearchView(self, didSelectLocation: locationModel)
    }

    func appSearchResultsView(_ resultsView: APPSearchResultsView, didTapEpisodeAt index: Int) {
        guard let episodeModel = viewModel.episodeSearchResult(at: index) else {
            return
        }
        delegate?.appSearchView(self, didSelectEpisode: episodeModel)
    }

    func appSearchResultsView(_ resultsView: APPSearchResultsView, didTapCharacterAt index: Int) {
        guard let characterModel = viewModel.characterSearchResult(at: index) else {
            return
        }
        delegate?.appSearchView(self, didSelectCharacter: characterModel)
    }
}
