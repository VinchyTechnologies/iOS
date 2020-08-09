//
//  LocationSearchTable.swift
//  Smart
//
//  Created by Aleksei Smirnov on 04.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit
import MapKit
import Display

//final class LocationSearchTable: UITableViewController {
//
//
//    weak var handleMapSearchDelegate: HandleMapSearch?
//    var matchingItems: [MKMapItem] = []
//    var mapView: MKMapView?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 10))
//    }
//
//
//    func parseAddress(selectedItem: MKPlacemark) -> String {
//
//        // put a space between "4" and "Melrose Place"
//        let firstSpace = (selectedItem.subThoroughfare != nil &&
//                            selectedItem.thoroughfare != nil) ? " " : ""
//
//        // put a comma between street and city/state
//        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) &&
//                    (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
//
//        // put a space between "Washington" and "DC"
//        let secondSpace = (selectedItem.subAdministrativeArea != nil &&
//                            selectedItem.administrativeArea != nil) ? " " : ""
//
//        let addressLine = String(
//            format:"%@%@%@%@%@%@%@",
//            // street number
//            selectedItem.subThoroughfare ?? "",
//            firstSpace,
//            // street name
//            selectedItem.thoroughfare ?? "",
//            comma,
//            // city
//            selectedItem.locality ?? "",
//            secondSpace,
//            // state
//            selectedItem.administrativeArea ?? ""
//        )
//
//        return addressLine
//    }
//
//}
//
//extension LocationSearchTable : UISearchResultsUpdating {
//    func updateSearchResults(for searchController: UISearchController) {
//        guard let mapView = mapView,
//            let searchBarText = searchController.searchBar.text else { return }
//
//        let request = MKLocalSearch.Request()
//        request.naturalLanguageQuery = searchBarText
//        request.region = mapView.region
//        let search = MKLocalSearch(request: request)
//
//        search.start { response, _ in
//            guard let response = response else { return }
//            self.matchingItems = response.mapItems
//            self.tableView.reloadData()
//        }
//    }
//}
//
//extension LocationSearchTable {
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return matchingItems.count
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
//        let selectedItem = matchingItems[indexPath.row].placemark
//        cell.textLabel?.text = selectedItem.name
//        cell.textLabel?.font = Font.regular(14)
//        cell.detailTextLabel?.text = parseAddress(selectedItem: selectedItem)
//        cell.setNeedsLayout()
//        return cell
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedItem = matchingItems[indexPath.row].placemark
//        handleMapSearchDelegate?.dropPinZoomIn(placemark: selectedItem,
//                                               address: parseAddress(selectedItem: selectedItem))
//        dismiss(animated: true, completion: nil)
//    }
//
//}
