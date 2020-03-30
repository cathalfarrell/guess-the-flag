//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Cathal Farrell on 26/03/2020.
//  Copyright © 2020 Cathal Farrell. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()

    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0

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
                }

                //Show three flags
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        //Flag button was tapped
                        self.flagTapped(number)
                    }){

                        Image(self.countries[number])
                            .renderingMode(.original)
                            .clipShape(Capsule()) //make flag capsule shape
                            .overlay(Capsule().stroke(Color.black, lineWidth: 1.0)) //Overlay capsule stroke on top
                            .shadow(color: .black, radius: 2.0) //Add shadow behiond image

                    }
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
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 1
        } else {
            scoreTitle = "Wrong, that's the flag of \(countries[number])!"
        }

        showingScore = true
    }

    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
