//
//  StoreRepositoryAdapterProtocol.swift
//  VinchyUI
//
//  Created by Алексей Смирнов on 28.04.2022.
//  Copyright © 2022 Aleksei Smirnov. All rights reserved.
//

public protocol StoreRepositoryAdapterProtocol: AnyObject {
  
  func isLiked(affilietedId: Int) -> Bool
  
  func saveOrDeleteStoreFromFavourite(
    affilietedId: Int,
    title: String?,
    address: String?,
    logoURL: String?,
    completion: (Bool) -> Void)
}
