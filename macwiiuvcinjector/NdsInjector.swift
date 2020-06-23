//
//  NdsInjector.swift
//  macwiiuvcinjector
//
//  Created by Andrew Glaze on 4/1/20.
//  Copyright © 2020 Candygoblen123. All rights reserved.
//

import Foundation
import Compression



class NdsInjector {
    let filem = FileManager()
    let file = GetFile()
    let jnustool = JnusTool()
    
    func inject(rom: String, iconTex: String, bootTvTex: String, titleId: String, titleKey: String, name: String) throws -> Bool {
        
        let outputDir = file.saveFile(name: name) + "/"
        
        if outputDir == "/" {
            throw InjectorError.noOutDirectory
        }
        
        let base: String
        do {
            base = try jnustool.get(titleId: titleId, titleKey: titleKey)
        }catch InjectorError.noJava{
            throw InjectorError.noJava
        }
        
        if !filem.fileExists(atPath: String(filem.temporaryDirectory.path) + "/jnustoolBase") {
            throw InjectorError.noJnustoolDownload
        }
        
        
        do{
            try filem.removeItem(atPath: base + "/content/0010/rom.zip")
            try filem.copyItem(atPath: rom, toPath: base + "/content/0010/WUP-N-INJT.srl")
            let zip = Process()
            zip.executableURL = URL(fileURLWithPath: Bundle.main.resourcePath! + "/tools/p7zip/7z")
            zip.arguments = ["a", base + "/content/0010/rom.zip", base + "/content/0010/WUP-N-INJT.srl"]
            try zip.run()
            zip.waitUntilExit()
            try filem.removeItem(atPath: base + "/content/0010/WUP-N-INJT.srl")
        }catch {
            print(error);
        }
        
        let dsConfig = """
        {
            "configuration": {
                "layouts": {
                    "layout": [
                        {
                            "screen": [
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "tv",
                                    "position": "512 106"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "tv",
                                    "position": "512 381"
                                },
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "drc",
                                    "position": "299 16"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "drc",
                                    "position": "299 283"
                                }
                            ],
                            "desc_string_id": "VCM_LAYOUT_1_EXPLANATION",
                            "background": [
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/nds1st_31p_tv.png",
                                    "target": "tv",
                                    "size": "1280 720"
                                },
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/nds1st_31p.png",
                                    "target": "drc",
                                    "size": "854 480"
                                }
                            ],
                            "name_string_id": "VCM_LAYOUT_1_NAME"
                        },
                        {
                            "screen": [
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "768 576",
                                    "target": "tv",
                                    "position": "110 72"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "tv",
                                    "position": "914 456"
                                },
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "512 384",
                                    "target": "drc",
                                    "position": "30 48"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "drc",
                                    "position": "568 240"
                                }
                            ],
                            "desc_string_id": "VCM_LAYOUT_2_EXPLANATION",
                            "background": [
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/tvback.png",
                                    "target": "tv",
                                    "size": "1280 720"
                                },
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/drcback.png",
                                    "target": "drc",
                                    "size": "854 480"
                                }
                            ],
                            "name_string_id": "VCM_LAYOUT_2_NAME"
                        },
                        {
                            "screen": [
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "768 576",
                                    "target": "tv",
                                    "position": "402 72"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "tv",
                                    "position": "110 456"
                                },
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "512 384",
                                    "target": "drc",
                                    "position": "312 48"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "drc",
                                    "position": "30 240"
                                }
                            ],
                            "desc_string_id": "VCM_LAYOUT_3_EXPLANATION",
                            "background": [
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/tvback.png",
                                    "target": "tv",
                                    "size": "1280 720"
                                },
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/drcback.png",
                                    "target": "drc",
                                    "size": "854 480"
                                }
                            ],
                            "name_string_id": "VCM_LAYOUT_3_NAME"
                        },
                        {
                            "screen": [
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "tv",
                                    "position": "110 72"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "768 576",
                                    "target": "tv",
                                    "position": "402 72"
                                },
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "drc",
                                    "position": "30 48"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "512 384",
                                    "target": "drc",
                                    "position": "312 48"
                                }
                            ],
                            "desc_string_id": "VCM_LAYOUT_4_EXPLANATION",
                            "background": [
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/tvback.png",
                                    "target": "tv",
                                    "size": "1280 720"
                                },
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/drcback.png",
                                    "target": "drc",
                                    "size": "854 480"
                                }
                            ],
                            "name_string_id": "VCM_LAYOUT_4_NAME"
                        },
                        {
                            "screen": [
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "tv",
                                    "position": "914 72"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "768 576",
                                    "target": "tv",
                                    "position": "110 72"
                                },
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "256 192",
                                    "target": "drc",
                                    "position": "568 48"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "512 384",
                                    "target": "drc",
                                    "position": "30 48"
                                }
                            ],
                            "desc_string_id": "VCM_LAYOUT_5_EXPLANATION",
                            "background": [
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/tvback.png",
                                    "target": "tv",
                                    "size": "1280 720"
                                },
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/drcback.png",
                                    "target": "drc",
                                    "size": "854 480"
                                }
                            ],
                            "name_string_id": "VCM_LAYOUT_5_NAME"
                        },
                        {
                            "pad_rotation": 90,
                            "drc_rotation": 90,
                            "screen": [
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "424 318",
                                    "target": "tv",
                                    "position": "428 11"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "424 318",
                                    "target": "tv",
                                    "position": "428 391"
                                },
                                {
                                    "source": "upper",
                                    "rotation": 270,
                                    "size": "360 480",
                                    "target": "drc",
                                    "position": "466 0"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 270,
                                    "size": "360 480",
                                    "target": "drc",
                                    "position": "28 0"
                                }
                            ],
                            "name_string_id": "VCM_LAYOUT_6_NAME",
                            "background": [
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/tvback.png",
                                    "target": "tv",
                                    "size": "1280 720"
                                },
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/drcback.png",
                                    "target": "drc",
                                    "size": "854 480"
                                }
                            ],
                            "desc_string_id": "VCM_LAYOUT_6_EXPLANATION"
                        },
                        {
                            "pad_rotation": 270,
                            "drc_rotation": 270,
                            "screen": [
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "424 318",
                                    "target": "tv",
                                    "position": "428 11"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "424 318",
                                    "target": "tv",
                                    "position": "428 391"
                                },
                                {
                                    "source": "upper",
                                    "rotation": 90,
                                    "size": "360 480",
                                    "target": "drc",
                                    "position": "28 0"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 90,
                                    "size": "360 480",
                                    "target": "drc",
                                    "position": "466 0"
                                }
                            ],
                            "name_string_id": "VCM_LAYOUT_7_NAME",
                            "background": [
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/tvback.png",
                                    "target": "tv",
                                    "size": "1280 720"
                                },
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/drcback.png",
                                    "target": "drc",
                                    "size": "854 480"
                                }
                            ],
                            "desc_string_id": "VCM_LAYOUT_7_EXPLANATION"
                        },
                        {
                            "pad_rotation": 270,
                            "drc_rotation": 0,
                            "screen": [
                                {
                                    "source": "upper",
                                    "rotation": 90,
                                    "size": "522 696",
                                    "target": "tv",
                                    "position": "64 12"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 90,
                                    "size": "522 696",
                                    "target": "tv",
                                    "position": "694 12"
                                },
                                {
                                    "source": "upper",
                                    "rotation": 90,
                                    "size": "360 480",
                                    "target": "drc",
                                    "position": "28 0"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 90,
                                    "size": "360 480",
                                    "target": "drc",
                                    "position": "466 0"
                                }
                            ],
                            "name_string_id": "VCM_LAYOUT_8_NAME",
                            "background": [
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/tvback.png",
                                    "target": "tv",
                                    "size": "1280 720"
                                },
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/drcback.png",
                                    "target": "drc",
                                    "size": "854 480"
                                }
                            ],
                            "desc_string_id": "VCM_LAYOUT_8_EXPLANATION"
                        },
                        {
                            "pad_rotation": 90,
                            "drc_rotation": 0,
                            "screen": [
                                {
                                    "source": "upper",
                                    "rotation": 270,
                                    "size": "522 696",
                                    "target": "tv",
                                    "position": "694 12"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 270,
                                    "size": "522 696",
                                    "target": "tv",
                                    "position": "64 12"
                                },
                                {
                                    "source": "upper",
                                    "rotation": 270,
                                    "size": "360 480",
                                    "target": "drc",
                                    "position": "466 0"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 270,
                                    "size": "360 480",
                                    "target": "drc",
                                    "position": "28 0"
                                }
                            ],
                            "name_string_id": "VCM_LAYOUT_9_NAME",
                            "background": [
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/tvback.png",
                                    "target": "tv",
                                    "size": "1280 720"
                                },
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/drcback.png",
                                    "target": "drc",
                                    "size": "854 480"
                                }
                            ],
                            "buttons_rotation": 0,
                            "desc_string_id": "VCM_LAYOUT_9_EXPLANATION"
                        },
                        {
                            "screen": [
                                {
                                    "source": "upper",
                                    "rotation": 0,
                                    "size": "928 696",
                                    "target": "tv",
                                    "position": "176 12"
                                },
                                {
                                    "source": "lower",
                                    "rotation": 0,
                                    "size": "640 480",
                                    "target": "drc",
                                    "position": "106 0"
                                }
                            ],
                            "desc_string_id": "VCM_LAYOUT_10_EXPLANATION",
                            "background": [
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/tvback.png",
                                    "target": "tv",
                                    "size": "1280 720"
                                },
                                {
                                    "position": "0 0",
                                    "rotation": 0,
                                    "resource": "//content_dir/assets/textures/drcback.png",
                                    "target": "drc",
                                    "size": "854 480"
                                }
                            ],
                            "name_string_id": "VCM_LAYOUT_10_NAME"
                        }
                    ],
                    "groups": [
                        1,
                        2,
                        2,
                        2,
                        2,
                        1
                    ]
                },
                "3DRendering": {
                    "Bilinear": 0,
                    "RenderScale": 1
                },
                "Display": {
                    "PixelArtUpscaler": 0,
                    "Brightness": 100
                },
                "arguments": {
                    "fold_on_pause": false,
                    "fold_on_resume_fade_from_black_duration": 1000,
                    "fold_on_pause_timeout": 3000
                }
            }
        }
        """
        
        do {
            try filem.removeItem(atPath: base + "/content/0010/configuration_cafe.json")
        } catch {
            print(error)
        }
        
        filem.createFile(atPath: base + "/content/0010/configuration_cafe.json", contents: dsConfig.data(using: .utf8))
        
        let dsPrams = """
        -- Contains parameters of VCMenu that can be changed according to the game

        -- Title platform
        platformId = "NTR"

        -- Title ID
        titleId = "INJT"

        -- Game region
        regionId = "USA"

        -- Available manual languages
        manual_languages = set{"J","E","S","F","P","G","I","D","R"}
        default_language = "J"

        -- Is vertical holding game
        verticalHolding = false

        -- List of layout groups for which the bilinear option is off (ie. pixel perfect layout groups)
        bilinearDisabledGroups = set{1, 4}

        -- List of layouts that should display NDS background (DRC & TV)
        displayNDSBackgroundLayout = set{1}

        -- Does the ROM use SRAM
        useSRAM = true
        """
        
        do {
            try filem.removeItem(atPath: base + "/content/0010/data/scripts/params.lua")
        } catch {
            print(error)
        }
        
        filem.createFile(atPath: base + "/content/0010/data/scripts/params.lua", contents: dsPrams.data(using: .utf8))
        
        // Replace xml files with our own
        XmlHandler().appXml(base: base)
        XmlHandler().metaXml(base: base, name: name, console: "nds")
        
        if !(filem.fileExists(atPath: "\(base)/code/app.xml") || filem.fileExists(atPath: "\(base)/meta/meta.xml")) {
            throw InjectorError.noXml
        }
        
        // replace the icon and bootscreens with the ones provided by the user
        ImageHandler().icon(iconTex: iconTex, base: base)
        ImageHandler().bootTv(bootTvTex: bootTvTex, base: base)
        
        if !(filem.fileExists(atPath: "\(base)/meta/icon.tga") || filem.fileExists(atPath: "\(base)/meta/bootTvTex.tga") || filem.fileExists(atPath: "\(base)/meta/bootDrcTex.tga")) {
            throw InjectorError.noIcon
        }
        
        //package and encrypt the game for installation
        NusPacker().pack(base: base, outputDir: outputDir)
        
        if try! filem.contentsOfDirectory(atPath: outputDir) == [] {
            throw InjectorError.noOutput
        }
        
        return true
    }
}

