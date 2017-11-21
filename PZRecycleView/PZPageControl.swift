//
//  PZPageControl.swift
//  DLO
//
//  Created by 蒋泽康 on 2017/7/21.
//

import UIKit

class PZPageControl: UIView, UICollectionViewDataSource {

    enum AlignMode {
        case center
        case left
        case right
    }
    
    enum PageStyle {
        case circle
        case square
    }
    
    var collectionView: UICollectionView?
    
    var pageStyle: PageStyle = .circle {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var pageSize: CGSize = CGSize(width: 2.5 * kPZIPHONE6P_BASE_RATIO, height: 2.5 * kPZIPHONE6P_BASE_RATIO) {
        didSet {
            self.configCellSize()
            self.collectionView?.reloadData()
        }
    }
    
    
    var pageImage: UIImage? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var currentPageImage: UIImage? {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var pageColor: UIColor = .white {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var currentPageColor: UIColor = RGB(r: 255, g: 149, b: 0) {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    var pageSpacing: CGFloat = 10.0 * kPZIPHONE6P_BASE_RATIO {
        didSet {
            self.configCellSize()
        }
    }
    
    var alignMode: AlignMode = .center {
        didSet {
            self.configCellSize()
        }
    }

    var pageNumber: Int = 0 {
        didSet {
            if pageNumber == 0 {
                self.isHidden = true
            } else {
                self.isHidden = false
                self.configCellSize()
            }
        }
    }
    
    var currentPage: Int = 0 {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initCollectionView()
        
    }
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.initCollectionView()

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initCollectionView()

    }
    
    fileprivate func initCollectionView() {
        let autoLayout = UICollectionViewFlowLayout()
        autoLayout.minimumLineSpacing = 0
        
        if self.collectionView == nil {
            collectionView = UICollectionView(frame: frame, collectionViewLayout: autoLayout)
            collectionView?.backgroundColor = .clear
            collectionView?.dataSource = self
            collectionView?.showsVerticalScrollIndicator = false
            collectionView?.showsHorizontalScrollIndicator = false
            collectionView?.isScrollEnabled = false
            collectionView?.clipsToBounds = false

            self.addSubview(collectionView!)
            
            self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .left,
                                   relatedBy: .equal,
                                   toItem: collectionView,
                                   attribute: .left,
                                   multiplier: 1,
                                   constant: 0))
            self.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .right,
                                   relatedBy: .equal,
                                   toItem: collectionView,
                                   attribute: .right,
                                   multiplier: 1,
                                   constant: 0))
            self.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .top,
                                   relatedBy: .equal,
                                   toItem: collectionView,
                                   attribute: .top,
                                   multiplier: 1,
                                   constant: 0))
            self.addConstraint(
                NSLayoutConstraint(item: self,
                                   attribute: .bottom,
                                   relatedBy: .equal,
                                   toItem: collectionView,
                                   attribute: .bottom,
                                   multiplier: 1,
                                   constant: 0))
            
            
        }
        
        self.backgroundColor = .clear
        
        self.collectionView?.register(PZPageControlCell.self, forCellWithReuseIdentifier: "PZPageControlCell")
    }
    
    fileprivate func configCellSize() {
        let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout.itemSize = pageSize
        layout.minimumInteritemSpacing = pageSpacing
        
        switch alignMode {
        case .center:
            layout.sectionInset = UIEdgeInsetsMake(
                CGFloat(Int((self.frame.size.height - pageSize.height) / 2)),
                CGFloat(Int((self.frame.size.width - (pageSize.width * CGFloat(pageNumber) + CGFloat(pageNumber - 1) * pageSpacing)) / 2)),
                0,
                CGFloat(Int((self.frame.size.width - (pageSize.width * CGFloat(pageNumber) + CGFloat(pageNumber - 1) * pageSpacing)) / 2)))
        case .right:
            layout.sectionInset = UIEdgeInsetsMake(
                CGFloat(Int((self.frame.size.height - pageSize.height) / 2)),
                CGFloat(Int(self.frame.size.width - (pageSize.width * CGFloat(pageNumber) + CGFloat(pageNumber - 1) * pageSpacing))),
                0,
                0)
        case .left:
            layout.sectionInset = UIEdgeInsetsMake(
                CGFloat(Int((self.frame.size.height - pageSize.height) / 2)),
                0,
                0,
                CGFloat(Int(self.frame.size.width - (pageSize.width * CGFloat(pageNumber) + CGFloat(pageNumber - 1) * pageSpacing))))
        }
        
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageNumber
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "PZPageControlCell"
        let cell: PZPageControlCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PZPageControlCell
        
        if self.pageStyle == .circle {
            cell.layer.cornerRadius = min(pageSize.width, pageSize.height) / 2
        } else {
            cell.layer.cornerRadius = 0
        }
        
        if currentPage == indexPath.row {
            if currentPageImage != nil {
                cell.backgroundColor = .clear
                cell.imageView?.isHighlighted = false
            } else {
                cell.backgroundColor = currentPageColor
                cell.imageView?.isHidden = true
            }
        } else {
            if pageImage != nil {
                cell.imageView?.isHidden = false
                cell.backgroundColor = pageColor
            } else {
                cell.imageView?.isHidden = true
                cell.backgroundColor = pageColor
            }
        }
        
        return cell
        
    }
    
}
