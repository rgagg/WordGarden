//
//  ContentView.swift
//  WordGarden
//
//  Created by Richard Gagg on 23/1/2025.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
  
  @State private var wordsGuessed: Int = 0
  @State private var wordsMissed: Int = 0
  @State private var currentWordIndex: Int = 0
  @State private var wordToGuess: String = ""
  @State private var revealedWord: String = ""
  @State private var lettersguessed = ""
  @State private var guessedLetter = ""
  @State private var guessesRemaining: Int = 8
  @State private var imageName: String = "flower8"
  @State private var playAgainHidden: Bool = true
  @State private var playAgainButtonTitle: String = "Another Word?"
  
  @State private var soundName: String = ""
  @State private var audioPlayer: AVAudioPlayer!
  
  @State private var gameStatusMessage: String = "How many guesses to uncover the hidden word?"
  
  @FocusState private var textFieldIsFocused: Bool
  
  private let maximumGuesses: Int = 8
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
        .frame(height: 80)
        .minimumScaleFactor(0.5)
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
              updateGamePlay()
            }
            .focused($textFieldIsFocused)
          
          //MARK: Guess letter button
          Button {
            guessALetter()
            updateGamePlay()
            
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
          playAgainButtonTitle == "Start Over?" ? restartGame() : playAgain()
          
        } label: {
          Text(playAgainButtonTitle)
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
      guessesRemaining = maximumGuesses
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
  }
  
  func updateGamePlay() {
    if !wordToGuess.contains(guessedLetter) {
      guessesRemaining -= 1
      imageName = "flower\(guessesRemaining)"
      playSound(soundName: "incorrect")
    } else {
      playSound(soundName: "correct")
    }
    
    if !revealedWord.contains("_") {
      // Word guessed
      playSound(soundName: "word-guessed")
      gameStatusMessage = "You guessed the hidden word \(wordToGuess) in \(lettersguessed.count) guesses!"
      wordsGuessed += 1
      currentWordIndex += 1
      playAgainHidden = false
    } else if guessesRemaining == 0 {
      // Word not guessed
      playSound(soundName: "word-not-guessed")
      gameStatusMessage = "The hidden word was \(wordToGuess).\nBetter luck next time!"
      wordsMissed += 1
      currentWordIndex += 1
      playAgainHidden = false
    } else {
      // Keep guessing
      gameStatusMessage = "You have made \(lettersguessed.count) \(lettersguessed.count > 1 ? "guesses." : "guess.")"
    }
    guessedLetter = ""
    
    if currentWordIndex == wordsToGuess.count {
      playAgainButtonTitle = "Start Over?"
      gameStatusMessage = gameStatusMessage + "\nAll words played. Restart game?"
    }
  }
  
  func playAgain() {
    wordToGuess = wordsToGuess[currentWordIndex]
    revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
    lettersguessed = ""
    guessesRemaining = maximumGuesses
    gameStatusMessage = "How many guesses to uncover the hidden word?"
    imageName = "flower\(guessesRemaining)"
    playAgainHidden = true
  }
  
  func restartGame() {
    currentWordIndex = 0
    wordsGuessed = 0
    wordsMissed = 0
    playAgainButtonTitle = "Another Word?"
    playAgain()
  }
  
  func playSound(soundName: String) {
    
    guard let soundFile = NSDataAsset(name: soundName) else
    {
      print("🤬 Could not read file named \(soundName).")
      return
    }
    
    do {
      audioPlayer = try AVAudioPlayer(data: soundFile.data)
      audioPlayer.play()
    } catch {
      print("🤬 ERROR: \(error.localizedDescription) creating audioPlayer")
    }
  }
}

#Preview {
  ContentView()
}
