//
//  CTTableViewCell.swift
//  Pods
//
//  Created by zhy on 9/5/16.
//
//
import UIKit

open class CTTableViewCell : UITableViewCell {
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.none
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func willDisplayCell() -> Void {
    }
    
    open func endDisplayCell() -> Void {
    }
    
    open func loadData(_ data: Any?) -> Void {
    }
}
