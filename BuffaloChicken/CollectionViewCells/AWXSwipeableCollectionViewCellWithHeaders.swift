//
//  AWXSwipeableCollectionViewCellWithHeaders.swift
//  BuffaloChicken
//
//  Created by Sam Doggett on 7/2/20.
//  Copyright © 2020 Sam Doggett. All rights reserved.
//

import UIKit

class AWXSwipeableCollectionViewCellWithHeaders: AWXSwipableCollectionViewCell {
    private var previousPage = -1
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    //The collectionview contains the section headers (if given). These will update based on the range each section header is responsible for (see AWXSectionHeader).
    private lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: self.flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.showsHorizontalScrollIndicator = false
        collection.isScrollEnabled = false
        return collection
    }()
    
    private lazy var sectionHeaders: [AWXSectionHeader] = {
        return [AWXSectionHeader]()
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if sectionHeaders.count > 0 {
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
            collectionView.heightAnchor.constraint(equalToConstant: 25).isActive = true
            scrollViewTopAnchorConstraint?.isActive = false
            scrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        }
    }
    
    func addSubviewsAndSectionHeaders(views: [UIView], headers: [AWXSectionHeader]) {
        self.infiniteScrolling = false
        self.views = views
        self.sectionHeaders = headers
        setupSubviews()
        reloadScrollView()
    }
    
    override func setupSubviews() {
        super.setupSubviews()
        
        self.collectionView.register(LabelCollectionViewCell.self, forCellWithReuseIdentifier: LabelCollectionViewCell.reuseIdentifier)
        self.contentView.addSubview(collectionView)
    }
    
    override func reloadScrollView() {
        super.reloadScrollView()
        
        updateSectionHeader()
    }
    
    override func calculateOffset(initialLoad: Bool = false) {
        super.calculateOffset(initialLoad: initialLoad)
        updateSectionHeader()
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        super.scrollViewDidEndDecelerating(scrollView)
        
        updateSectionHeader()
    }
    
    func updateSectionHeader() {
        if sectionHeaders.count > 0, pageControl.currentPage != previousPage {
            previousPage = pageControl.currentPage
            var currentSectionHeader: IndexPath?
            for section in sectionHeaders {
                if section.range.contains(pageControl.currentPage) {
                    currentSectionHeader = IndexPath(row: pageControl.currentPage, section: 0)
                    section.enabled = true
                } else {
                    section.enabled = false
                }
            }
            
            if let current = currentSectionHeader {
                collectionView.reloadData()
                collectionView.layoutIfNeeded()
                collectionView.scrollToItem(at: current, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
}

extension AWXSwipeableCollectionViewCellWithHeaders: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sectionHeaders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LabelCollectionViewCell.reuseIdentifier, for: indexPath) as! LabelCollectionViewCell
        
        let section = sectionHeaders[indexPath.row]
        cell.titleLabel.text = section.sectionTitle
        if section.enabled {
            cell.selectedUnderlineView.backgroundColor = .red
        } else {
            cell.selectedUnderlineView.backgroundColor = .clear
        }
        cell.layoutSubviews()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/3 - flowLayout.minimumInteritemSpacing, height: 25)
    }
}


class LabelCollectionViewCell: UICollectionViewCell, ReusableIdentifier {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Section"
        label.textAlignment = .center
        return label
    }()
    
    lazy var selectedUnderlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        return view
    }()
    
    var isEnabled: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(selectedUnderlineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: selectedUnderlineView.topAnchor).isActive = true
        
        selectedUnderlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        selectedUnderlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        selectedUnderlineView.heightAnchor.constraint(equalToConstant: 2.5).isActive = true
    }
}

class AWXSectionHeader {
    //Is this section selected
    var enabled: Bool = false
    //The range of indexes this section is responsible for
    var range: ClosedRange<Int>
    //The title to be displayed
    var sectionTitle: String
    
    init(range: ClosedRange<Int>, sectionTitle: String) {
        self.range = range
        self.sectionTitle = sectionTitle
    }
}
