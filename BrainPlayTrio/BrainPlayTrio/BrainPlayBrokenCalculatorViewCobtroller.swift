//
//  BrokenCalculatorVC.swift
//  BrainPlayTrio
//
//  Created by BrainPlay Trio on 2024/12/23.
//


import UIKit

class BrainPlayBrokenCalculatorViewCobtroller: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var currentNumberLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var buttonSubtract: UIButton!
    @IBOutlet weak var buttonMultiply: UIButton!
    @IBOutlet weak var buttonDivide: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonEvaluate: UIButton!

    // MARK: - Properties
    private var targetNumber = 0
    private var currentNumber = 0
    private var allowedOperations: [UIButton] = []
    private var currentExpression = ""
    private var timer: Timer?
    private var timeRemaining = 0

    private var levels: [BrainPlayGameLevel] = []
    private var currentLevelIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLevels()
        setupGame()
    }

    // MARK: - Game Setup
    private func setupLevels() {
        levels = [
            BrainPlayGameLevel(targetNumber: 6, allowedButtons: [button1, button2, buttonAdd, buttonMultiply], timer: 30),
            BrainPlayGameLevel(targetNumber: 24, allowedButtons: [button2, button3, buttonMultiply, buttonSubtract], timer: 30),
            BrainPlayGameLevel(targetNumber: 50, allowedButtons: [button1, button3, buttonAdd, buttonMultiply], timer: 40),
            // Add more levels as needed
        ]
    }

    private func setupGame() {
        guard currentLevelIndex < levels.count else {
            resultLabel.text = "🎉 You completed all levels! 🎉"
            disableAllButtons()
            return
        }

        let currentLevel = levels[currentLevelIndex]
        targetNumber = currentLevel.targetNumber
        allowedOperations = currentLevel.allowedButtons

        targetLabel.text = "Target: \(targetNumber)"
        currentNumber = 0
        currentNumberLabel.text = "Current: \(currentNumber)"
        resultLabel.text = "Can you reach the target?"
        currentExpression = ""

        enableAllowedButtons()
        startTimer(duration: currentLevel.timer)
    }

    private func enableAllowedButtons() {
        let allButtons = [button1, button2, button3, buttonAdd, buttonSubtract, buttonMultiply, buttonDivide, buttonClear]
        allButtons.forEach { $0?.isEnabled = true }
        allowedOperations.forEach { $0.isEnabled = true }
        allowedOperations.forEach { $0.alpha = 1.0 }

    }

    private func disableAllButtons() {
        let allButtons = [button1, button2, button3, buttonAdd, buttonSubtract, buttonMultiply, buttonDivide, buttonClear]
        allButtons.forEach { $0?.isEnabled = false }
        allButtons.forEach { $0?.alpha = 0.1 }
    }

    // MARK: - Timer
    private func startTimer(duration: Int) {
        timeRemaining = duration
        timer?.invalidate() // Stop any existing timer
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.updateTimerLabel()

            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.resultLabel.text = "⏰ Time's up! Try Again!"
                self.setupGame()
            }
        }
    }

    private func updateTimerLabel() {
        timerLabel.text = "Time: \(timeRemaining)s"
    }

    // MARK: - Actions
    @IBAction func numberButtonTapped(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        currentExpression += buttonText
        currentNumberLabel.text = "Current: \(currentExpression)"
    }

    @IBAction func operationButtonTapped(_ sender: UIButton) {
        guard let buttonText = sender.titleLabel?.text else { return }
        
        // Ensure the last character isn't already an operator
        if let lastChar = currentExpression.last, "+-*/".contains(lastChar) {
            return // Ignore invalid operator input
        }
        
        currentExpression += " \(buttonText) "
        currentNumberLabel.text = "Current: \(currentExpression)"
    }

    @IBAction func clearButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Clear Current Input",
                                      message: "Are you sure you want to clear the current input?",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Clear", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.currentExpression = ""
            self.currentNumber = 0
            self.currentNumberLabel.text = "Current: 0"
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func isValidExpression(_ expression: String) -> Bool {
        // Ensure the expression doesn't start or end with an operator
        let operators = CharacterSet(charactersIn: "+-*/")
        let trimmedExpression = expression.trimmingCharacters(in: .whitespaces)
        
        if let firstCharacter = trimmedExpression.first,
           operators.contains(firstCharacter.unicodeScalars.first!) {
            return false
        }
        
        if let lastCharacter = trimmedExpression.last,
           operators.contains(lastCharacter.unicodeScalars.first!) {
            return false
        }
        
        // Ensure there are no consecutive operators
        let regex = "[+\\-*/]{2,}"
        if let _ = expression.range(of: regex, options: .regularExpression) {
            return false
        }
        
        return true
    }
    @IBAction func evaluateExpression(_ sender: UIButton) {
        // Clean up the expression
        let cleanedExpression = cleanExpression(currentExpression)
        
        // Validate the expression
        guard isValidExpression(cleanedExpression) else {
            resultLabel.text = "⚠️ Invalid Expression!"
            return
        }

        do {
            // Evaluate the expression
            let expression = NSExpression(format: cleanedExpression)
            if let result = expression.expressionValue(with: nil, context: nil) as? Int {
                if result == targetNumber {
                    resultLabel.text = "🎉 Correct! 🎉"
                    currentLevelIndex += 1
                    setupGame()
                } else {
                    resultLabel.text = "❌ Incorrect! Try Again!"
                }
            } else {
                resultLabel.text = "⚠️ Evaluation Error!"
            }
        } catch {
            resultLabel.text = "⚠️ Invalid Expression!"
        }
    }
    
    private func cleanExpression(_ expression: String) -> String {
        // Remove extra spaces
        let trimmedExpression = expression.trimmingCharacters(in: .whitespacesAndNewlines)
        // Replace multiple spaces with a single space
        let normalizedExpression = trimmedExpression.replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
        return normalizedExpression
    }
    private func debugExpression(_ expression: String) {
        print("Raw Expression: \(expression)")
        print("Cleaned Expression: \(cleanExpression(expression))")
        print("Is Valid: \(isValidExpression(expression))")
    }

    @IBAction func resetButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Game",
                                      message: "Are you sure you want to reset the game? This will restart from the first level.",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { [weak self] _ in
            guard let self = self else { return }
            self.currentLevelIndex = 0
            self.setupGame()
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
