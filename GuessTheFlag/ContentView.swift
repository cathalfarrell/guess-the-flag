//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Cathal Farrell on 26/03/2020.
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

struct ContentView: View {

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
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .padding(.horizontal)
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
