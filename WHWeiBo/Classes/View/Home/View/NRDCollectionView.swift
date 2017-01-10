//
//  NRDCollectionView.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/15.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
//  margin
private let itemMargin = 5
//  设宽度
private let itemWidth = (screenWidth -  CGFloat(itemMargin + subMargin) * 2) / 3

private let key = "cell"
class NRDCollectionView: UICollectionView {

    // 闭包回调

    //  数组
    var pic_urls: [NRDStatusPic_urls]? {
        didSet {
           showImageLabel.text = "\(pic_urls?.count ?? 0)"
            showImageLabel.textColor = UIColor.redColor()
        
            
            let size = settingPicSize(pic_urls?.count ?? 0)
            
            snp_updateConstraints { (make) -> Void in
                make.size.equalTo(size)
            }
            self.reloadData()
        }
    }
    private var myFlowLayout: UICollectionViewFlowLayout?
    
    private lazy var showImageLabel: UILabel = {
        let label = UILabel()
        
        label.font = UIFont.systemFontOfSize(30)
        return label
    }()

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        myFlowLayout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: myFlowLayout!)
        
        setupUI ()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        //  设置代理
        dataSource = self
        delegate = self
        //  注册
        registerClass(NRDCollectionViewCell.self, forCellWithReuseIdentifier: key)
        //  设置布局
        myFlowLayout?.itemSize = CGSizeMake(itemWidth, itemWidth)
        myFlowLayout?.minimumLineSpacing = CGFloat(itemMargin)
        myFlowLayout?.minimumInteritemSpacing = CGFloat(itemMargin)
        //  添加字空间
        addSubview(showImageLabel)
        //  设置约束
        showImageLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(self)
        }
    }
    // MARK: - 计算图片的位置
    private func settingPicSize(imageCount: Int) -> CGSize{
    

        //  列数
        let colNum = imageCount > 3 ? 3:imageCount
        //  行数
        let rowNum = (imageCount - 1) / 3 + 1
        //  计算当前配图的宽度
        let picWith = CGFloat(colNum) * itemWidth + CGFloat((colNum - 1)*itemMargin)
        let picHeight = CGFloat(rowNum) * itemWidth + CGFloat((rowNum - 1)*itemMargin)
        
        return CGSizeMake(picWith, picHeight)
    }

}

extension NRDCollectionView: UICollectionViewDataSource, UICollectionViewDelegate,SDPhotoBrowserDelegate  {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pic_urls?.count ?? 0
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(key, forIndexPath: indexPath) as! NRDCollectionViewCell
//        cell.backgroundColor = randomColor()
        
        cell.pic_url = pic_urls![indexPath.item]
        
        return cell
    }
    
    
    // MARK: -  代理方法
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //        SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
        //        photoBrowser.delegate = self;
        //        photoBrowser.currentImageIndex = indexPath.item;
        //        photoBrowser.imageCount = self.modelsArray.count;
        //        photoBrowser.sourceImagesContainerView = self.collectionView;
        //
        //        [photoBrowser show];

        //  通知
 
        

        let photoBrowser = SDPhotoBrowser()
        photoBrowser.delegate = self
        photoBrowser.currentImageIndex = indexPath.item
        //  图片的数组
        photoBrowser.imageCount = pic_urls!.count//modelsArray.count
        photoBrowser.sourceImagesContainerView = self
        photoBrowser.show()

        
    
        
    }
    
    // MARK: - photoBrowser的代理放法
    func photoBrowser(browser: SDPhotoBrowser!, placeholderImageForIndex index: Int) -> UIImage! {
      
        //        // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
        //        SDCollectionViewDemoCell *cell = (SDCollectionViewDemoCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
        //
        //        return cell.imageView.image;
                let indexPath = NSIndexPath(forItem: index, inSection: 0)

        let cell = self.cellForItemAtIndexPath(indexPath) as! NRDCollectionViewCell
        return cell.showImage.image
        
    }
    // MARK: - 图片质量
    func photoBrowser(browser: SDPhotoBrowser!, highQualityImageURLForIndex index: Int) -> NSURL! {
//                NSString *urlStr = [[self.modelsArray[index] thumbnail_pic] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        //        return [NSURL URLWithString:urlStr];
        let urlStr = pic_urls![index].thumbnail_pic!.stringByReplacingOccurrencesOfString("thumbnail", withString: "bmiddle")
        return NSURL(string: urlStr)
    }
    
}
class NRDCollectionViewCell: UICollectionViewCell {
    var pic_url: NRDStatusPic_urls? {
        didSet {
            
            if let imageURL = pic_url!.thumbnail_pic{
                
                showImage.sd_setImageWithURL(NSURL(string: imageURL), placeholderImage: UIImage(named: "timeline_image_placeholder"))
                
                gifImage?.hidden = !imageURL.hasSuffix(".gif")
            }
        }
    }
     lazy var showImage: UIImageView = {
        let showImage = UIImageView(image: UIImage(named: "timeline_image_placeholder"))
        showImage.contentMode = UIViewContentMode.ScaleAspectFill
        showImage.clipsToBounds = true
        return showImage
    }()
    private lazy var gifImage: UIImageView? = UIImageView(image: UIImage(named: "timeline_image_gif"))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(showImage)
        
        showImage.snp_makeConstraints(closure: { (make) -> Void in
            make.edges.equalTo(contentView).offset(UIEdgeInsetsZero)
        })
        showImage.addSubview(gifImage!)
        gifImage?.snp_makeConstraints(closure: { (make) -> Void in
            make.trailing.equalTo(showImage)
            make.bottom.equalTo(showImage)
        })
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
