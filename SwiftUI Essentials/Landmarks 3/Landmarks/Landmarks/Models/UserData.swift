//
//  UserDate.swift
//  Landmarks
//
//  Created by Clinton Maciel on 26/06/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import SwiftUI
import Combine

final class UserData: ObservableObject {
    @Published var showFavoritesOnly = false
    @Published var landmarks = landmarkData
}
