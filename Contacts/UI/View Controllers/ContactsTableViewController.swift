
//  contactsapp
//  Created by Nocero Beguhe. on 05/05/21.

import UIKit

/// Displays a list of all contacts

class ContactsTableViewController: UITableViewController {
    
    private let contactsStore = ContactsStore()
    private lazy var contactsTableViewControllerDataSource: ContactsTableViewControllerDataSource =  {
        return ContactsTableViewControllerDataSource(contactsStore)
    }()
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addObservers()
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = contactsTableViewControllerDataSource
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Observers
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactsFetched(notification:)), name: .contactsFetched, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleContactUpdated(notification:)), name: .contactUpdated, object: nil)
    }
    
    @objc private func handleContactsFetched(notification: Notification) {
        tableView.reloadData()
    }
    
    @objc private func handleContactUpdated(notification: Notification) {
        guard let info = notification.userInfo,
            let contactStoreUpdate = info[String.contactStoreUpdate] as? ContactStoreUpdate else { return }
        
        tableView.beginUpdates()
        switch contactStoreUpdate {        
        case .added(let indexPath):
            tableView.insertRows(at: [indexPath], with: .automatic)
        case .updated(let indexPath, _):
            tableView.reloadRows(at: [indexPath], with: .automatic)
        case .deleted(let indexPath):
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        tableView.endUpdates()
    }
    
    // MARK: - TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: .segueFromContactsToContactDetail, sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  .segueFromContactsToAddContact {
            guard let contactFormTableViewController = segue.destination as? ContactFormTableViewController else { fatalError("Expected a contact form tvc") }
            contactFormTableViewController.configure(.new, contactsStore: contactsStore)
        } else if segue.identifier == .segueFromContactsToContactDetail {
            guard
                let contactDetailViewController = segue.destination as? ContactDetailViewController,
                let indexPath = tableView.indexPathForSelectedRow,
                let contact = contactsTableViewControllerDataSource.contact(at: indexPath)
                else { fatalError() }
            
            contactDetailViewController.configure(contact, contactsStore: contactsStore)
        }
    }
}
