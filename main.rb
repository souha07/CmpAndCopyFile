# coding: utf-8

# ソース元と比較先のフォルダ内にあるファイルをフォルダ構造に関係なくチェックし、
# ファイル内容が異なるものを出力先へコピーするスクリプトとなります。
# 簡単に言えば、フォルダに依存しない差分ファイル取得処理
# ファイル比較 -> コピー処理

require 'find'
require 'FileUtils'
require_relative './PathUtility'


###########################################################################
# ソースファイルパス名から比較用ファイルパス算出
###########################################################################
def SearchCmpPathFromSrcPathName( srcPathName, cmpFileList )

	srcFileName = File.basename( srcPathName ).downcase

	cmpPathName = cmpFileList.find do |item|
		cmpFileName = File.basename( item ).downcase
		cmpFileName == srcFileName
	end

	return cmpPathName
end


###########################################################################
# ファイルコピー（実行パスからの相対ディレクトリ生成込み）
###########################################################################
def FileCopyRelativePath( basePathName, srcPathName, dstDirName )

	relativePathName = GetRelativePath( srcPathName, basePathName )
	dstPathName = dstDirName + "\\" + relativePathName;

	FileUtils.mkdir_p( File.dirname( dstPathName ) )

	FileUtils.cp( srcPathName, dstPathName );
end




###########################################################################
# エントリポイント
###########################################################################

# コマンドライン引数チェック
if ARGV[0] == nil || ARGV[1] == nil || ARGV[2] == nil
    puts "コマンドライン引数が正しくありません"
	puts "実行exe名"
	puts "ソースフォルダ（コピー元フォルダ）"
	puts "比較先フォルダ"
	puts "出力先フォルダ"
	puts "となります"
    exit
end

srcDirName = GetAbsolutePath( ARGV[0].dup, Dir.pwd )
cmpDirName = GetAbsolutePath( ARGV[1].dup, Dir.pwd )
dstDirName = GetAbsolutePath( ARGV[2].dup, Dir.pwd )

#srcDirName = GetAbsolutePath( "./Test/Script/bin", Dir.pwd )
#cmpDirName = GetAbsolutePath( "./Test2/Script", Dir.pwd )
#dstDirName = GetAbsolutePath( "./Result/Script", Dir.pwd )


# コピー元ファイルリスト取得
p srcDirName
srcFileList = Array.new();
Find.find(srcDirName) do |f|
	next unless FileTest.file?(f)
	
	srcFileList.push( f );
end


# 比較先ファイルリスト取得
p cmpDirName
cmpFileList = Array.new();
Find.find(cmpDirName) do |f|
	next unless FileTest.file?(f)
	
	cmpFileList.push( f );
end


# 出力先フォルダ作成
FileUtils.mkdir_p( dstDirName ) 


# 比較・コピー処理
srcFileList.each do |pathName|
	
	cmpPathName = SearchCmpPathFromSrcPathName( pathName, cmpFileList )

	# -1 : none  0
	#  0 : not file
	#  1 : change file
	copyType = -1
	if cmpPathName == nil then
		copyType = 0
	else
		# ファイル内容チェック
		if FileUtils.cmp( pathName, cmpPathName ) == false then
			copyType = 1
		end
	end	


	if copyType != -1 then
		FileCopyRelativePath( srcDirName, pathName, dstDirName )
		if copyType == 0 then
			p "FileCopy(   Not File) : " + File.basename( pathName )
		else
			p "FileCopy(Change File) : " + File.basename( pathName )
		end
	end
end


p "Success"
