//
//  ArticleParser.swift
//  testTask
//
//  Created by David Dahina on 2/27/23.
//

import Foundation
class ArticleParser {
    static func parse(jsonData: Data) throws -> [Article] {
        let decoder = JSONDecoder()
        let stringArray = try decoder.decode([String].self, from: jsonData)

        var articles = [Article]()
        for jsonString in stringArray {
            let titleRegex = try! NSRegularExpression(pattern: #"title:(.*?)(?=,|$)"#)
            let firstImgRegex = try! NSRegularExpression(pattern: #"firstimg:(.*?)(?=,|$)"#)
            let secondImgRegex = try! NSRegularExpression(pattern: #"secondimg:(.*?)(?=,|$)"#)
            let thirdImgRegex = try! NSRegularExpression(pattern: #"thirdimg:(.*?)(?=,|$)"#)
            let detailsRegex = try! NSRegularExpression(pattern: #"details:(.*?)(?=,|$)"#)

            let titleRange = NSRange(jsonString.startIndex..<jsonString.endIndex, in: jsonString)
            let firstImgRange = NSRange(jsonString.startIndex..<jsonString.endIndex, in: jsonString)
            let secondImgRange = NSRange(jsonString.startIndex..<jsonString.endIndex, in: jsonString)
            let thirdImgRange = NSRange(jsonString.startIndex..<jsonString.endIndex, in: jsonString)
            let detailsRange = NSRange(jsonString.startIndex..<jsonString.endIndex, in: jsonString)

            let title = titleRegex.firstMatch(in: jsonString, options: [], range: titleRange)
                .map { String(jsonString[Range($0.range(at: 1), in: jsonString)!]) } ?? ""
            let firstImg = firstImgRegex.firstMatch(in: jsonString, options: [], range: firstImgRange)
                .map { URL(string: String(jsonString[Range($0.range(at: 1), in: jsonString)!])) } ?? nil
            let secondImg = secondImgRegex.firstMatch(in: jsonString, options: [], range: secondImgRange)
                .map { URL(string: String(jsonString[Range($0.range(at: 1), in: jsonString)!])) } ?? nil
            let thirdImg = thirdImgRegex.firstMatch(in: jsonString, options: [], range: thirdImgRange)
                .map { URL(string: String(jsonString[Range($0.range(at: 1), in: jsonString)!])) } ?? nil
            let details = detailsRegex.firstMatch(in: jsonString, options: [], range: detailsRange)
                .map { String(jsonString[Range($0.range(at: 1), in: jsonString)!]) } ?? ""

            let article = Article(title: title, firstImageURL: firstImg!, secondImageURL: secondImg!, thirdImageURL: thirdImg!, details: details)
            articles.append(article)
        }

        return articles
    }
}
