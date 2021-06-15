//
//  Example
//  man.li
//
//  Created by man.li on 11/11/2018.
//  Copyright © 2020 man.li. All rights reserved.
//

import UIKit

// MARK: - LogViewController

class LogViewController: UIViewController {

  // MARK: Lifecycle


  deinit {
    //notification
    NotificationCenter.default.removeObserver(self)
  }

  // MARK: Internal


  var reachEndDefault: Bool = true
  var reachEndRN: Bool = true
  var reachEndWeb: Bool = true

  var firstInDefault: Bool = true
  var firstInRN: Bool = true
  var firstInWeb: Bool = true

  var selectedSegmentIndex: Int = 0
  var selectedSegment_0: Bool = false
  var selectedSegment_1: Bool = false
  var selectedSegment_2: Bool = false

  var defaultReloadDataFinish: Bool = true
  var rnReloadDataFinish: Bool = true
  var webReloadDataFinish: Bool = true


  @IBOutlet weak var segmentedControl: UISegmentedControl!
  @IBOutlet weak var deleteItem: UIBarButtonItem!

  @IBOutlet weak var defaultTableView: UITableView!
  @IBOutlet weak var defaultSearchBar: UISearchBar!
  var defaultModels = [_OCLogModel]()
  var defaultCacheModels: [_OCLogModel]?
  var defaultSearchModels: [_OCLogModel]?

  @IBOutlet weak var rnTableView: UITableView!
  @IBOutlet weak var rnSearchBar: UISearchBar!
  var rnModels = [_OCLogModel]()
  var rnCacheModels: [_OCLogModel]?
  var rnSearchModels: [_OCLogModel]?

  @IBOutlet weak var webTableView: UITableView!
  @IBOutlet weak var webSearchBar: UISearchBar!
  var webModels = [_OCLogModel]()
  var webCacheModels: [_OCLogModel]?
  var webSearchModels: [_OCLogModel]?




  //MARK: - tool
  //搜索逻辑
  func searchLogic(_ searchText: String = "") {

    if selectedSegmentIndex == 0
    {
      guard let defaultCacheModels = defaultCacheModels else {return}
      defaultSearchModels = defaultCacheModels

      if searchText == "" {
        defaultModels = defaultCacheModels
      } else {
        guard let defaultSearchModels = defaultSearchModels else {return}

        for _ in defaultSearchModels {
          if
            let index = self.defaultSearchModels?.firstIndex(where: { model -> Bool in
              !model.content.lowercased().contains(searchText.lowercased())//忽略大小写
            })
          {
            self.defaultSearchModels?.remove(at: index)
          }
        }
        defaultModels = self.defaultSearchModels ?? []
      }
    }
    else if selectedSegmentIndex == 1
    {
      guard let rnCacheModels = rnCacheModels else {return}
      rnSearchModels = rnCacheModels

      if searchText == "" {
        rnModels = rnCacheModels
      } else {
        guard let rnSearchModels = rnSearchModels else {return}

        for _ in rnSearchModels {
          if
            let index = self.rnSearchModels?.firstIndex(where: { model -> Bool in
              !model.content.lowercased().contains(searchText.lowercased())//忽略大小写
            })
          {
            self.rnSearchModels?.remove(at: index)
          }
        }
        rnModels = self.rnSearchModels ?? []
      }
    }
    else
    {
      guard let webCacheModels = webCacheModels else {return}
      webSearchModels = webCacheModels

      if searchText == "" {
        webModels = webCacheModels
      } else {
        guard let webSearchModels = webSearchModels else {return}

        for _ in webSearchModels {
          if
            let index = self.webSearchModels?.firstIndex(where: { model -> Bool in
              !model.content.lowercased().contains(searchText.lowercased())//忽略大小写
            })
          {
            self.webSearchModels?.remove(at: index)
          }
        }
        webModels = self.webSearchModels ?? []
      }
    }
  }

