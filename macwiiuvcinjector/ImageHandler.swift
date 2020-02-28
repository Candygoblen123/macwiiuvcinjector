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
    //let filem = FileManager()
    
    func icon(iconTex: String, base :String) {
        let imageMagic = Process()
        imageMagic.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/ImageMagick-7.0.9/bin/magick")
        
        imageMagic.arguments = [iconTex, "-resize","128x128\\!", "-depth", "32", "+compress", "\(base)/meta/iconTex.tga"]
        
        imageMagic.environment = ["MAGICK_HOME" : Bundle.main.resourcePath! + "/ImageMagick-7.0.9", "DYLD_LIBRARY_PATH" : Bundle.main.resourcePath! + "/ImageMagick-7.0.9/lib/"]
        
        do {
            try imageMagic.run()
            imageMagic.waitUntilExit()
        } catch {
            print(error)
        }
        
        let iconFile =  FileHandle(forWritingAtPath: "\(base)/meta/iconTex.tga")
        iconFile?.seekToEndOfFile()
        iconFile?.write(truevisionFileData)
    }
    
    func bootTv(bootTvTex: String, base :String) {
        let imageMagic = Process()
        imageMagic.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/ImageMagick-7.0.9/bin/magick")
        
        imageMagic.arguments = [bootTvTex, "-resize","1280x720\\!", "-depth", "24", "+compress", "-alpha", "off", "\(base)/meta/bootTvTex.tga"]
        
        imageMagic.environment = ["MAGICK_HOME" : Bundle.main.resourcePath! + "/ImageMagick-7.0.9", "DYLD_LIBRARY_PATH" : Bundle.main.resourcePath! + "/ImageMagick-7.0.9/lib/"]
        
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
        imageMagic2.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/ImageMagick-7.0.9/bin/magick")
        
        imageMagic2.arguments = [bootTvTex, "-resize", "854x480\\!", "-depth", "24", "+compress", "-alpha", "off", "\(base)/meta/bootDrcTex.tga"]
        
        imageMagic2.environment = ["MAGICK_HOME" : Bundle.main.resourcePath! + "/ImageMagick-7.0.9", "DYLD_LIBRARY_PATH" : Bundle.main.resourcePath! + "/ImageMagick-7.0.9/lib/"]
        
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


