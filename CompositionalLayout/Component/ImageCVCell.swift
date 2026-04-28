//
//  ImageCVCell.swift
//  CompositionalLayout
//
//  Created by SJ Basak on 28/04/26.
//

import UIKit

extension UIImage {
    static let dummyImages: [UIImage] = [
        UIImage(resource: .image1),
        UIImage(resource: .image2),
        UIImage(resource: .image3),
        UIImage(resource: .image4),
    ]
}

class ImageCVCell: UICollectionViewCell {
    
    static let identifier = "ImageCVCell"
    
    let imageView = {
        let imgVw = UIImageView()
        imgVw.contentMode = .scaleAspectFill
        imgVw.clipsToBounds = true
        imgVw.layer.cornerRadius = 12
        imgVw.layer.masksToBounds = true
        
        return imgVw
    }()
    let label = {
        let lbl = UILabel()
        lbl.font = .systemFont(ofSize: 25, weight: .bold)
        lbl.textColor = .white
        
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(imageView)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.addSubview(label)
        
        self.imageView.image = .dummyImages.randomElement()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            self.label.centerXAnchor.constraint(equalTo: self.imageView.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.imageView.centerYAnchor),
        ])
    }
    
    func populateData(with index: Int) {
        self.label.text = "\(index)"
    }
}
