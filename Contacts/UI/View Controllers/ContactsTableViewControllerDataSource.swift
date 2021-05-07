
//  contactsapp
//  Created by Nocero Beguhe. on 05/05/21.

import UIKit

class ContactsTableViewControllerDataSource: NSObject, UITableViewDataSource {

    private var contactsStore: ContactsStore!
    
    // MARK: - Initializers
    
    init(_ contactsStore: ContactsStore) {
        self.contactsStore = contactsStore
    }
    
    // MARK: - Public
    
    func contact(at indexPath: IndexPath)-> Contact? {
        if contactsStore.contacts.indices.contains(indexPath.row) { return contactsStore.contacts[indexPath.row] }
        else { return nil }
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactsStore.contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CustomTableViewCell = CustomTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        cell.imageView!.layer.cornerRadius = 20
        cell.imageView!.clipsToBounds = true
        let contact = contactsStore.contacts[indexPath.row]
        let avatarimage = UIImage(named: ("avatar.png"))
        let avartarimagedata = UIImageJPEGRepresentation(avatarimage!, 1)
        let image1 = UIImage(data: (contact.image ?? avartarimagedata)!)
        cell.imageView?.image = image1
        cell.textLabel?.text = contact.displayName
        return cell
    }

}

class CustomTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    // Here you can customize the appearance of your cell
    override func layoutSubviews() {
        super.layoutSubviews()
        // Customize imageView like you need
        self.imageView?.frame = CGRect(x: 10, y: 0, width: 40,height: 40)
        self.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        // Costomize other elements
        self.textLabel?.frame = CGRect(x: 60,y: 0, width: self.frame.width - 45, height: 20)
        self.detailTextLabel?.frame = CGRect(x: 60, y: 20, width: self.frame.width - 45, height: 15)
    }
}
