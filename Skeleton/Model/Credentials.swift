import Foundation

protocol CredentialsProvider {
    var credentials: Credentials? { get }
}

struct Credentials {
    let accessToken: String
    let refreshToken: String
}

enum LoginCredentials {
    case password(username: String, password: String)
}
