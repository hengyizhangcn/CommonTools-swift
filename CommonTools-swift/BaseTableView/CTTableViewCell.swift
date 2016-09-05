//
//  CTTableViewCell.swift
//  Pods
//
//  Created by zhy on 9/5/16.
//
//

public class CTTableViewCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func willDisplayCell() -> Void {
    }
    
    func endDisplayCell() -> Void {
    }
    
    func loadData(data: AnyObject) -> Void {
    }
}
