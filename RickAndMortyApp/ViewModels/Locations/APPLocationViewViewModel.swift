//
//  APPLocationViewViewModel.swift
//  RickAndMortyApp
//
//  Created by Emerson Balahan Varona on 22/6/23.
//

import Foundation

protocol APPLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class APPLocationViewViewModel {

    weak var delegate: APPLocationViewViewModelDelegate?

    private var locations: [APPLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = APPLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }

    private var apiInfo: APPGetAllLocationsResponse.Info?

    public private(set) var cellViewModels: [APPLocationTableViewCellViewModel] = []

    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    public var isLoadingMoreLocations = false

    private var didFinishPagination: (() -> Void)?

    // MARK: - Init

    init() {}

    public func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
    }

    ///
    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocations else {
            return
        }

        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString) else {
            return
        }

        isLoadingMoreLocations = true

        guard let request = APPRequest(url: url) else {
            isLoadingMoreLocations = false
            return
        }

        APPService.shared.execute(request, expecting: APPGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return APPLocationTableViewCellViewModel(location: $0)
                }))
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreLocations = false
                    strongSelf.didFinishPagination?()
                }
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreLocations = false
            }
        }
    }

    public func location(at index: Int) -> APPLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return self.locations[index]
    }

    public func fetchLocations() {
        APPService.shared.execute(
            .listLocationsRequest,
            expecting: APPGetAllLocationsResponse.self
        ) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                print(String(describing: error))
                break
            }
        }
    }

    private var hasMoreResults: Bool {
        return false
    }
}
