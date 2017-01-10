//
//  NRDShowPictureView.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/19.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit


private let PickerCellkey = "imageCell"
class NRDShowPictureView: UICollectionView {
    
    var showPictureBack: (() -> ())?

    //  传递图片
    lazy var imageInfos = [UIImage]()
    var image: UIImage? {
    
        didSet {
            if image != nil {

                self.hidden = false
                
                self.imageInfos.append(image!)

                self.reloadData()

            }
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        //  flowlayou
        let flowLayout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 设置UI
    private func setupUI() {
        self.backgroundColor = UIColor.whiteColor()

        delegate = self
        dataSource = self
        //  注册
        registerClass(NRDPictureCell.self, forCellWithReuseIdentifier: PickerCellkey)
        
        
//        print(imageInfos.count)
    }
    
    
}
extension NRDShowPictureView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //  在第九个  和第0 个 去掉添加按钮
        if imageInfos.count == 9 || imageInfos.count == 0 {
            return imageInfos.count
        }
        return imageInfos.count + 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(PickerCellkey, forIndexPath: indexPath) as! NRDPictureCell
        if indexPath.row == imageInfos.count {
            cell.image = nil
        }else {
            cell.image = imageInfos[indexPath.row]
        }
        cell.deleteImageCallBack = {
            self.imageInfos.removeAtIndex(indexPath.row)
            if self.imageInfos.count == 0 {
                self.hidden = true
            }
            self.reloadData()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == imageInfos.count {
            
            //  取消选中,支持高亮图片
            collectionView.deselectItemAtIndexPath(indexPath, animated: true)
            showPictureBack!()
        }
    }
    
    override func layoutSubviews() {
    
        super.layoutSubviews()
        //  collection的flowlayout
        let myFlowLayout = collectionViewLayout as! UICollectionViewFlowLayout
    
        let itemMargin = 5
        let itemWidth = (width - 2 * CGFloat(itemMargin)) / 3
        let itemHeight = (height - 2 * CGFloat(itemMargin)) / 3
        //  设置itemSize
        myFlowLayout.itemSize = CGSizeMake(itemWidth, itemHeight)
        myFlowLayout.minimumLineSpacing = 5
        myFlowLayout.minimumInteritemSpacing = 5
    }
    
}















