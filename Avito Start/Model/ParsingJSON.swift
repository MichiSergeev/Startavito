//
//  ParsingJSON.swift
//  avito1
//
//  Created by Mikhail Sergeev on 15.01.2021.
//

import Foundation

struct Parsing {
    
    // MARK: - Structure Methods
    static func parsingJSON() -> TopLevelJSON? {
        guard let url = Bundle.main.url(forResource: JSONFileName.fileName,
                                        withExtension: JSONFileName.fileExtension),
              let data = try? Data(contentsOf: url),
              let json = try? JSONDecoder().decode(TopLevelJSON.self, from: data) else {return nil}
        
        return json
    }
}
