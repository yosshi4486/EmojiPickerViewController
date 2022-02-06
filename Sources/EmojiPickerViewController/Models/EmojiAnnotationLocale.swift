//
//  EmojiAnnotationLocale.swift
//  
//
//  Created by yosshi4486 on 2022/02/06.
//

import Foundation

/**
 A locale for emoji's annotation.
 */
public struct EmojiAnnotationLocale {

    /**
     The default annotation locale. You can change the static default.
     */
    static let `default` = EmojiAnnotationLocale(languageIdentifier: "en")!

    /**
     Options are used in an initializer of`EmojiAnnotationLocale`.
     */
    public struct Options : OptionSet {

        public let rawValue: UInt

        /**
         The option that the locale should only use a language code.

         If you give "en_CA", [.useLanguageCodeOnly] to the initializer, the stored languageIdetifier is "en" which doesn't contain any script and region designator.
         */
        public static let useLanguageCodeOnly = Options(rawValue: 1 << 0)

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

    }

    /**
     The language identifier which the accosiated annotations and annotationDerived files exist.
     */
    public let languageIdentifier: String

    let annotationFileURL: URL

    let annotationDerivedFileURL: URL

    /**
     Creates an *Emoji Annotation Locale* instance by the given language identifier and options.

     - Parameters:
       - languageIdentifier: The language identifier for which loads annotations.
       - options: The options for which changes the initialization behavior.
     */
    public init?(languageIdentifier: String, options: Options = []) {

        let underscoredLanguageIdentifier = languageIdentifier.replacingOccurrences(of: "-", with: "_")
        let usedIdentifier: String = {

            if options.contains(.useLanguageCodeOnly), let languageCodeEndIndex = underscoredLanguageIdentifier.firstIndex(of: "_") {
                return String(underscoredLanguageIdentifier.prefix(upTo: languageCodeEndIndex))
            } else {
                return underscoredLanguageIdentifier
            }

        }()

        guard
            let annotationsFileURL =  Bundle.module.url(forResource: usedIdentifier, withExtension: "xml"),
            let annotationsDerivedFileURL = Bundle.module.url(forResource: "\(usedIdentifier)_derived", withExtension: "xml")
        else {
            return nil
        }

        self.languageIdentifier = usedIdentifier
        self.annotationFileURL = annotationsFileURL
        self.annotationDerivedFileURL = annotationsDerivedFileURL

    }

}
