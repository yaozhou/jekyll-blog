---
layout: post
category : google-breakpad 客户端部署
tagline: "Supporting tagline"
tags : [调试,google-breakpad]
---
{% include JB/setup %}


# google-breakpad客户端部署(windows平台）


### 版本
[google-breakpad revision 1120](http://code.google.com/p/google-breakpad/)

### 简介
google-breakpad提供了绝大部分平台上的崩溃处理，转储成统一的minidump格式，并且有配套的服务端socorro可以针对上传的minidump文件进行后续的堆栈解析、去重复、统计等功能。

本文简单介绍下怎样在windows平台下将google-break嵌入到vc工程中。（其他平台和语言暂未实验）

### 原理
google-breakpad通过在程序启动时调用

	SetUnhandledExceptionFilter()， _set_invalid_parameter_handler(),  _set_purecall_handler()

向系统注册了异常处理的回调函数，当异常发生时，回调函数得到运行，并生成了minidump文件。
其实仅从生成Minidump的角度来说，自己编码

	SetUnhandledExceptionFilter(myCallBack)
	然后在myCallBack中调用MinidumpWriteDump()
	
一样可以生成minidump文件，而之所以选择google-break的原因，是因为

1. google-breakpad支持进程外抓取dump的方式，意味着在一些极限情况下（如程序已经耗尽了某些系统资源，如内存、句柄等或者自身堆栈已经出错，而无力再运行任何其他代码时——包括抓取Minidump的代码),可以由另一个进程相对安全地读取这个这个崩溃进程的快照，并为其生成Minidump。 （不过因为条件太极端，没有实际模拟测试过）

2. 可以和socorro服务端配合使用。

（而相对的google-breakpad的多平台支持的特性却未被使用到，因为目前我们产品只运行在windows平台上）。

### 部署步骤
因为我已经对google-breakpad做了一些封装，如果不太关心细节的话，可以直接傻瓜式调用即可。

#### 1. 包含SMUtil.lib到工程中。
#### 2. 添加google-breakpad的include文件。
#### 3. 将crashSender.exe，upload_crash.bat和curl.exe拷贝到发行目录中（路径随意）

1. 此crashSender就是崩溃的时候弹出的一个对话框，征询用户是否同意发送crash文件的。目前还比较简陋，但后续会扩充，添加进一些比如问题描述，联系方式等新功能。
2. upload_crash.bat只是个调用了curl用于发送crash文件的批处理.其中需要修改的是引用curl的路径，以及生成LOG的路径

#### 4. 在自己的exe工程中（如果是DLL工程，则需要更改调用此dll的EXE工程）的初始化函数中，添加如下代码

		SM::ExceptionHandler * pHandler = new SM::ExceptionHandler() ;
		std::wstring versionStr = MethodToGetYourProductVersion() ;
		std::wstring submitUrl = MethodToGetYourCrashDumpServerSumbitUrl() ;
		std::wstring crashPath = your/path/to/store/minidump ;
		std::wstring crashSender = your/path/to/crashSender ;
		pHandler->Init(L"YourProductName", versionStr, submitUrl, crashPath, crashSender) ;

#### 写一个异常入测试
	int * p = NULL ;
	*p = 10 ;

直接运行EXE，会看到弹出对话框询问是否发送错误报告，同时在crashPath中也能看到刚产生的.dmp文件了。

如需进一步定制，或遇到问题，请联系我。	

[打包资源下载](http://s.yunio.com/9R99Tl)


















