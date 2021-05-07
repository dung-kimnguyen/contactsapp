
//  contactsapp
//  Created by Nocero Beguhe. on 05/05/21.

import UIKit

// Indicates the state of the ContactForm which uses this information to update the UI accordingly

enum ContactFormState {
    case undefined
    case new
    case edit(contact: Contact)
}

/// A tableview controller used to get information about a Contact from the user to be added or edited

class ContactFormTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var textFields: [UITextField]!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var upLoadImageBtn: UIButton!
    @IBOutlet weak var myImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    private var activeTextField: UITextField?
    private var contactFormState = ContactFormState.undefined
    private var contactsStore: ContactsStore!
    
    var imageData: Data?
    
    // MARK: - Public
    
    @IBAction func upLoadImageBtnPressed(_ sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            myImageView.contentMode = .scaleAspectFit
            myImageView.image = pickedImage
            
            imageData = UIImageJPEGRepresentation(pickedImage, 1)
            
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion:nil)
    }
    
    func configure(_ contactFormState: ContactFormState, contactsStore: ContactsStore) {
        self.contactFormState = contactFormState
        self.contactsStore = contactsStore
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
        configureUI()

        imagePicker.delegate = self
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textFields.count + 1
    }
    
    // MARK: - Actions
    
    @IBAction func handleSaveWasTapped(_ sender: Any) {
        switch contactFormState {
        case .undefined:
            print("handle undefined")
        case .new:
            
            contactsStore.createContact(state: "", city: "", streetAddress1: "", streetAddress2: "", phoneNumber: phoneNumberTextField.text, firstName: firstNameTextField.text, lastName: lastNameTextField.text, zipcode: "", image: imageData)
        case .edit(let contact):
            
            contactsStore.update(contact: contact, state: "", city: "", streetAddress1: "", streetAddress2: "", phoneNumber: phoneNumberTextField.text, firstName: firstNameTextField.text, lastName: lastNameTextField.text, zipcode: "", image: imageData)
        }
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleBackgroundTapped(_ sender: Any) {
        view.endEditing(true)
    }
    
    // MARK: - UI Configuration
    
    private func configureUI() {
        textFields.forEach{ $0.delegate = self }
        switch contactFormState {
        case .undefined:
            return
        case .new:
            navigationItem.title = .addContact
        case .edit(let contact):
            navigationItem.title = .editContact
            fillTextFields(with: contact)
        }
        configureTableView()
    }
    
    private func fillTextFields(with contact: Contact) {
        firstNameTextField.text = contact.firstName
        lastNameTextField.text = contact.lastName
        phoneNumberTextField.text = contact.phoneNumber

    }
    
    private func configureTableView() {
        tableView.tableFooterView = UIView()
    }
}

extension ContactFormTableViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeTextField = textField
    }


    func textFieldDidEndEditing(_ textField: UITextField){
        activeTextField = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            phoneNumberTextField.becomeFirstResponder()
        } else if textField == phoneNumberTextField {
//            address1TextField.becomeFirstResponder()
            view.endEditing(true)
            
        }
        return true
    }
}

extension ContactFormTableViewController {
    private func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let navBarHeight = navigationController?.navigationBar.frame.size.height ?? 0
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height - navBarHeight, 0.0)
        
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        aRect.size.height -= navBarHeight
        guard let activeTextField = activeTextField,
            !aRect.contains(activeTextField.frame.origin) else  { return }
        tableView.scrollRectToVisible(activeTextField.frame, animated: true)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        tableView.contentInset = contentInsets
        tableView.scrollIndicatorInsets = contentInsets
    }
}
