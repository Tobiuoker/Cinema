//
//  FilmCollectionViewCell.swift
//  Cinema
//
//  Created by Khaled on 14.04.2020.
//  Copyright © 2020 Khaled. All rights reserved.
//

import UIKit

protocol MyCellDelegate: AnyObject {
    func starTapped(cell: FilmCollectionViewCell)
}

class FilmCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: MyCellDelegate?
    var id: Int?
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var uiView: UIView!
    @IBOutlet weak var cellFilmTitle: UILabel!
    @IBOutlet weak var cellFilmPopularity: UILabel!
    @IBOutlet weak var cellFilmImage: UIImageView!
    var buttonAction: ((Any) -> Void)?
    
    
    var isFavourite = false
    override func awakeFromNib() {
        super.awakeFromNib()
        cellFilmImage.layer.cornerRadius = 10
        cellFilmPopularity.center = CGPoint(x: uiView.frame.size.width  / 2,
        y: uiView.frame.size.height / 2)
        uiView.layer.cornerRadius = 10
//        self.flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize

        starButton.tintColor = UIColor.yellow
    }
    
    override func prepareForReuse() {
        cellFilmImage.image = nil
    }
    
    func update(title: String, popularity: String, image: UIImage){
        cellFilmImage.image = image
        cellFilmPopularity.text = popularity
        cellFilmTitle.text = title
    }
    
    @IBAction func starTapped(_ sender: Any) {
        isFavourite.toggle()
        
        delegate?.starTapped(cell: self)
    }
    
}
