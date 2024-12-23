//
//  SimonSaysVC.swift
//  BrainPlayTrio
//
//  Created by jin fu on 2024/12/23.
//


import UIKit

class BrainPlaySimonSaysViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // MARK: - Properties
    private var sequence: [UIButton] = []
    private var userInputIndex = 0
    private var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetGame()
    }
    
    // MARK: - Actions
    @IBAction func startButtonTapped(_ sender: UIButton) {
        resetGame()
        addNextToSequence()
        playSequence()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard !sequence.isEmpty else { return }
        
        if sender == sequence[userInputIndex] {
            userInputIndex += 1
            
            if userInputIndex == sequence.count {
                // Correct sequence
                score += 1
                scoreLabel.text = "\(score)"
                userInputIndex = 0
                addNextToSequence()
                playSequence()
            }
        } else {
            // Wrong button
            gameOver()
        }
    }
    
    // MARK: - Game Logic
    private func addNextToSequence() {
        let buttons = [redButton, greenButton, blueButton, yellowButton]
        if let randomButton = buttons.randomElement() ?? redButton {
            sequence.append(randomButton)
        }
    }
    
    private func playSequence() {
        startButton.isEnabled = false
        userInputIndex = 0
        
        for (index, button) in sequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.8) {
                self.flashButton(button)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(sequence.count) * 0.8) {
            self.startButton.isEnabled = true
        }
    }
    
    private func flashButton(_ button: UIButton?) {
        guard let button = button else { return }
        
        UIView.animate(withDuration: 0.3, animations: {
            button.alpha = 0.5
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                button.alpha = 1.0
            }
        }
    }
    
    private func resetGame() {
        sequence = []
        userInputIndex = 0
        score = 0
        scoreLabel.text = "\(score)"
    }
    
    private func gameOver() {
        let alert = UIAlertController(title: "Game Over", message: "Your Score: \(score)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.resetGame()
        }))
        present(alert, animated: true)
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}