  //MARK: - private
  func reloadLogs(needScrollToEnd: Bool = false, needReloadData: Bool = true) {

    if selectedSegmentIndex == 0
    {
      if defaultReloadDataFinish == false {
        return
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) { [weak self] in
        if self?.defaultSearchBar.isHidden == true {
          self?.defaultSearchBar.isHidden = false
        }
      }


      defaultTableView.isHidden = false
      rnTableView.isHidden = true
      webTableView.isHidden = true

      if needReloadData == false && defaultModels.count > 0 {return}

      if let arr = _OCLogStoreManager.shared()?.normalLogArray {
        defaultModels = arr as! [_OCLogModel]
      }

      defaultCacheModels = defaultModels

      searchLogic(CocoaDebugSettings.shared.logSearchWordNormal ?? "")

      dispatch_main_async_safe { [weak self] in
        self?.defaultReloadDataFinish = false
        self?.defaultTableView.reloadData {
          self?.defaultReloadDataFinish = true
        }

        if needScrollToEnd == false {return}

        //table下滑到底部
        guard let count = self?.defaultModels.count else {return}
        if count > 0 {
          guard let firstInDefault = self?.firstInDefault else {return}
          self?.defaultTableView.tableViewScrollToBottom(animated: !firstInDefault)
          self?.firstInDefault = false
        }
      }
    }
    else if selectedSegmentIndex == 1
    {
      if rnReloadDataFinish == false {
        return
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) { [weak self] in
        if self?.rnSearchBar.isHidden == true {
          self?.rnSearchBar.isHidden = false
        }
      }


      defaultTableView.isHidden = true
      rnTableView.isHidden = false
      webTableView.isHidden = true

      if needReloadData == false && rnModels.count > 0 {return}

      if let arr = _OCLogStoreManager.shared()?.rnLogArray {
        rnModels = arr as! [_OCLogModel]
      }

      rnCacheModels = rnModels

      searchLogic(CocoaDebugSettings.shared.logSearchWordRN ?? "")

      dispatch_main_async_safe { [weak self] in
        self?.rnReloadDataFinish = false
        self?.rnTableView.reloadData {
          self?.rnReloadDataFinish = true
        }

        if needScrollToEnd == false {return}

        //table下滑到底部
        guard let count = self?.rnModels.count else {return}
        if count > 0 {
          guard let firstInRN = self?.firstInRN else {return}
          self?.rnTableView.tableViewScrollToBottom(animated: !firstInRN)
          self?.firstInRN = false
        }
      }
    }
    else
    {
      if webReloadDataFinish == false {
        return
      }

      DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) { [weak self] in
        if self?.webSearchBar.isHidden == true {
          self?.webSearchBar.isHidden = false
        }
      }


      defaultTableView.isHidden = true
      rnTableView.isHidden = true
      webTableView.isHidden = false

      if needReloadData == false && webModels.count > 0 {return}

      if let arr = _OCLogStoreManager.shared().webLogArray {
        webModels = arr as! [_OCLogModel]
      }

      webCacheModels = webModels

      searchLogic(CocoaDebugSettings.shared.logSearchWordWeb ?? "")

      dispatch_main_async_safe { [weak self] in
        self?.webReloadDataFinish = false
        self?.webTableView.reloadData {
          self?.webReloadDataFinish = true
        }

        if needScrollToEnd == false {return}

        //table下滑到底部
        guard let count = self?.webModels.count else {return}
        if count > 0 {
          guard let firstInWeb = self?.firstInWeb else {return}
          self?.webTableView.tableViewScrollToBottom(animated: !firstInWeb)
          self?.firstInWeb = false
        }
      }
    }
  }


  //MARK: - init
  override func viewDidLoad() {
    super.viewDidLoad()

    let tap = UITapGestureRecognizer.init(target: self, action: #selector(didTapView))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)


    deleteItem.tintColor = Color.mainGreen
    segmentedControl.tintColor = Color.mainGreen

    if UIScreen.main.bounds.size.width == 320 {
      segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 11)], for: .normal)
    } else {
      segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)], for: .normal)
    }

    //notification
    NotificationCenter.default.addObserver(self, selector: #selector(refreshLogs_notification), name: NSNotification.Name(rawValue: "refreshLogs_CocoaDebug"), object: nil)


    defaultTableView.tableFooterView = UIView()
    defaultTableView.delegate = self
    defaultTableView.dataSource = self
//        defaultTableView.rowHeight = UITableViewAutomaticDimension
    defaultSearchBar.delegate = self
    defaultSearchBar.text = CocoaDebugSettings.shared.logSearchWordNormal
    defaultSearchBar.isHidden = true
    //抖动bug
    defaultTableView.estimatedRowHeight = 0
    defaultTableView.estimatedSectionHeaderHeight = 0
    defaultTableView.estimatedSectionFooterHeight = 0



    rnTableView.tableFooterView = UIView()
    rnTableView.delegate = self
    rnTableView.dataSource = self
//        rnTableView.rowHeight = UITableViewAutomaticDimension
    rnSearchBar.delegate = self
    rnSearchBar.text = CocoaDebugSettings.shared.logSearchWordRN
    rnSearchBar.isHidden = true
    //抖动bug
    rnTableView.estimatedRowHeight = 0
    rnTableView.estimatedSectionHeaderHeight = 0
    rnTableView.estimatedSectionFooterHeight = 0



    webTableView.tableFooterView = UIView()
    webTableView.delegate = self
    webTableView.dataSource = self
//        webTableView.rowHeight = UITableViewAutomaticDimension
    webSearchBar.delegate = self
    webSearchBar.text = CocoaDebugSettings.shared.logSearchWordWeb
    webSearchBar.isHidden = true
    //抖动bug
    webTableView.estimatedRowHeight = 0
    webTableView.estimatedSectionHeaderHeight = 0
    webTableView.estimatedSectionFooterHeight = 0



    //segmentedControl
    selectedSegmentIndex = CocoaDebugSettings.shared.logSelectIndex
    segmentedControl.selectedSegmentIndex = selectedSegmentIndex

    if selectedSegmentIndex == 0 {
      selectedSegment_0 = true
    } else if selectedSegmentIndex == 1 {
      selectedSegment_1 = true
    } else {
      selectedSegment_2 = true
    }

    reloadLogs(needScrollToEnd: true, needReloadData: true)



    //hide searchBar icon
    let textFieldInsideSearchBar = defaultSearchBar.value(forKey: "searchField") as! UITextField
    textFieldInsideSearchBar.leftViewMode = .never
    textFieldInsideSearchBar.leftView = nil
    textFieldInsideSearchBar.backgroundColor = .white
    textFieldInsideSearchBar.returnKeyType = .default

    let textFieldInsideSearchBar2 = rnSearchBar.value(forKey: "searchField") as! UITextField
    textFieldInsideSearchBar2.leftViewMode = .never
    textFieldInsideSearchBar2.leftView = nil
    textFieldInsideSearchBar2.backgroundColor = .white
    textFieldInsideSearchBar2.returnKeyType = .default

    let textFieldInsideSearchBar3 = webSearchBar.value(forKey: "searchField") as! UITextField
    textFieldInsideSearchBar3.leftViewMode = .never
    textFieldInsideSearchBar3.leftView = nil
    textFieldInsideSearchBar3.backgroundColor = .white
    textFieldInsideSearchBar3.returnKeyType = .default
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    defaultSearchBar.resignFirstResponder()
    rnSearchBar.resignFirstResponder()
    webSearchBar.resignFirstResponder()
  }

  //MARK: - target action
  @IBAction
  func didTapDown(_ sender: Any) {
    if selectedSegmentIndex == 0
    {
      defaultTableView.tableViewScrollToBottom(animated: true)
      defaultSearchBar.resignFirstResponder()
      reachEndDefault = true
    }
    else if selectedSegmentIndex == 1
    {
      rnTableView.tableViewScrollToBottom(animated: true)
      rnSearchBar.resignFirstResponder()
      reachEndRN = true
    }
    else
    {
      webTableView.tableViewScrollToBottom(animated: true)
      webSearchBar.resignFirstResponder()
      reachEndWeb = true
    }
  }

  @IBAction
  func didTapUp(_ sender: Any) {
    if selectedSegmentIndex == 0
    {
      defaultTableView.tableViewScrollToHeader(animated: true)
      defaultSearchBar.resignFirstResponder()
      reachEndDefault = false
    }
    else if selectedSegmentIndex == 1
    {
      rnTableView.tableViewScrollToHeader(animated: true)
      rnSearchBar.resignFirstResponder()
      reachEndRN = false
    }
    else
    {
      webTableView.tableViewScrollToHeader(animated: true)
      webSearchBar.resignFirstResponder()
      reachEndWeb = false
    }
  }


  @IBAction
  func resetLogs(_ sender: Any) {
    if selectedSegmentIndex == 0
    {
      defaultModels = []
      defaultCacheModels = []
//            defaultSearchBar.text = nil
      defaultSearchBar.resignFirstResponder()
//            CocoaDebugSettings.shared.logSearchWordNormal = nil

      _OCLogStoreManager.shared()?.resetNormalLogs()

      dispatch_main_async_safe { [weak self] in
        self?.defaultTableView.reloadData()
      }
    }
    else if selectedSegmentIndex == 1
    {
      rnModels = []
      rnCacheModels = []
//            rnSearchBar.text = nil
      rnSearchBar.resignFirstResponder()
//            CocoaDebugSettings.shared.logSearchWordRN = nil

      _OCLogStoreManager.shared()?.resetRNLogs()

      dispatch_main_async_safe { [weak self] in
        self?.rnTableView.reloadData()
      }
    }
    else
    {
      webModels = []
      webCacheModels = []
//            webSearchBar.text = nil
      webSearchBar.resignFirstResponder()
//            CocoaDebugSettings.shared.logSearchWordWeb = nil

      _OCLogStoreManager.shared().resetWebLogs()

      dispatch_main_async_safe { [weak self] in
        self?.webTableView.reloadData()
      }
    }
  }

  @IBAction
  func segmentedControlAction(_ sender: UISegmentedControl) {
    selectedSegmentIndex = segmentedControl.selectedSegmentIndex
    CocoaDebugSettings.shared.logSelectIndex = selectedSegmentIndex

    if selectedSegmentIndex == 0 {
      rnSearchBar.resignFirstResponder()
      webSearchBar.resignFirstResponder()
    } else if selectedSegmentIndex == 1 {
      defaultSearchBar.resignFirstResponder()
      webSearchBar.resignFirstResponder()
    } else {
      defaultSearchBar.resignFirstResponder()
      rnSearchBar.resignFirstResponder()
    }

    if selectedSegmentIndex == 0 && selectedSegment_0 == false {
      selectedSegment_0 = true
      reloadLogs(needScrollToEnd: true, needReloadData: true)
      return
    }

    if selectedSegmentIndex == 1 && selectedSegment_1 == false {
      selectedSegment_1 = true
      reloadLogs(needScrollToEnd: true, needReloadData: true)
      return
    }

    if selectedSegmentIndex == 2 && selectedSegment_2 == false {
      selectedSegment_2 = true
      reloadLogs(needScrollToEnd: true, needReloadData: true)
      return
    }

    reloadLogs(needScrollToEnd: false, needReloadData: false)
  }

  @objc
  func didTapView() {
    if selectedSegmentIndex == 0 {
      defaultSearchBar.resignFirstResponder()
    } else if selectedSegmentIndex == 1 {
      rnSearchBar.resignFirstResponder()
    } else {
      webSearchBar.resignFirstResponder()
    }
  }


  //MARK: - notification
  @objc
  func refreshLogs_notification() {
    dispatch_main_async_safe { [weak self] in
      if self?.selectedSegmentIndex == 0 {
        self?.reloadLogs(needScrollToEnd: self?.reachEndDefault ?? true, needReloadData: true)
      } else if self?.selectedSegmentIndex == 1 {
        self?.reloadLogs(needScrollToEnd: self?.reachEndRN ?? true, needReloadData: true)
      } else {
        self?.reloadLogs(needScrollToEnd: self?.reachEndWeb ?? true, needReloadData: true)
      }
    }
  }
}

