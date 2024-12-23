//
//  SlidingPuzzleVC.swift
//  BrainPlayTrio
//
//  Created by jin fu on 2024/12/23.
//


import UIKit

class BrainPlaySlidingPuzzleViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var gameBoardView: UIView! // Game board container
    @IBOutlet weak var woodenBocCV: UICollectionView!
    @IBOutlet weak var gridSizePicker: UISegmentedControl! // Grid size selector
    
    // MARK: - Variables
    private var gridSize = 1 // Default grid size
    private var tileButtons: [UIButton] = []
    private var emptyTilePosition: (row: Int, col: Int) = (0, 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupGame()
        setUpCollectionView()
    }
    
    // MARK: - Setup Game
    func setUpCollectionView() {
        self.woodenBocCV.dataSource = self
        self.woodenBocCV.delegate = self
        self.woodenBocCV.register(UINib(nibName: "SlidingPuzzleCVC", bundle: nil), forCellWithReuseIdentifier: "SlidingPuzzleCVC")
    }
    
    private func setupGame() {
        resetGameBoard()
        createGrid()
        shuffleTiles()
        woodenBocCV.reloadData()
    }
    
    private func resetGameBoard() {
        for button in tileButtons {
            button.removeFromSuperview()
        }
        tileButtons.removeAll()
    }
    
    private func createGrid() {
        let tileSize = gameBoardView.frame.width / CGFloat(gridSize)
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                let button = UIButton(type: .system)
                button.frame = CGRect(x: CGFloat(col) * tileSize,
                                      y: CGFloat(row) * tileSize,
                                      width: tileSize,
                                      height: tileSize)
                
                let tag = row * gridSize + col + 1
                button.tag = tag
                
                // Assign image instead of title
                if tag < gridSize * gridSize {
                    let image = UIImage(named: "image\(tag)")
                    button.setImage(image, for: .normal)
                } else {
                    button.backgroundColor = .clear
                }
                
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.darkGray.cgColor
                
                button.addTarget(self, action: #selector(tileTapped), for: .touchUpInside)
                gameBoardView.addSubview(button)
                tileButtons.append(button)
            }
        }
        
        let lastTile = tileButtons.last!
        emptyTilePosition = (gridSize - 1, gridSize - 1) // Bottom-right position
        lastTile.setImage(nil, for: .normal)
        lastTile.backgroundColor = .clear
    }

    private func swapTiles(tappedPosition: (row: Int, col: Int)) {
        let emptyIndex = getIndex(position: emptyTilePosition)
        let tappedIndex = getIndex(position: tappedPosition)
        
        let emptyButton = tileButtons[emptyIndex]
        let tappedButton = tileButtons[tappedIndex]
        
        let tappedImage = tappedButton.image(for: .normal)
        emptyButton.setImage(tappedImage, for: .normal)
        emptyButton.backgroundColor = tappedButton.backgroundColor
        
        tappedButton.setImage(nil, for: .normal)
        tappedButton.backgroundColor = .clear
        
        emptyTilePosition = tappedPosition
    }

    
    // MARK: - Tile Tap Action
    @objc private func tileTapped(_ sender: UIButton) {
        guard let tappedIndex = tileButtons.firstIndex(of: sender) else { return }
        let tappedPosition = getPosition(index: tappedIndex)
        
        if isValidMove(tappedPosition: tappedPosition) {
            swapTiles(tappedPosition: tappedPosition)
            if checkWinCondition() {
                showWinAlert()
            }
        }
    }
    
    private func isValidMove(tappedPosition: (row: Int, col: Int)) -> Bool {
        let rowDiff = abs(emptyTilePosition.row - tappedPosition.row)
        let colDiff = abs(emptyTilePosition.col - tappedPosition.col)
        
        // Check if the tile is adjacent (up, down, left, right)
        return (rowDiff == 1 && colDiff == 0) || (rowDiff == 0 && colDiff == 1)
    }
    
    private func getPosition(index: Int) -> (row: Int, col: Int) {
        return (index / gridSize, index % gridSize)
    }
    
    private func getIndex(position: (row: Int, col: Int)) -> Int {
        return position.row * gridSize + position.col
    }
    
    private func checkWinCondition() -> Bool {
        for (index, button) in tileButtons.enumerated() {
            if let title = button.currentTitle, let number = Int(title) {
                if number != index + 1 {
                    return false
                }
            } else if index != tileButtons.count - 1 {
                return false
            }
        }
        return true
    }
    
    private func showWinAlert() {
        let alert = UIAlertController(title: "Congratulations!", message: "You solved the puzzle!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.setupGame()
        }))
        present(alert, animated: true)
    }
    
    // MARK: - Shuffle Tiles
    private func shuffleTiles() {
        var positions = Array(0..<(gridSize * gridSize - 1))
        positions.shuffle()
        
        for (index, button) in tileButtons.enumerated() {
            if index < positions.count {
                let imageIndex = positions[index] + 1
                let image = UIImage(named: "image\(imageIndex)")
                button.setImage(image, for: .normal)
                button.backgroundColor = .clear
            } else {
                button.setImage(nil, for: .normal)
                button.backgroundColor = .clear
                emptyTilePosition = getPosition(index: index)
            }
        }
    }

    
    // MARK: - Grid Size Selection
    @IBAction func gridSizeChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            gridSize = 1
            setupGame()

        } else {
            gridSize = sender.selectedSegmentIndex + 2 // Index 0 -> 3x3, Index 6 -> 9x9
            setupGame()
        }
    }
    
    @IBAction func btnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
}

extension BrainPlaySlidingPuzzleViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return gridSize * gridSize
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SlidingPuzzleCVC", for: indexPath) as? SlidingPuzzleCVC else { return UICollectionViewCell()}
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthCons = collectionView.frame.size.width / CGFloat(gridSize)
        return CGSize(width: widthCons, height: widthCons)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
