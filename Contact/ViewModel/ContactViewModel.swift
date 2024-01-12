import Foundation
import Contacts
import UIKit

struct ContactViewModel {
    private let contactStore = CNContactStore()
    var contactsFromPhone: [ContactModel] = []
    var sortedArray = [ContactModel]()
    var isSearched = false
    
//    let listOfContact: [ContactModel] = [
//        ContactModel(imgIcon: "avatar", name: "Ергали", phoneNumber: "+7 (701) 839 39 04", additionalPhoneNumber: nil, typeOfContact: .delete, username: "@ergali"),
//        ContactModel(imgIcon: "avatar1", name: "Ансар", phoneNumber: "+7 (777) 298 12 53", additionalPhoneNumber: nil, typeOfContact: .add, username: "@ansar"),
//        ContactModel(imgIcon: "avatar2", name: "Баке", phoneNumber: "+7 (707) 283 66 29", additionalPhoneNumber: nil, typeOfContact: .add, username: "@bake"),
//        ContactModel(imgIcon: "avatar3", name: "Ермек", phoneNumber: "+7 (701) 965 04 46", additionalPhoneNumber: nil, typeOfContact: .add, username: "@ermek"),
//        ContactModel(imgIcon: "avatar4", name: "Асем", phoneNumber: "+7 (702) 374 83 12", additionalPhoneNumber: nil, typeOfContact: .add, username: "@asem"),
//        ContactModel(imgIcon: "avatar5", name: "Айдар", phoneNumber: "+7 (702) 374 83 12", additionalPhoneNumber: nil, typeOfContact: .add, username: "@aidar"),
//        ContactModel(imgIcon: "avatar5", name: "Асылжан", phoneNumber: "+7 (701) 839 39 04", additionalPhoneNumber: nil, typeOfContact: .add, username: "@asylzhan"),
//        ContactModel(imgIcon: "avatar5", name: "Акылбек", phoneNumber: "+7 (701) 839 39 04", additionalPhoneNumber: nil, typeOfContact: .add, username: "@akylbek"),
//        ContactModel(imgIcon: "avatar5", name: "Ержан", phoneNumber: "+7 (701) 839 39 04", additionalPhoneNumber: nil, typeOfContact: .add, username: "@erzhan"),
//        ContactModel(imgIcon: "avatar5", name: "Ерлан", phoneNumber: "+7 (701) 839 39 04", additionalPhoneNumber: nil, typeOfContact: .add, username: "@erlan"),
//    ]
    
    // MARK: - searchBar customize color
    func customizeSearchBar(searchButton: UISearchBar) {
        if let searchBar = searchButton.value(forKey: "searchField") as? UITextField {
            searchBar.textColor = .white
            searchBar.leftView?.tintColor = .white
        }
    }
    
    mutating func searchByUsername(searchText: String) {
        sortedArray = contactsFromPhone.filter({
//            guard let addition = $0.additionalPhoneNumber else { fatalError() }
//            $0.username.prefix(searchText.count) == searchText
            if $0.username.first == "@", searchText.first == "@" {
                $0.username.contains(searchText)
            }else if $0.phoneNumber.contains(searchText)/*, addition.contains(searchText)*/ {
                $0.phoneNumber.contains(searchText)
            }else {
                $0.phoneNumber.contains(searchText)
            }
        })
        isSearched = true
    }
    
    // MARK: - getContacts date
    mutating func fetchAllContacts() -> [ContactModel] {
        let keysToFetch = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey, CNContactNicknameKey] as [CNKeyDescriptor]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        do {
            try contactStore.enumerateContacts(with: fetchRequest) { contact, stop in
                var number = ""
                var numberString: [String] = []
                for phoneNumber in contact.phoneNumbers {
                    number = phoneNumber.value.stringValue
                    numberString.append(number)
                }
                contactsFromPhone.append(ContactModel(imgIcon: "", name: contact.givenName, phoneNumber: numberString[0], additionalPhoneNumber: numberString.count == 1 ? "" : numberString[1], typeOfContact: .add, username: "@\(contact.givenName.lowercased())"))
            }
        } catch {
            print("Error fetching contacts: \(error)")
        }
        return contactsFromPhone
    }
}
