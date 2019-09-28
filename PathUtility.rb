# coding: utf-8

require 'pathname'

# パス・URL用ユーティリティ

# ?, * などのパス・URLの変換
def ConvertDisableUrl( url, isDir = false )
    url.gsub!( "\\", "￥" )
    url.gsub!( "/", "・" )
    url.gsub!( ":", "：" )
    url.gsub!( "\"", "・" )
    url.gsub!( "<", "＜" )
    url.gsub!( ">", "＞" )
    url.gsub!( "(", "（" )
    url.gsub!( ")", "）" )
    url.gsub!( "|", "｜" )
    url.gsub!( "?", "？" )
    url.gsub!( "*", "＊" )
    if isDir == true
        url.gsub!( ".", "" )
    end

    return url
end


# 相対パスを絶対パスへ変換
def GetAbsolutePath( relativePathName, basePathName )

    # 相対パスチェック（絶対パスであれば変換なし）
    relativePath = Pathname( relativePathName )
    return relativePath if relativePath.absolute?

    path = Pathname( basePathName ).join( relativePath )
    return path.to_s
end


# 絶対パスを相対パスへ変換
def GetRelativePath( fullPathName, basePathName )

    fromPath = Pathname( basePathName )
    toPath = Pathname( fullPathName )

    return toPath.relative_path_from( fromPath ).to_s 
end
