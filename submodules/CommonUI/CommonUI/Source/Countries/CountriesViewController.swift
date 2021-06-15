//
//  CountriesViewController.swift
//  CommonUI
//
//  Created by Aleksei Smirnov on 15.09.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Core
import Display
import StringFormatting
import UIKit

// MARK: - CountryModel

struct CountryModel {
  let firstLetter: Character?
  let countryName: String?
  let countryCode: String
}

// MARK: - CountrySectionModel

struct CountrySectionModel {
  let sectionName: String
  let countries: [CountryModel]
}

// MARK: - CountriesViewControllerDelegate

public protocol CountriesViewControllerDelegate: AnyObject {
  func didChoose(countryCodes: [String])
}

// MARK: - CountriesViewController

public final class CountriesViewController: UIViewController {

  // MARK: Lifecycle

  public init(preSelectedCountryCodes: [String], delegate: CountriesViewControllerDelegate?) {
    isInitiallyEmpty = preSelectedCountryCodes.isEmpty
    super.init(nibName: nil, bundle: nil)
    selectedCountryCodes = preSelectedCountryCodes
    self.delegate = delegate
  }

  @available(*, unavailable)
  required init?(coder _: NSCoder) { fatalError() }

  // MARK: Public

  override public func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.title = localized("сhoose_countries").firstLetterUppercased()
    navigationItem.largeTitleDisplayMode = .never
    view.backgroundColor = .mainBackground

    view.addSubview(tableView)
    tableView.fill()

    fetchCountries()
    let imageConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold, scale: .default)
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark", withConfiguration: imageConfig), style: .plain, target: self, action: #selector(closeSelf))

    searchButton.setTitle(localized("choose").firstLetterUppercased(), for: .normal)
    searchButton.titleLabel?.font = Font.bold(18)
    searchButton.backgroundColor = .accent
    searchButton.layer.cornerRadius = 24
    searchButton.clipsToBounds = true
    searchButton.addTarget(self, action: #selector(didTapChoose), for: .touchUpInside)

    view.addSubview(searchButton)
    searchButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      searchButton.heightAnchor.constraint(equalToConstant: 48),
      searchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
    ])

    searchButton.isHidden = isInitiallyEmpty
  }

  // MARK: Internal

  weak var delegate: CountriesViewControllerDelegate?

  // MARK: Private

  private lazy var searchButton = UIButton(frame: CGRect(x: 20, y: view.bounds.height, width: view.bounds.width - 40, height: 48))

  private var isButtonShown = false

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.reuseId)
    tableView.sectionIndexColor = .dark
    tableView.separatorInset = .init(top: 0, left: 20, bottom: 0, right: 0)
    tableView.tableFooterView = UIView(frame: .init(x: 0, y: 0, width: 0, height: 58))

    return tableView
  }()

  private let isInitiallyEmpty: Bool

  private var selectedCountryCodes: [String] = [] {
    didSet {
      if !selectedCountryCodes.isEmpty {
        if !isButtonShown {
          showButton(animated: true)
        }
      } else {
        if isButtonShown, isInitiallyEmpty {
          hideButton()
        }
      }
    }
  }

  private var countriesModels: [CountrySectionModel] = [] {
    didSet {
      tableView.reloadData()
    }
  }

  private func fetchCountries() {
    let countryCodes = loadCountryCodes()

    let countriesModels = countryCodes.compactMap { code -> CountryModel? in
      let name = countryNameFromLocaleCode(countryCode: code.code)
      return CountryModel(firstLetter: name?.first, countryName: name, countryCode: code.code)
    }

    let groupped = countriesModels.grouped(map: { $0.firstLetter })

    self.countriesModels = groupped.compactMap { model -> CountrySectionModel? in
      guard let firstLetter = model.first?.firstLetter, !model.isEmpty else { return nil }
      return CountrySectionModel(sectionName: String(firstLetter), countries: model)
    }.sorted(by: { $0.sectionName < $1.sectionName })
  }

  @objc
  private func closeSelf() {
    dismiss(animated: true, completion: nil)
  }

  @objc
  private func didTapChoose() {
    dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
      self.delegate?.didChoose(countryCodes: self.selectedCountryCodes)
    }
  }

  private func showButton(animated _: Bool) {
    isButtonShown = true
    searchButton.isHidden = false
  }

  private func hideButton() {
    isButtonShown = false
    searchButton.isHidden = true
  }
}

// MARK: UITableViewDataSource

extension CountriesViewController: UITableViewDataSource {
  public func numberOfSections(in _: UITableView) -> Int {
    countriesModels.count
  }

  public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
    countriesModels[section].countries.count
  }

  public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // swiftlint:disable:next force_cast
    let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.reuseId) as! CountryTableViewCell
    let country = countriesModels[indexPath.section].countries[indexPath.row]
    cell.decorate(model: .init(
      flagImage: UIImage(named: country.countryCode),
      titleText: country.countryName,
      isCheckBoxed: selectedCountryCodes.contains(country.countryCode)))
    return cell
  }

  public func sectionIndexTitles(for _: UITableView) -> [String]? {
    countriesModels.compactMap { $0.sectionName }
  }

  public func tableView(_: UITableView, sectionForSectionIndexTitle title: String, at _: Int) -> Int {
    countriesModels.firstIndex(where: { $0.sectionName == title }) ?? 0
  }
}

// MARK: UITableViewDelegate

extension CountriesViewController: UITableViewDelegate {
  public func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
    60
  }

  public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if selectedCountryCodes.contains(countriesModels[indexPath.section].countries[indexPath.row].countryCode) {
      selectedCountryCodes.removeAll(where: { $0 == countriesModels[indexPath.section].countries[indexPath.row].countryCode })
    } else {
      selectedCountryCodes.append(countriesModels[indexPath.section].countries[indexPath.row].countryCode)
    }

    tableView.reloadRows(at: [indexPath], with: .none)
  }
}
