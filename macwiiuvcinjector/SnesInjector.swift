//
//  SnesInjector.swift
//  macwiiuvcinjector
//
//  Created by Andrew Glaze on 2/12/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation

struct SnesInjector {
    let file = GetFile()
    
    func inject(rom: String, iconTex: String, tvTex: String, titleId: String, titleKey: String){
        let outputDir = file.saveFile() + "/"
        let jnustool = JnusTool()
        jnustool.get(titleId: titleId, titleKey: titleKey)
        
    }
}
