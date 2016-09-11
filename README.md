简书地址：http://www.jianshu.com/users/3930920b505b/latest_articles
花了两周时间模仿了一下今日头条旗下的iOS端app内涵段子，相信大家对于这个app并不陌生。

##主要实现的功能如下：

- 首页 : 包括点赞、踩、分享、收藏，复制链接，视频的播放，上拉下拉，评论列表，关注列表
- 发现：轮播，热吧列表，推荐的关注用户列表，订阅列表，搜索，附近的人，附近的人的筛选，利用贝塞尔曲线自定义pageControl
- 审核：举报，喜欢和不喜欢，手动左滑刷新，利用贝塞尔曲线和CAShaperLayer加载视图动画
- 发布：选择热吧，发布图片文字
- 用户：用户信息写死在本地，模仿登录逻辑

##项目展示
####首页
![48FC5E6E-05BB-479A-BBE1-793B1DDEE6E6.png](http://upload-images.jianshu.io/upload_images/939127-19411aece532f9df.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![028DE1F5-D487-4EEC-A93A-A320CDA32F7A.png](http://upload-images.jianshu.io/upload_images/939127-719829be75514e93.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![2AC4DDEB-0A47-4918-B886-2FEAAD671364.png](http://upload-images.jianshu.io/upload_images/939127-901d853633b69ee4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####发现 
自定义无限轮播和利用贝塞尔曲线自定义pageControl切换
![35881BB7-8BEE-4C97-A5F2-4BEBF9FAC68F.png](http://upload-images.jianshu.io/upload_images/939127-72de6044f302ddb2.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![54C4141E-34ED-4F77-A16C-09D0046090B6.png](http://upload-images.jianshu.io/upload_images/939127-651a0bab013be178.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
![
![66449F19-ACE3-4289-84F2-BD59200658DB.png](http://upload-images.jianshu.io/upload_images/939127-5cdca7fae665cb2c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
](http://upload-images.jianshu.io/upload_images/939127-6ece1a19ec449ac3.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
附近段友
![60A319B9-D845-4938-8DDA-37D18ED9864A.png](http://upload-images.jianshu.io/upload_images/939127-1931e52b76c1abe0.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
####审核

![4677AAF1-2208-4FEB-8629-E9FA792C6F56.png](http://upload-images.jianshu.io/upload_images/939127-3156d356e2870549.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####用户

![
![
![26F59BD4-D94C-4A71-87C6-A2064DC43DFC.png](http://upload-images.jianshu.io/upload_images/939127-f68670df093faf32.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
](http://upload-images.jianshu.io/upload_images/939127-1c3332b919e615ca.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
](http://upload-images.jianshu.io/upload_images/939127-1b4b85b2fec59ecb.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


![
![DABCF75C-74A8-403D-A44B-3DD1160ABB34.png](http://upload-images.jianshu.io/upload_images/939127-9f8ae24ed2bb2b61.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
](http://upload-images.jianshu.io/upload_images/939127-ee44433a335a8dc8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###部分代码片段
直接上图了
####封装的tableViewController/tableView/tableViewCell

![
![屏幕快照 2016-09-11 下午6.41.17.png](http://upload-images.jianshu.io/upload_images/939127-0998bbaf560dcc53.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
](http://upload-images.jianshu.io/upload_images/939127-a1bacf518a6ad546.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
####部分动画实现

![屏幕快照 2016-09-11 下午5.45.58.png](http://upload-images.jianshu.io/upload_images/939127-59cd8800ccb5d5da.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


####部分列表展示类的实现

![屏幕快照 2016-09-11 下午5.44.11.png](http://upload-images.jianshu.io/upload_images/939127-50f29899af92e124.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)
####网络
![屏幕快照 2016-09-11 下午5.42.27.png](http://upload-images.jianshu.io/upload_images/939127-e7385af71db4d368.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

###分析和总结
- 这个项目做得时间比较仓促，前后用了不到两周的时间。
- 还有很多bug，不知道仔细看的朋友有没有意识到，这是用纯代码写的，并不是自己不习惯用nib或者sb，是因为一直以来想用纯代码写一个项目。
- 这个项目就告一段落，因为随着内涵段子的版本升级，越来越多的接口开始改用了https，没法抓到
- 内涵里面类似于分享的appkey，有的没申请下来，所以有的分享没实现，不过我觉得这都是小事情了，还有些接口抓不到，我只能模拟了一下网络请求。
- 下一阶段的方向大概是swift项目了，现在在着手一个swift小项目，前段时间写的，大概75%完成度了，也会在未来开源出来
- 最后，希望大家能够提出良好的建议和见解，如果想交朋友的可以加我qq3297391688，共同进步，成为一名真正的‘老司机’

附： 简书地址：
