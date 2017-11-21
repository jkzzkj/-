//
//  PZRecycleView.swift
//  DLO
//
//  Created by 蒋泽康 on 2017/7/20.
//

import UIKit

public let kPZScreen_Width = UIScreen.main.bounds.width
public let kPZIPHONE6P_BASE_RATIO = kPZScreenWidth/414.0

class PZRecycleView: UIView, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    var scrollViewArray: [UIImageView] = []
    var urlArray: [String] = ["", "", ""]
    var timer: Timer?

    let pageControl = PZPageControl()

    //MARK: 初始化界面
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.config()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.config()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.config()
    }

    private func config() {
        let pageControl = PZPageControl(frame:
            CGRect(x: 25 * kPZIPHONE6P_BASE_RATIO,
                   y: self.frame.size.height - 13 * kPZIPHONE6P_BASE_RATIO,
                   width: 364 * kPZIPHONE6P_BASE_RATIO,
                   height: 3 * kPZIPHONE6P_BASE_RATIO))

        scrollView = UIScrollView.init(frame: self.bounds)
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        self.addSubview(scrollView)
        
        scrollView.contentSize = CGSize(width: kPZScreen_Width * 5, height: self.frame.size.height)
        scrollView.delegate = self

        for i in 0..<5 {
            let imageView = UIImageView(frame:
                CGRect(x: kPZScreen_Width * CGFloat(i),
                       y: 0,
                       width: kPZScreen_Width,
                       height: 180 * kPZIPHONE6P_BASE_RATIO))
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true

            scrollViewArray.append(imageView)
            scrollView.addSubview(imageView)

        }

        scrollView.contentOffset = CGPoint(x: 2 * kPZScreen_Width, y: 0)
        pageControl.pageStyle = .circle
        pageControl.alignMode = .right
        pageControl.pageNumber = self.urlArray.count

        pageControl.pageSize = CGSize(width: 2.5 * kPZIPHONE6P_BASE_RATIO, height: 2.5 * kPZIPHONE6P_BASE_RATIO)
        pageControl.pageSpacing = 10 * kPZIPHONE6P_BASE_RATIO

        self.addSubview(pageControl)

    }

    //MARK: - 自定义初始化界面函数 -
    public func configScrollView(urlStringArray: [String]?) {
        guard urlStringArray != nil else {
            return
        }

        urlArray = urlStringArray!
        pageControl.pageNumber = self.urlArray.count
        pageControl.currentPage = 0

        self.addTimer()
        if urlStringArray?.count != 0 {
            self.setImages()
        }

    }

    private func setImages() {
        for i in 0..<5 {
            let imageView = scrollViewArray[i]
            imageView.image = nil
            var currentPage = i - 2 + self.pageControl.currentPage
            while currentPage < 0 {
                currentPage = currentPage + urlArray.count
            }
            while currentPage >= urlArray.count {
                currentPage = currentPage - urlArray.count
            }
            let url = urlArray[currentPage]
            imageView.iss_SetImage(urlString: url, placeHolderImage: nil)

        }

    }

    //MARK: - 自动滑动设置 -
    func addTimer() {
        self.timer?.invalidate()
        if urlArray.count > 0 {
            self.timer = Timer.scheduledTimer(
                timeInterval: 5,
                target: self,
                selector: #selector(PZRecycleView.nextPage),
                userInfo: nil,
                repeats: true)
        }
    }

    func removeTimer(){
        timer?.invalidate()

    }

    @objc private func nextPage() {
        var page = Int(self.pageControl.currentPage)
        page = page + 1
        UIView.animate(
            withDuration: 1.0,
            delay: 0,
            options: .curveEaseInOut,
            animations: { [weak self] in
            self?.scrollView.contentOffset = CGPoint(x: 3 * kPZScreen_Width, y: 0)
        }) { _ in
            var currentPage = self.pageControl.currentPage + 1
            while currentPage < 0 {
                currentPage = currentPage + self.urlArray.count
            }
            while currentPage >= self.urlArray.count {
                currentPage = currentPage - self.urlArray.count
            }
            self.pageControl.currentPage = currentPage
            self.setImages()
            self.scrollView.contentOffset = CGPoint(x: 2 * kPZScreen_Width, y: 0)
        }

    }

    //MARK: - UIScrollViewDelegate -
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.removeTimer()

    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(self.pageControl.currentPage)
        let changePage = lroundf(Float(self.scrollView.contentOffset.x / kPZScreen_Width))
        var currentPage = page + changePage - 2
        while currentPage < 0 {
            currentPage = currentPage + urlArray.count
        }
        while currentPage >= urlArray.count {
            currentPage = currentPage - urlArray.count
        }
        self.pageControl.currentPage = currentPage
        self.setImages()
        self.scrollView.contentOffset = CGPoint(x: 2 * kPZScreen_Width, y: 0)
        self.addTimer()

    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

    }

}
