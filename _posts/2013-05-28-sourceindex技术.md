---
layout: post
category : source index技术
tagline: "Supporting tagline"
tags : [调试,source index]
---
{% include JB/setup %}

### 应用场合
你是否碰到过这样的场合，远程调试时attach到测试人员的机器的程序上，或者在打开某个crash文件时，发现自己找不到其对应版本的pdb，并且本地的源码也已经发生了变化，而无法调试？虽然通过细致的管理（如保存每个版本的pdb，check out对应的源码)，可以解决此问题，但是很显然我们需要的是一个在exe,pdb,source code间的保持同步的机制。

### 具体方案
#### 在pdb和source code间保持同步
利用source index可以做到在pdb文件中嵌入额外的源码版本信息，以达到在pdb和对应版本源码之间保持同步的目的。

#### 在exe(crash文件)和pdb间保持同步
可以在局域网中建立一台符号服务器，保存每个版本的pdb文件，以达到在exe(crash文件)和pdb之间保持同步的目的。


### 具体步骤
#### 准备环境
安装debugging tools for windows（我用的是v6.12,其他版本未测试过), 添加其中的srcsrv目录到PATH中，方便调用其中的许多命令。

安装svn,推荐1.7版本以上（我用的是TortoiseSVN 1.7.12 64bit)，本文配置针对1.7（因为1.7修改了svn info的输出信息格式，因而需要稍改动下svn.pm文件）,确保svn.exe在PATH中，可以敲入命令svn info查看。

确保svn版本是英文版的，因为程序中会需要解析svn info的输出信息。

安装active perl,脚本中会用到。

修改srcsrv/svn.pm，在ln 208的 if ($FileRevision)后插入一行

	$LocalFile = "$SourceRoot\\$LocalFile"

#### source index(嵌入版本信息到pdb中)
程序测试结束后，准备发布前，先提交代码，先使得svn服务器有此版本的代码

	cd root\of\your\svn\repository
cd到svn仓库的根目录（虽然个人觉得这一步理论上并不是必须，只要能从当前目录及其子目录找到源码和版本之间的关系，哪怕只是一部分就可以了，但是实际使用中如果不是仓库的根目录，就不会成功）

	svnindex /debug /source=root\of\your\svn\repository /symbols=path\of\pdb
如能看到类似

	“ wrote C:\Users\ayao\AppData\Local\Temp\index103B1.stream to E:\Work\Project\LocalSvn\CrashTest\Debug\CrashTest.pdb ...”
表示pdb已经被嵌入了版本信息

也可以用以下命令验证
	srctool your\pdb\file
如果成功可看到类似输出

	[e:\work\project\localsvn\crashtest\main.cpp] cmd: cmd /c svn.exe cat "https://127.0.0.1:8443/svn/Test/CrashTest/main.cpp@7" --non-interactive > "E:\Work\Project\LocalSvn\svn\Test\CrashTest\main.cpp\7\main.cpp"

其实pdb文件是个开放的格式，其中的内容由不同的“流”组成，而微软提供的source index技术，就是在pdb中添加了一个名叫"srcsrv"的流，其中记录了这个PDB关联到的源文件在编译的时候在本地的地址，以及通过什么样的命令可以获取到，当vs在需要显示源码的时候，会先从看是否在能期待的路径中能找到源文件（这个期待的路径也就是程序被编译的时候的源码路径），如果找不到则会调用pdb中存储的命令行(**注意！！只有在找不到的时候才会触发源码下载的流程，否则会使用本地的源文件，哪怕文件版本不一致，被这个坑了好久。。**），执行之，（这时VS会弹出提示询问是否执行这个脚本），然后期待这个命令执行后，在临时目录中就能有这些文件的存在，然后显示之。

#### 生成用于socorro(崩溃转储服务端的sym文件)  (如果不用于socorro服务器，则不需要这一步)
[generate\-sym.bat下载](http://s.yunio.com/vecIze)

将上述几个文件放在要pdb目录中(相匹配的exe也需要同样存在这个目录里），运行generate\-sym.bat，顺利的话输出目录中会产生out目录，然后需要手工添加这些文件到socorro服务器中，原先考虑过在socorro服务器上同时添加ftp服务（或者SVN服务），然后可以方便上传这些符号文件，但觉得太倒腾，反正发布版本的频率也不会很高，手工拷过去算了。


### 发布pdb(建立符号服务器）
	symstore add /s \\pdb-server\pub_symbols /r /f path/to/pdb/\*pdb /t your-product-name
其中 "\\pdb-server\pub_symbols" 为一个局域网中的共享目录（使得大家都能从此目录下载pdb文件），同时自己需要有这个目录的写权限

### 客户端设置
需要相应地设置VS以使用这些功能
#### 添加符号服务器地址
option -> Debugging -> Symbols 中添加 Symbol file (.pdb) locations    "\\pdb-server\pub_symbols"
#### 打开source server支持
option -> Debugging -> General ->
勾选 Enable source server support 及其子选项 Print source server diagnostic messages to the Output window







### 参考链接
http://www.hufuman.biz/?tag=symstore

###相关资源下载
[ActivePerl-5.16.3.1603-MSWin32-x64-296746.msi](http://s.yunio.com/uemSbE")

[Debugging Tools for Windows (x64) v6.12.zip](http://s.yunio.com/zoUV5v)

[Debugging Tools for Windows (x86) v6.12.zip](http://s.yunio.com/cE4hko")

[TortoiseSVN_x64_1_7_12.msi](http://s.yunio.com/CKBkUF)