// MARK: UITableViewDataSource

//MARK: - UITableViewDataSource
extension LogViewController: UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if tableView == defaultTableView {
      return defaultModels.count
    } else if tableView == rnTableView {
      return rnModels.count
    } else {
      return webModels.count
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "LogCell", for: indexPath) as! LogCell

    if tableView == defaultTableView
    {
      //Otherwise occasionally crash
      if indexPath.row >= defaultModels.count {
        return UITableViewCell()
      }

      cell.model = defaultModels[indexPath.row]
    }
    else if tableView == rnTableView
    {
      //Otherwise occasionally crash
      if indexPath.row >= rnModels.count {
        return UITableViewCell()
      }

      cell.model = rnModels[indexPath.row]
    }
    else
    {
      //Otherwise occasionally crash
      if indexPath.row >= webModels.count {
        return UITableViewCell()
      }

      cell.model = webModels[indexPath.row]
    }

    return cell
  }
}

// MARK: UITableViewDelegate

//MARK: - UITableViewDelegate
extension LogViewController: UITableViewDelegate {

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    var logTitleString = ""
    var models_: [_OCLogModel]?

    if tableView == defaultTableView
    {
      defaultSearchBar.resignFirstResponder()
      reachEndDefault = false
      logTitleString = "Log"
      models_ = defaultModels
    }
    else if tableView == rnTableView
    {
      rnSearchBar.resignFirstResponder()
      reachEndRN = false
      logTitleString = "RN"
      models_ = rnModels
    }
    else
    {
      webSearchBar.resignFirstResponder()
      reachEndWeb = false
      logTitleString = "Web"
      models_ = webModels
    }

