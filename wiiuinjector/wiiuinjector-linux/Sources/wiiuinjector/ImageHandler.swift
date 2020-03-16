//
//  ImageHandler.swift
//  macwiiuvcinjector
//
//  Created by Candygoblen123 on 2/27/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation

struct ImageHandler {
    // The wii u expects this data to be appended to the end of every tga file
    let truevisionFileData = Data([0, 0, 0, 0, 0, 0, 0, 0, 84, 82, 85, 69, 86, 73, 83, 73, 79, 78, 45, 88, 70, 73, 76, 69, 46, 0])
    
    func icon(iconTex: String, base :String) {
        //convert png icon to a wii u compadible tga icon
        //set up a inagemagick process
        let imageMagic = Process()
        imageMagic.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/tools/magick")
        
        //arguements needed to convert to a wii u compatible icon
        imageMagic.arguments = [iconTex, "-resize", #"128x128\!"#, "-depth", "32", "+compress", "-orient", "BottomLeft", "-flip", "\(base)/meta/iconTex.tga"]
        
        
        
        do {
            try imageMagic.run()
            //wait until imagemagick is done
            imageMagic.waitUntilExit()
        } catch {
            print(error)
        }
        
        //append truevisionFileData to the iconTex file, so that it will work with the wii u
        let iconFile =  FileHandle(forWritingAtPath: "\(base)/meta/iconTex.tga")
        iconFile?.seekToEndOfFile()
        iconFile?.write(truevisionFileData)
    }
    
    func bootTv(bootTvTex: String, base :String) {
        //convert png bootTvTex to a wii u compadible tga bootTvTex and bootDrcTex
        let imageMagic = Process()
        imageMagic.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/tools/magick")
        
        imageMagic.arguments = [bootTvTex, "-resize", #"1280x720\!"# , "-depth", "24", "+compress", "-alpha", "off", "-orient", "BottomLeft", "-flip", "\(base)/meta/bootTvTex.tga"]
        
        do {
            try imageMagic.run()
            imageMagic.waitUntilExit()
        } catch {
            print(error)
        }
        
        let bootTvFile =  FileHandle(forWritingAtPath: "\(base)/meta/bootTvTex.tga")
        bootTvFile?.seekToEndOfFile()
        bootTvFile?.write(truevisionFileData)
        
        let imageMagic2 = Process()
        imageMagic2.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/tools/magick")
        
        imageMagic2.arguments = [bootTvTex, "-resize", #"854x480\!"#, "-depth", "24", "+compress", "-alpha", "off", "-orient", "BottomLeft", "-flip", "\(base)/meta/bootDrcTex.tga"]
        
        do {
            try imageMagic2.run()
            imageMagic2.waitUntilExit()
        } catch {
            print(error)
        }
        
        let bootDrcFile =  FileHandle(forWritingAtPath: "\(base)/meta/bootDrcTex.tga")
        bootDrcFile?.seekToEndOfFile()
        bootDrcFile?.write(truevisionFileData)
    }
}


