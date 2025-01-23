//
//  ContentView.swift
//  WordGarden
//
//  Created by Richard Gagg on 23/1/2025.
//

import SwiftUI

struct ContentView: View {
  
  @State private var wordsGuessed: Int = 0
  @State private var wordsMissed: Int = 0
  @State private var currentWord: Int = 0
  @State private var guessedLetter: String = ""
  @State private var imageName: String = "flower8"
  @State private var imageNmber: Int = 0
  @State private var playAgainHidden: Bool = true
  
  @State private var gameStatusMessage: String = "How many guesses to uncover the hidden word?"
  
  @State private var wordsToGuess: [String] = [
    "DOG",
    "CAT",
    "BIRD"]
  
  var body: some View {
    VStack {
      //MARK: Game stats
      HStack {
        VStack(alignment: .leading) {
          Text("Words Guessed: \(wordsGuessed)")
          Text("Words Missed: \(wordsMissed)")
        }
        
        Spacer()
        
        VStack(alignment: .trailing) {
          Text("Words to Guess: \(wordsToGuess.count - wordsGuessed - wordsMissed)")
          Text("Words in Game: \(wordsToGuess.count)")
        }
      }
      .font(.headline)
      
      Spacer()
      
      //MARK: Game status message
      Text(gameStatusMessage)
        .font(.title)
        .multilineTextAlignment(.center)
        .padding()
      
      //TODO: Switch to wordsToGuess[currentWord]
      Text("_ _ _ _ _")
        .font(.title)
      
      if playAgainHidden {
        HStack {
          //MARK: Guess letter textfield
          TextField("", text: $guessedLetter)
            .textFieldStyle(.roundedBorder)
            .font(.title)
            .multilineTextAlignment(.center)
            .frame(width: 45)
            .overlay {
              RoundedRectangle(cornerRadius: 12)
                .stroke(.gray, lineWidth: 2)
            }
          
          //MARK: Guess letter button
          Button {
            if imageNmber == 0 {
              playAgainHidden.toggle()
            } else {
              imageNmber -= 1
              imageName = "flower\(imageNmber)"
              guessedLetter = ""
            }
            
          } label: {
            Text("Guess Letter")
              .font(.title2)
          }
          .tint(.green)
          .buttonStyle(.bordered)
          .overlay {
            RoundedRectangle(cornerRadius: 12)
              .stroke(.green, lineWidth: 2)
          }
          .disabled(guessedLetter.isEmpty ? true : false)
          
        }
        .padding(.vertical)
      } else {
        //MARK: Play again button
        Button {
          imageNmber = 8
          playAgainHidden.toggle()
          
        } label: {
          Text("Play Again?")
            .font(.title2)
        }
        .tint(.blue)
        .buttonStyle(.bordered)
        .overlay {
          RoundedRectangle(cornerRadius: 12)
            .stroke(.blue, lineWidth: 2)
        }
        .padding(.vertical)
      }
      
      //MARK: Flower image
      Image(imageName)
        .resizable()
        .scaledToFit()
      
      Spacer()
    }
    .padding(.horizontal)
    .ignoresSafeArea(edges: .bottom)
  }
}

#Preview {
  ContentView()
}
