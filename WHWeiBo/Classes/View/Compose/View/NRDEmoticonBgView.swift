//
//  NRDEmoticonBgView.swift
//  WHWeiBo
//
//  Created by 罗李 on 16/7/20.
//  Copyright © 2016年 罗李. All rights reserved.
//

import UIKit

class NRDEmoticonBgView: UIView {
    
    //  pageController
    private lazy var pageControl: UIPageControl = {
       let pageControl = UIPageControl()
        //  设置颜色
        pageControl.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_normal")!)
        pageControl.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_selected")!)
        
        return pageControl
    }()

    //  键盘工具栏
    private lazy var keyBoardToolBar: NRDKeyBoardToolBar = {
        let toolbar = NRDKeyBoardToolBar(frame: CGRectZero)
        return toolbar
    }()
    
    //  自定义表情键盘
    private lazy var emoticonKeyBoard: NRDEmojiCollectionView = {
        let emoticonKeyBoard = NRDEmojiCollectionView()
        emoticonKeyBoard.delegate = self
        return emoticonKeyBoard
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI () {
    

        //  添加
        addSubview(keyBoardToolBar)
        addSubview(emoticonKeyBoard)
        addSubview(pageControl)
        
        
        //  系统的约束
        keyBoardToolBar.translatesAutoresizingMaskIntoConstraints = false
        emoticonKeyBoard.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint(item: keyBoardToolBar, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: keyBoardToolBar, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: keyBoardToolBar, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: keyBoardToolBar, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: CGFloat(30)/216, constant: 0))
    
        
        //  表情键盘添加约束
        addConstraint(NSLayoutConstraint(item: emoticonKeyBoard, attribute: .Top, relatedBy: .Equal, toItem: self, attribute: .Top, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: emoticonKeyBoard, attribute: .Leading, relatedBy: .Equal, toItem: self, attribute: .Leading, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: emoticonKeyBoard, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: emoticonKeyBoard, attribute: .Bottom , relatedBy: .Equal, toItem: keyBoardToolBar, attribute: .Top , multiplier: 1, constant: 0))
        
        //  pageControl添加约束
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1, constant: -30))
        addConstraint(NSLayoutConstraint(item: pageControl, attribute: .Height, relatedBy: .Equal, toItem: self, attribute: .Height, multiplier: 10 / 186, constant: 0))
        
        //  toolbar 回调执行
        actionCallBackAction()
    }
    private func actionCallBackAction() {
        keyBoardToolBar.keyBoardToolBarClosure = { [weak self] (type) -> () in
                let indexpath:NSIndexPath
            switch type {

            case .Default:
                
                indexpath = NSIndexPath(forItem: 0, inSection: 0)
                
            case .Emoji:
                
                indexpath = NSIndexPath(forItem: 0, inSection: 1)

            case .Lxh:
                
                indexpath = NSIndexPath(forItem: 0, inSection: 2)

            }
            self!.emoticonKeyBoard.scrollToItemAtIndexPath(indexpath, atScrollPosition: .None, animated: false)
            //  调用page 设置方法
            self!.setPageControlByIndexPath(indexpath)
        }
    }
    //  这只pagecontroll
    private func setPageControlByIndexPath(indexPath:NSIndexPath) {
        //  设置pageControll 显示的个数
        pageControl.numberOfPages = NRDOpenBundleTools.sharedOpenBundleTools.emotionAllDataArr[indexPath.section].count
        //  当前的page 
        pageControl.currentPage = indexPath.item
    }
}




extension NRDEmoticonBgView:UICollectionViewDelegate {
    // MARK: - collection滚动
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
     

        //  进行x 升序排序
        let cells = (scrollView as! UICollectionView).visibleCells().sort { (firstCell,lastCell ) -> Bool in
            return firstCell.x <= lastCell.x
        }
        if cells.count == 2 {
        let firstField = abs(cells.first!.x - scrollView.contentOffset.x)
        let secondField = cells.last!.x - scrollView.contentOffset.x
        print(cells.last!.x)
        print(firstField,secondField)
      
        //  定义一个cell
        let indexPath: NSIndexPath
        //  越小表示对应区域显示越大
        if  firstField <= secondField {
            indexPath = (scrollView as! UICollectionView).indexPathForCell(cells.first!)!
        }else {
            indexPath = (scrollView as! UICollectionView).indexPathForCell(cells.last!)!
            print(firstField,secondField)
        }
        print(indexPath.section)
        //  通过放方法使用indexpath 让toolBar  显示不同的选中状态
            keyBoardToolBar.scrollChangeButtonWithIndexPath(indexPath)
            //  调用page 设置方法
            setPageControlByIndexPath(indexPath)
        }
        
//        else {
//            let otherCells = (scrollView as! UICollectionView).visibleCells()
//            let cell = otherCells.first
//            let index = (scrollView as! UICollectionView).indexPathForCell(cell!)!
//            print(index.section)
//        }
    }
}