    //
    guard let models = models_ else {return}

    let vc = JsonViewController.instanceFromStoryBoard()
    vc.editType = .log
    vc.logTitleString = logTitleString
    vc.logModels = models
    vc.logModel = models[indexPath.row]

    navigationController?.pushViewController(vc, animated: true)

    vc.justCancelCallback = {
      tableView.reloadData()
    }
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

    var model: _OCLogModel

    if tableView == defaultTableView {
      model = defaultModels[indexPath.row]
    } else if tableView == rnTableView {
      model = rnModels[indexPath.row]
    } else {
      model = webModels[indexPath.row]
    }


    if let height = model.str?.height(with: UIFont.boldSystemFont(ofSize: 12), constraintToWidth: UIScreen.main.bounds.size.width) {
      return (height + 10) > 5000 ? 5000 : (height + 10)
    }

    return 0
  }


  @available(iOS 11.0, *)
  func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    if tableView == defaultTableView
    {
      let model = defaultModels[indexPath.row]
      var title = "Tag"
      if model.isTag == true {title = "UnTag"}

      let left = UIContextualAction(style: .normal, title: title) { [weak self] action, sourceView, completionHandler in
        model.isTag = !model.isTag
        self?.dispatch_main_async_safe { [weak self] in
          self?.defaultTableView.reloadData()
        }
        completionHandler(true)
      }

      defaultSearchBar.resignFirstResponder()
      left.backgroundColor = "#007aff".hexColor
      return UISwipeActionsConfiguration(actions: [left])
    }
    else if tableView == rnTableView
    {
      let model = rnModels[indexPath.row]
      var title = "Tag"
      if model.isTag == true {title = "UnTag"}

      let left = UIContextualAction(style: .normal, title: title) { [weak self] action, sourceView, completionHandler in
        model.isTag = !model.isTag
        self?.dispatch_main_async_safe { [weak self] in
          self?.rnTableView.reloadData()
        }
        completionHandler(true)
      }

      rnSearchBar.resignFirstResponder()
      left.backgroundColor = "#007aff".hexColor
      return UISwipeActionsConfiguration(actions: [left])
    }
    else
    {
      let model = webModels[indexPath.row]
      var title = "Tag"
      if model.isTag == true {title = "UnTag"}

      let left = UIContextualAction(style: .normal, title: title) { [weak self] action, sourceView, completionHandler in
        model.isTag = !model.isTag
        self?.dispatch_main_async_safe { [weak self] in
          self?.webTableView.reloadData()
        }
        completionHandler(true)
      }

      webSearchBar.resignFirstResponder()
      left.backgroundColor = "#007aff".hexColor
      return UISwipeActionsConfiguration(actions: [left])
    }
  }

  @available(iOS 11.0, *)
  func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
    if tableView == defaultTableView
    {
      let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, sourceView, completionHandler in
        guard let models = self?.defaultModels else {return}

        let model: _OCLogModel = models[indexPath.row]
        _OCLogStoreManager.shared().removeLog(model)

        self?.defaultModels.remove(at: indexPath.row)
        _ = self?.defaultCacheModels?.firstIndex(of: model).map { self?.defaultCacheModels?.remove(at: $0) }
        _ = self?.defaultSearchModels?.firstIndex(of: model).map { self?.defaultSearchModels?.remove(at: $0) }

        self?.dispatch_main_async_safe { [weak self] in
          self?.defaultTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        completionHandler(true)
      }

      defaultSearchBar.resignFirstResponder()
      return UISwipeActionsConfiguration(actions: [delete])
    }
    else if tableView == rnTableView
    {
      let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, sourceView, completionHandler in
        guard let models = self?.rnModels else {return}

        let model: _OCLogModel = models[indexPath.row]
        _OCLogStoreManager.shared().removeLog(model)

        self?.rnModels.remove(at: indexPath.row)
        _ = self?.rnCacheModels?.firstIndex(of: model).map { self?.rnCacheModels?.remove(at: $0) }
        _ = self?.rnSearchModels?.firstIndex(of: model).map { self?.rnSearchModels?.remove(at: $0) }

        self?.dispatch_main_async_safe { [weak self] in
          self?.rnTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        completionHandler(true)
      }

      rnSearchBar.resignFirstResponder()
      return UISwipeActionsConfiguration(actions: [delete])
    }
    else
    {
      let delete = UIContextualAction(style: .destructive, title: "Delete") { [weak self] action, sourceView, completionHandler in
        guard let models = self?.webModels else {return}

        let model: _OCLogModel = models[indexPath.row]
        _OCLogStoreManager.shared().removeLog(model)

        self?.webModels.remove(at: indexPath.row)
        _ = self?.webCacheModels?.firstIndex(of: model).map { self?.webCacheModels?.remove(at: $0) }
        _ = self?.webSearchModels?.firstIndex(of: model).map { self?.webSearchModels?.remove(at: $0) }

        self?.dispatch_main_async_safe { [weak self] in
          self?.webTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        completionHandler(true)
      }

      webSearchBar.resignFirstResponder()
      return UISwipeActionsConfiguration(actions: [delete])
    }
  }

  //MARK: - only for ios8/ios9/ios10, not ios11
  func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    .delete
  }
  func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
    "Delete"
  }
  func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    true
  }
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if tableView == defaultTableView
    {
      if editingStyle == .delete {

        let model: _OCLogModel = defaultModels[indexPath.row]
        _OCLogStoreManager.shared().removeLog(model)

        defaultModels.remove(at: indexPath.row)
        _ = defaultCacheModels?.firstIndex(of: model).map { self.defaultCacheModels?.remove(at: $0) }
        _ = defaultSearchModels?.firstIndex(of: model).map { self.defaultSearchModels?.remove(at: $0) }

        dispatch_main_async_safe { [weak self] in
          self?.defaultTableView.deleteRows(at: [indexPath], with: .automatic)
        }
      }
    }
    else if tableView == rnTableView
    {
      if editingStyle == .delete {

        let model: _OCLogModel = rnModels[indexPath.row]
        _OCLogStoreManager.shared().removeLog(model)

        rnModels.remove(at: indexPath.row)
        _ = rnCacheModels?.firstIndex(of: model).map { self.rnCacheModels?.remove(at: $0) }
        _ = rnSearchModels?.firstIndex(of: model).map { self.rnSearchModels?.remove(at: $0) }

        dispatch_main_async_safe { [weak self] in
          self?.rnTableView.deleteRows(at: [indexPath], with: .automatic)
        }
      }
    }
    else
    {
      if editingStyle == .delete {

        let model: _OCLogModel = webModels[indexPath.row]
        _OCLogStoreManager.shared().removeLog(model)

        webModels.remove(at: indexPath.row)
        _ = webCacheModels?.firstIndex(of: model).map { self.webCacheModels?.remove(at: $0) }
        _ = webSearchModels?.firstIndex(of: model).map { self.webSearchModels?.remove(at: $0) }

        dispatch_main_async_safe { [weak self] in
          self?.webTableView.deleteRows(at: [indexPath], with: .automatic)
        }
      }
    }
  }
}

