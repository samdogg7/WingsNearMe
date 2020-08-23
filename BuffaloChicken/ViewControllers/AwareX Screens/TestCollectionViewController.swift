//
//  TestCollectionViewController.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 6/15/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class TestCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
        
    lazy var imageViews: [UIImageView] = {
        return [UIImageView]()
    }()
    
    let customFlowLayout = CustomFlowLayout()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "PlaceholderWing")!)
        let imageView1 = UIImageView(image: UIImage(named: "PlaceholderWing1")!)
        let imageView2 = UIImageView(image: UIImage(named: "PlaceholderWing2")!)
        let imageView3 = UIImageView(image: UIImage(named: "PlaceholderWing3")!)
        let imageView4 = UIImageView(image: UIImage(named: "PlaceholderWing4")!)
        let imageView5 = UIImageView(image: UIImage(named: "PlaceholderWing5")!)
        let imageView6 = UIImageView(image: UIImage(named: "PlaceholderWing6")!)
        
        imageView.contentMode = .scaleAspectFill
        imageView1.contentMode = .scaleAspectFill
        imageView2.contentMode = .scaleAspectFill
        imageView3.contentMode = .scaleAspectFill
        imageView4.contentMode = .scaleAspectFill
        imageView5.contentMode = .scaleAspectFill
        imageView6.contentMode = .scaleAspectFill
        
        imageViews.append(imageView)
        imageViews.append(imageView1)
        imageViews.append(imageView2)
        imageViews.append(imageView3)
        imageViews.append(imageView4)
        imageViews.append(imageView5)
        imageViews.append(imageView6)
        
        customFlowLayout.sectionInsetReference = .fromContentInset // .fromContentInset is default
        customFlowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        customFlowLayout.minimumInteritemSpacing = 10
        customFlowLayout.minimumLineSpacing = 0
        customFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        customFlowLayout.headerReferenceSize = CGSize(width: 0, height: 40)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = customFlowLayout
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(AWXSwipeableCollectionViewCellWithHeaders.self, forCellWithReuseIdentifier: AWXSwipeableCollectionViewCellWithHeaders.reuseIdentifier)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AWXSwipeableCollectionViewCellWithHeaders.reuseIdentifier, for: indexPath) as! AWXSwipeableCollectionViewCellWithHeaders
        let headers = [AWXSectionHeader(range: 0...0, sectionTitle: "Section 1"), AWXSectionHeader(range: 1...1, sectionTitle: "Section 2"), AWXSectionHeader(range: 2...2, sectionTitle: "Section 3"), AWXSectionHeader(range: 3...3, sectionTitle: "Section 4"), AWXSectionHeader(range: 4...4, sectionTitle: "Section 5"), AWXSectionHeader(range: 5...5, sectionTitle: "Section 6"), AWXSectionHeader(range: 6...6, sectionTitle: "Section 7")]
        cell.addSubviewsAndSectionHeaders(views: imageViews, headers: headers)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 0, height: 300)
    }
}

//CustomFlowLayout is used for computing the cells width
final class CustomFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let layoutAttributesObjects = super.layoutAttributesForElements(in: rect)?.map{ $0.copy() } as? [UICollectionViewLayoutAttributes]
        layoutAttributesObjects?.forEach({ layoutAttributes in
            if layoutAttributes.representedElementCategory == .cell {
                if let newFrame = layoutAttributesForItem(at: layoutAttributes.indexPath)?.frame {
                    layoutAttributes.frame = newFrame
                }
            }
        })
        return layoutAttributesObjects
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let collectionView = collectionView else {
            fatalError()
        }
        guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath)?.copy() as? UICollectionViewLayoutAttributes else {
            return nil
        }
        
        layoutAttributes.frame.origin.x = sectionInset.left
        layoutAttributes.frame.size.width = collectionView.safeAreaLayoutGuide.layoutFrame.width - sectionInset.left - sectionInset.right
        return layoutAttributes
    }
}
