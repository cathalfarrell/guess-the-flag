//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Cathal Farrell on 26/03/2020.
//  Copyright © 2020 Cathal Farrell. All rights reserved.
//

import SwiftUI

struct LargeLabel: ViewModifier {

    // system font, size 24 and semibold
    let font = Font.system(size: 30).weight(.black)

    func body(content: Content) -> some View {
        content
        .foregroundColor(.white)
        .font(font)
        .padding(.horizontal)
    }
}

struct ContentView: View {

    // MARK: - Accessibility
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()

    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0

    //Animations
    @State private var opacities = [ 1.0, 1.0, 1.0 ]
    @State private var rotations = [ 0.0, 0.0, 0.0 ]
    @State private var scales: [CGFloat] = [ 1.0, 1.0, 1.0 ]

    var isNewGame: Bool {
        //As we set these for a new game - it's a way to know if we are starting or not
        return (opacities == [ 1.0, 1.0, 1.0 ] && rotations == [ 0.0, 0.0, 0.0 ])
    }


    fileprivate func updateOpactity(index: Int) {
        // Animation Challenge - Make the other two buttons fade out to 25% opacity.
        var updateOpactity = [0.25, 0.25, 0.25]
        updateOpactity[index] = 1.0
        self.opacities = updateOpactity
    }

    fileprivate func updateRotations(index: Int) {
        // Animation Challenge - Make the other two buttons fade out to 25% opacity.
        var updateRotations = [0.0, 0.0, 0.0]
        updateRotations[index] = 360.0
        self.rotations = updateRotations // update trigger state change -> animates
    }

    fileprivate func updateScales(index: Int) {
        // Animation Challenge - Make the other two buttons fade out to 25% opacity.
        var updateScales: [CGFloat] = [1.0, 1.0, 1.0]
        updateScales[index] = 1.5
        self.scales = updateScales // update trigger state change -> animates
    }

    var body: some View {
        ZStack {
            //Color.blue.edgesIgnoringSafeArea(.all)
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30.0) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                    .modifier(LargeLabel())
                }

                //Show three flags
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        //Flag button was tapped
                        self.flagTapped(number)
                    }){

                        /* Original
                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule()) //make flag capsule shape
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1.0)) //Overlay capsule stroke on top
                            .shadow(color: .black, radius: 2.0) //Add shadow behiond image
                         */

                        //Custom Image
                        FlagImage(name: self.countries[number])
                        .opacity(self.opacities[number])
                        // Animation Challenge 1
                        // When you tap the correct flag, make it spin around 360 degrees on the Y axis.
                        .rotation3DEffect(.degrees(self.rotations[number]), axis: (x: 0, y: 1, z: 0))
                        .scaleEffect(self.scales[number])
                        .accessibility(label: Text(self.labels[self.countries[number], default: "Unknown flag"]))
                    }
                    //Want to ensure that animation doesnt run - i.e backwards when starting new game
                    .animation(self.isNewGame ? nil : .default)
                }

                Text("You Current Score Is: \(score)")
                    .foregroundColor(.white)

                //Shove it up by putting spacer in
                Spacer()
            }
        }.alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text("Your score is: \(score)"), dismissButton: .default(Text("Continue"), action: {
                    self.askQuestion()
            }))
        }
    }

    func flagTapped(_ number: Int) {

        //Animation if correct
        if number == self.correctAnswer {
            self.updateOpactity(index: number)
            self.updateRotations(index: number)
        } else {
            //Animation if wrong
            self.updateScales(index: number)
        }

        //Alert - Add a delay so that alert doesn't cover flag animation
        let _ = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { timer in
            if number == self.correctAnswer {
                self.scoreTitle = "Correct"
                self.score += 1
          } else {
                self.scoreTitle = "Wrong, that's the flag of \(self.countries[number])!"
          }
            self.showingScore = true //triggers alert state change
        })
    }

    func askQuestion() {
        opacities = [ 1.0, 1.0, 1.0 ]
        rotations = [ 0.0, 0.0, 0.0 ]
        scales = [ 1.0, 1.0, 1.0 ]
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