// MARK: UIScrollViewDelegate

//MARK: - UIScrollViewDelegate
extension LogViewController: UIScrollViewDelegate {

  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    if scrollView == defaultTableView {
      defaultSearchBar.resignFirstResponder()
    } else if scrollView == rnTableView {
      rnSearchBar.resignFirstResponder()
    } else {
      webSearchBar.resignFirstResponder()
    }
  }

  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    if scrollView == defaultTableView {
      reachEndDefault = false
    } else if scrollView == rnTableView {
      reachEndRN = false
    } else {
      reachEndWeb = false
    }
  }
}

// MARK: UISearchBarDelegate

//MARK: - UISearchBarDelegate
extension LogViewController: UISearchBarDelegate {

  func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
  {
    searchBar.resignFirstResponder()
  }

  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
  {
    if searchBar == defaultSearchBar
    {
      CocoaDebugSettings.shared.logSearchWordNormal = searchText
      searchLogic(searchText)

      dispatch_main_async_safe { [weak self] in
        self?.defaultTableView.reloadData()
      }
    }
    else if searchBar == rnSearchBar
    {
      CocoaDebugSettings.shared.logSearchWordRN = searchText
      searchLogic(searchText)

      dispatch_main_async_safe { [weak self] in
        self?.rnTableView.reloadData()
      }
    }
    else
    {
      CocoaDebugSettings.shared.logSearchWordWeb = searchText
      searchLogic(searchText)

      dispatch_main_async_safe { [weak self] in
        self?.webTableView.reloadData()
      }
    }
  }
}
