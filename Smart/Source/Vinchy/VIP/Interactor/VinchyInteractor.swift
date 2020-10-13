//
//  VinchyInteractor.swift
//  Smart
//
//  Created by Aleksei Smirnov on 20.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import EmailService
import VinchyCore
import Core

final class VinchyInteractor {

    private enum C {
        static let searchSuggestionsCount = 10
    }

    private let dispatchGroup = DispatchGroup()
    private let emailService = EmailService()

    private lazy var dispatchWorkItemHud = DispatchWorkItem { [weak self] in
        guard let self = self else { return }
        self.presenter.startLoading()
    }

    private lazy var searchWorkItem = WorkItem()

    private let router: VinchyRouterProtocol
    private let presenter: VinchyPresenterProtocol

    init(
        router: VinchyRouterProtocol,
        presenter: VinchyPresenterProtocol)
    {
        self.router = router
        self.presenter = presenter
    }

    private func fetchData() {

        dispatchGroup.enter()

        var compilations: [Compilation] = []

        Compilations.shared.getCompilations { [weak self] result in
            switch result {
            case .success(let model):
                compilations = model
                
            case .failure(let error):
                print(error.localizedDescription)
            }

            self?.dispatchGroup.leave()
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            guard let self = self else { return }

            self.dispatchWorkItemHud.cancel()

            if isShareUsEnabled {
                let shareUs = Compilation(type: .shareUs, title: nil, collectionList: [])
                compilations.insert(shareUs, at: compilations.isEmpty ? 0 : compilations.count - 1)
            }

            if isSmartFilterAvailable {
                let smartFilter = Compilation(type: .smartFilter, title: nil, collectionList: [])
                compilations.insert(smartFilter, at: 1)
            }

            self.presenter.update(compilations: compilations)
        }
    }

    private func fetchSearchSuggestions() {

        Wines.shared.getRandomWines(count: C.searchSuggestionsCount) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let model):
                self.presenter.update(suggestions: model)

            case .failure:
                break
            }
        }
    }
}

extension VinchyInteractor: VinchyInteractorProtocol {

    func didTapSearchButton(searchText: String?) {

        guard let searchText = searchText else {
            return
        }

        router.pushToDetailCollection(searchText: searchText)
    }

    func didEnterSearchText(_ searchText: String?) {

        guard
            let searchText = searchText,
            !searchText.isEmpty
        else {
            return
        }

        searchWorkItem.perform(after: 0.65) {
            Wines.shared.getWineBy(title: searchText, offset: 0, limit: 40) { [weak self] result in
                switch result {
                case .success(let wines):
                    self?.presenter.update(didFindWines: wines)

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func viewDidLoad() {
        fetchData()
        fetchSearchSuggestions()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dispatchWorkItemHud.perform()
        }
    }

    func didPullToRefresh() {
        fetchData()
    }

    func didTapFilter() {
        router.pushToAdvancedFilterViewController()
    }

    func didTapDidnotFindWineFromSearch(searchText: String?) {

        guard let searchText = searchText else {
            return
        }

        if emailService.canSend {
//            let emailController = emailService.getEmailController(HTMLText: localized("email_did_not_find_wine") + (searchText ?? ""),
//                                                                  recipients: [localized("contact_email")])
//            present(emailController, animated: true, completion: nil)
        } else {
//            showAlert(message: localized("open_mail_error"))
        }
    }
}
