//
//  CircleImageView.swift
//  Landmarks
//
//  Created by Clinton Maciel on 26/06/20.
//  Copyright © 2020 Clinton. All rights reserved.
//

import SwiftUI

struct CircleImageView: View {
    var body: some View {
        Image("turtlerock")
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            .shadow(radius: 10)
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircleImageView()
    }
}
