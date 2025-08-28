
import Foundation

extension String {
    var asUrl: URL? {
        return URL(string: self)
    }
}
