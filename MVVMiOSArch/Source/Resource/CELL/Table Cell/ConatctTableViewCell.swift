//
//  ConatctTableViewCell.swift
//  WatchMyBack
//
//  Created by Chetu on 11/12/18.
//  Copyright © 2018 LocatorTechnologies. All rights reserved.
//

import UIKit

class ConatctTableViewCell: UITableViewCell {
    @IBOutlet weak var contactName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(indexPath:NSIndexPath,arrayContact:NSArray){
        let contactDetails = arrayContact.object(at: indexPath.row) as! NSDictionary
        self.contactName.text = (contactDetails.value(forKey:Utility.localized(key: "kName") ) as! String)
        
    }
}
