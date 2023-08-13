// You should randomly generate as many questions as they asked for, within the difficulty range they asked for.

import SwiftUI

struct ContentView: View {
    @State private var tablesNumber = 2
    @State private var numberOfQuestions = 5
    
    @State private var questionsAsked = 0
    @State private var questionsCorrect = 0
    @State private var questionNumber = 2
    
    @State private var activeAnswers = [1, 2, 3, 4]
    @State private var playerAnswer = 1
    
    @State private var gameIsRunning = false
    @State private var gameOver = false
    @State private var playerConfirmedChoice = false
    @State private var result = "..."
    
    let numberOfQuestionsOptions = [5, 10, 20]
    let numbers = 2...12
    let answers = 2...144
    
    func startGame() {
        if gameIsRunning {
            activeAnswers = [1, 2, 3, 4]
        } else {
            getNumber()
            getAnswers()
        }
        gameIsRunning.toggle()
    }
    
    func getNumber() {
        questionNumber = numbers.randomElement()!
        result = "..."
        questionsAsked += 1
        
        if questionsAsked > numberOfQuestions {
            gameOver = true
        }
    }
    
    func getAnswers() {
        var usedAnswers = [Int]()
        usedAnswers.append(tablesNumber * questionNumber)
        
        while usedAnswers.count < 4 {
            if let newAnswer = answers.randomElement() {
                if !usedAnswers.contains(newAnswer) {
                    usedAnswers.append(newAnswer)
                }
            }
        }
        
        activeAnswers = usedAnswers.shuffled()
    }
    
    func confirm() {
        if playerConfirmedChoice {
            playerConfirmedChoice = false
            getNumber()
            getAnswers()
            return
        }
        
        let correctAnswer = tablesNumber * questionNumber
        playerConfirmedChoice = true
        if playerAnswer == correctAnswer {
            result = "CORRECT!"
            questionsCorrect += 1
        } else {
            result = "That's not correct. The answer is \(correctAnswer)"
        }
    }
    
    func resetGame() {
        gameIsRunning = false
        questionsAsked = 0
        questionsCorrect = 0
        result = "..."
    }
    
    var body: some View {
        Form {
            Section {
                Stepper("\(tablesNumber)'s tables", value: $tablesNumber, in: 2...12)
            } header: {
                Text("Multiplication table group")
            }
            
            Section {
                Picker("Number of questions", selection: $numberOfQuestions) {
                    ForEach(numberOfQuestionsOptions, id: \.self) {
                        Text($0, format: .number)
                    }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Number of questions")
            }
            
            Section {
                
                Button(role: gameIsRunning ? .destructive : .cancel, action: startGame) {
                    Text(gameIsRunning ? "Stop" : "Start")
                        .frame(maxWidth: .infinity, minHeight: 50)
                }
                .buttonStyle(.borderedProminent)
            } header: {
                Text("Ready?")
            }
            
            Section {
                Text(gameIsRunning ? "Q: What is \(tablesNumber) × \(questionNumber)?" : "Q: ")
                
                HStack {
                    Text("A:")
                    
                    Picker("Choose answer", selection: $playerAnswer) {
                        ForEach(activeAnswers, id: \.self) {
                            Text($0, format: .number)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Button(action: confirm) {
                        Text(playerConfirmedChoice ? "Next" : "Confirm")
                    }
                    .buttonStyle(.bordered)
                }
            }
            
            Section {
                Text(result)
            } header: {
                Text("Result")
            }
            
            Section {
                Text("\(questionsCorrect) out of \(numberOfQuestions)")
            } header: {
                Text("Score")
            }
        }
        .alert("Game Over", isPresented: $gameOver) {
            Button("OK", action: resetGame)
        } message: {
            Text("You got \(questionsCorrect) correct!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
