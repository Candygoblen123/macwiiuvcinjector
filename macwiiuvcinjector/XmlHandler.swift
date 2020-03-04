//
//  XmlHandler.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/26/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation
let filem = FileManager()
// create a new, randomized titleid
let newTitleId = "00050000" + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10)) + String(Int.random(in: 0 ..< 10))

class XmlHandler {

    func appXml(base :String) {
        // phrase app.xml, set a new titleid, then overwrite with our new app.xml
        guard let appXml = XML(contentsOf: URL(fileURLWithPath: "\(base)/code/app.xml")) else {return}
        
        appXml[0]["title_id"]?.text = newTitleId
        
        // pretty formatting (may not be required)
        var str :String = ""
        if let xml = try? XMLDocument.init(xmlString: appXml.description) {
           let data = xml.xmlData(options:.nodePrettyPrint)
           str = String(data: data, encoding: .utf8)!
        }
        
        do {
            try filem.removeItem(atPath: "\(base)/code/app.xml")
        }catch {
            print("could not delete app.xml")
        }
        filem.createFile(atPath: "\(base)/code/app.xml", contents: str.data(using: .utf8))
    }
    
    func metaXml(base: String, name: String) {
        // phrase meta.xml, set a new titleid and name, then overwrite with our new meta.xml
         guard let metaXml = XML(contentsOf: URL(fileURLWithPath: "\(base)/meta/meta.xml")) else {return}
        
        metaXml[0]["title_id"]?.text = newTitleId
        metaXml[0]["longname_ja"]?.text = name
        metaXml[0]["longname_en"]?.text = name
        metaXml[0]["longname_fr"]?.text = name
        metaXml[0]["longname_de"]?.text = name
        metaXml[0]["longname_it"]?.text = name
        metaXml[0]["longname_es"]?.text = name
        metaXml[0]["longname_zhs"]?.text = name
        metaXml[0]["longname_ko"]?.text = name
        metaXml[0]["longname_nl"]?.text = name
        metaXml[0]["longname_pt"]?.text = name
        metaXml[0]["longname_ru"]?.text = name
        metaXml[0]["longname_zht"]?.text = name
        
        metaXml[0]["shortname_ja"]?.text = name
        metaXml[0]["shortname_en"]?.text = name
        metaXml[0]["shortname_fr"]?.text = name
        metaXml[0]["shortname_de"]?.text = name
        metaXml[0]["shortname_it"]?.text = name
        metaXml[0]["shortname_es"]?.text = name
        metaXml[0]["shortname_zhs"]?.text = name
        metaXml[0]["shortname_ko"]?.text = name
        metaXml[0]["shortname_nl"]?.text = name
        metaXml[0]["shortname_pt"]?.text = name
        metaXml[0]["shortname_ru"]?.text = name
        metaXml[0]["shortname_zht"]?.text = name
        
        // pretty formatting (may not be required)
        var str :String = ""
        if let xml = try? XMLDocument.init(xmlString: metaXml.description) {
           let data = xml.xmlData(options:.nodePrettyPrint)
           str = String(data: data, encoding: .utf8)!
        }
        
        //replace old xml with our new one
        do {
            try filem.removeItem(atPath: "\(base)/meta/meta.xml")
        }catch {
            print("could not delete meta.xml")
        }
        filem.createFile(atPath: "\(base)/meta/meta.xml", contents: str.data(using: .utf8))
      
      
    }
}
