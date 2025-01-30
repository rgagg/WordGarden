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
  @State private var currentWordIndex: Int = 0
  @State private var wordToGuess: String = ""
  @State private var revealedWord: String = ""
  @State private var lettersguessed = "SQFTXW"
  @State private var guessedLetter = ""
  @State private var imageName: String = "flower8"
  @State private var playAgainHidden: Bool = true
  
  @State private var gameStatusMessage: String = "How many guesses to uncover the hidden word?"
  
  @FocusState private var textFieldIsFocused: Bool
  
  private let wordsToGuess: [String] = [
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
      Text(revealedWord)
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
                .stroke(.green, lineWidth: 2)
            }
            .keyboardType(.asciiCapable)
            .submitLabel(.done)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.characters)
            .onChange(of: guessedLetter) {
              guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
              guard let lastCher = guessedLetter.last
              else {
                return
              }
              guessedLetter = String(lastCher).uppercased()
            }
            .onSubmit {
              guard guessedLetter != "" else {
                return
              }
              guessALetter()
            }
            .focused($textFieldIsFocused)
          
          //MARK: Guess letter button
          Button {
            guessALetter()
            
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
    .onAppear {
      wordToGuess = wordsToGuess[currentWordIndex]
      revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
    }
  }
  func guessALetter() {
    textFieldIsFocused = false
    lettersguessed = lettersguessed + guessedLetter
    
    revealedWord = ""
    
    for letter in wordToGuess {
      if lettersguessed.contains(String(letter)) {
        revealedWord = revealedWord + "\(letter) "
      } else {
        revealedWord += "_ "
      }
    }
    
    guessedLetter = ""
  }
}

#Preview {
  ContentView()
}
