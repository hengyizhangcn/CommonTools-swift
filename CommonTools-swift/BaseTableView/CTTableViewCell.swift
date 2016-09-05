//
//  CTTableViewCell.swift
//  Pods
//
//  Created by zhy on 9/5/16.
//
//

public class CTTableViewCell : UITableViewCell {
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func willDisplayCell() -> Void {
    }
    
    public func endDisplayCell() -> Void {
    }
    
    public func loadData(data: AnyObject) -> Void {
    }
}
