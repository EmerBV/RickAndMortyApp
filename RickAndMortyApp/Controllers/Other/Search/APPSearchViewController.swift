//
//  APPSearchViewController.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 23/6/23.
//

import UIKit

///
final class APPSearchViewController: UIViewController {
    ///
    struct Config {
        enum `Type` {
            case character
            case episode
            case location

            var endpoint: APPEndpoint {
                switch self {
                case .character: return .character
                case .episode: return .episode
                case .location: return .location
                }
            }

            var title: String {
                switch self {
                case .character:
                    return "Search Characters"
                case .location:
                    return "Search Location"
                case .episode:
                    return "Search Episode"
                }
            }
        }

        let type: `Type`
    }

    private let viewModel: APPSearchViewViewModel
    private let searchView: APPSearchView

    // MARK: - Init

    init(config: Config) {
        let viewModel = APPSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = APPSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Search",
            style: .done,
            target: self,
            action: #selector(didTapExecuteSearch)
        )
        searchView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        searchView.presentKeyboard()
    }

    @objc private func didTapExecuteSearch() {
        viewModel.executeSearch()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - APPSearchViewDelegate

extension APPSearchViewController: APPSearchViewDelegate {
    func appSearchView(_ searchView: APPSearchView, didSelectOption option: APPSearchInputViewViewModel.DynamicOption) {
        let vc = APPSearchOptionPickerViewController(option: option) { [weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)
    }

    func appSearchView(_ searchView: APPSearchView, didSelectLocation location: APPLocation) {
        let vc = APPLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    func appSearchView(_ searchView: APPSearchView, didSelectCharacter character: APPCharacter) {
        let vc = APPCharacterDetailViewController(viewModel: .init(character: character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    func appSearchView(_ searchView: APPSearchView, didSelectEpisode episode: APPEpisode) {
        let vc = APPEpisodeDetailViewController(url: URL(string: episode.url))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
