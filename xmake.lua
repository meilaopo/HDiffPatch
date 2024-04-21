

--[[
原Makefile阅读效率太低了，新增xmake编译方式
zstd相比其他几个有绝对优势，其他的压缩插件都禁用了
把zstd clone到HDiffPatch父目录即可（HDiffPatch，zstd同层）
]]


add_rules("mode.debug", "mode.release")
add_defines("_IS_NEED_BSDIFF=0")
add_defines("_IS_NEED_VCDIFF=0")
add_defines("_FILE_OFFSET_BITS=64")
add_defines("_IS_NEED_ALL_CompressPlugin=0")
add_defines("_IS_NEED_DEFAULT_CompressPlugin=0")
add_defines("_IS_NEED_ALL_ChecksumPlugin=0")
add_defines("_IS_NEED_DEFAULT_ChecksumPlugin=0")
add_defines("_IS_NEED_DIR_DIFF_PATCH=1")
add_defines("_ChecksumPlugin_fadler64=1")
add_defines("_CompressPlugin_zstd=1")

set_languages("c17", "cxx17")

add_includedirs("../zstd/lib")

target("zstd")
    set_enabled(true)
    set_kind("static")

    add_files("../zstd/lib/**.c")

target_end()

target("HDiffPatch")
    set_enabled(true)
    set_kind("static")

    add_deps("zstd")

    add_files("./libHDiffPatch/**.c")
    add_files("./libHDiffPatch/**.cpp")
    add_files("./libParallel/**.cpp")

target_end()


target("DifDiffPatch")
    set_enabled(true)
    set_kind("static")

    add_files("./dirDiffPatch/**.c")
    add_files("./dirDiffPatch/**.cpp")

    add_deps("HDiffPatch")

target_end()

target("hsync")
    set_enabled(true)
    set_kind("static")

    add_files("./libhsync/**.cpp")

target_end()

target("hdiffz")
    set_enabled(true)
    set_kind("binary")
 
    add_files("./hdiffz_import_patch.c")
    add_files("./file_for_patch.c")
    add_files("./hdiffz.cpp")

    add_files("./compress_parallel.cpp")


    add_deps( "DifDiffPatch")

target_end()


target("hpatchz")
    set_enabled(true)
    set_kind("binary")

    add_files("./hpatchz.c")
    add_files("./file_for_patch.c")

    add_deps( "DifDiffPatch")

target_end()
