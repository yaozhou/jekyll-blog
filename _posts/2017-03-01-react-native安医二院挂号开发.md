---
layout: post
category : 程序猿
tagline: ""
tags : [程序猿]
---
{% include JB/setup %}

很多时候我很庆幸自己这辈子干的是程序猿的工作，否则像去年老婆在安徽医科大学第二附属医院挂妇产科号，怎么也挂不上的时候，我一定都不知道该怎么办了。

安徽医科大学第二附属医院每天夜里12点放号，为了能让老婆休息好，每次需要产检时我都得12点守在电脑前，摩拳擦掌地准备着，一到12点就开始疯狂F5刷新，尼码，就这样还经常刷不到号.

那次夜里，疯狂一番刷新没刷到号后，有一种想把电脑砸掉的冲动，但是一瞬间鬼使神差地我点开了chrome的调试窗口，看了看其中交互的消息，突然一个念头冒了出来——来做个刷号软件呗！

于是花了几天时间，理了下其中交互的消息协议，好在一切都是http api,全都是透明的,没有任何秘密，用nodejs 结合http 包就搞定了。（后来才开始了解爬虫,也许用一些爬虫的库来做会更简单一些,虽然没有太大的差异)。

最初的版本运行在命令行中，操作虽不方便，但好歹可行。

而今年年初的时候，开始学习react native,做为练手项目，我又想起来了这个小的程序，何不把这个程序改改，写一个移动端的应用，然后分享出去给更多的人用，也让这款软件继续发挥它的价值？

于是又开始了100+小时的移动端开发，(其中被android后台常驻运行的坑坑了好久，最终放弃后台常驻运行的方案),最终有了下面这款自动挂号应用，目前只支持android版，不用问我为什么用react native开发的，不能同时支持IOS？没错，RN是同时支持android和IOS，可是我因为没钱买mac而无法开发IOS应用的事情，我会乱跟别人说？


<img src="http://dl.manmanqiusuo.com/hospital/start_page.jpg" width="360" height="640" />
应用的主界面


<img src="http://dl.manmanqiusuo.com/hospital/account.png" width="360" height="640" />
登录界面，需要 [健康之路](http://www.yihu.com/)的帐号和密码


<img src="http://dl.manmanqiusuo.com/hospital/conf.png" width="360" height="640" />
配置界面，配置需要预约的医生


<img src="http://dl.manmanqiusuo.com/hospital/about.png" width="360" height="640" />
关于界面

<img src="http://dl.manmanqiusuo.com/hospital/help.jpg" width="360" height="640" />
帮助界面


小乐预约助手 apk
[下载地址](http://dl.manmanqiusuo.com/yuyue_0.1.0.18.apk)

[github地址](https://github.com/yaozhou/hospital)

