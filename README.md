# JZPhone
怎样将Linphone移植到自己的项目

> 移植指南欢迎点击[我的简书](http://www.jianshu.com/p/845cd812fcd7)或者[www.kohmax.com](www.kohmax.com)


那么如何使用该代码？

### 1. 下载、解压项目

### 2. 打开workspace文件


<img src="http://7xusmm.com1.z0.glb.clouddn.com/mdJozo/1468382927487.png" width="212"/>


### 3. 关联sdk
不出意外会发现该处飘红，且跑起来提示找不到`UCSIPCCManager.h`的头文件

<img src="http://7xusmm.com1.z0.glb.clouddn.com/mdJozo/1468383179375.png" width="252"/>

找到sdk里的Products -> show in Finder

<img src="http://7xusmm.com1.z0.glb.clouddn.com/mdJozo/1468383251517.png" width="367"/>

把.a库和三个头文件都拖到Demo飘红处，然后删除飘红的文件

<img src="http://7xusmm.com1.z0.glb.clouddn.com/mdJozo/1468383271715.png" width="588"/>

<img src="http://7xusmm.com1.z0.glb.clouddn.com/mdJozo/1468383372409.png" width="730"/>

然后就跑起来吧。

