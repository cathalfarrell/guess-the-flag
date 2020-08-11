//
//  FlagImage.swift
//  GuessTheFlag
//
//  Created by Cathal Farrell on 11/08/2020.
//  Copyright © 2020 Cathal Farrell. All rights reserved.
//

import SwiftUI

/*
 Views & Modifiers - Challege 3
 Go back to project 2 and create a FlagImage() view that renders one flag image using the specific set of modifiers we had.
 */

struct FlagImage: View {
    var name: String
    var body: some View {
        Image(name)
        .renderingMode(.original)
        .clipShape(Capsule()) //make flag capsule shape
        .overlay(Capsule().stroke(Color.black, lineWidth: 1.0)) //Overlay capsule stroke on top
        .shadow(color: .black, radius: 2.0) //Add shadow behiond image
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage(name: "Ireland")
    }
}
