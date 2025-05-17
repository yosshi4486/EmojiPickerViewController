#if os(Linux)
import Foundation

extension String {
    /// Fallback initializer for Linux where Foundation does not provide String(localized:bundle:comment:)
    init(localized key: String, bundle: Bundle, comment: StaticString) {
        self = bundle.localizedString(forKey: key, value: nil, table: nil)
    }
}
#endif
