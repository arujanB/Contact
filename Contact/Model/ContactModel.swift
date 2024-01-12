import Foundation

struct ContactModel {
    let imgIcon: String
    let name: String
    let phoneNumber: String
    let additionalPhoneNumber: String?
    var typeOfContact: ContactType?
    let username: String
}

enum ContactType {
    case add
    case delete
}
