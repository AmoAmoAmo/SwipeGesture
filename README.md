----------

# SwipeGesture
SwipeGesture and SearchBar

# 先看一下效果图吧：
![pic1](http://img.blog.csdn.net/20170706204234952?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvYTk5NzAxMzkxOQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)


这个部分是模仿高德地图搜索控件，需要注意的主要有两个地方：
1. 一是手势与tableView的scroll滑动冲突的问题
2. 还有一个就是searchBar的键盘以及searchBar在Editing状态下的动画问题
该项目主要解决的就是这些问题


## 1. 手势与tableView的scroll滑动冲突
另外新建一个视图控制器来控制tableView的滑动，用轻扫手势UISwipeGestureRecognizer来控制这个滑动动作。通过swipe的方法可以判断手势是向上滑还是向下滑，然后再重新设置tableView的位置。想法是这样，然而当运行的时候发现做手势的时候只有table里面的scroll在滑动，swipe手势并没有响应。这就是第一个问题：手势与tableView的scroll滑动冲突的问题。


## 2. searchBar的键盘以及searchBar在Editing状态下的动画问题
这里还有一个细节就是，收起键盘，不是用的一般常用的  endEditing:<#(BOOL)#>, 或resignFirstResponder ，因为searchBar封装的textField有点怪，当点击它状态变成编辑状态时，searchBar就跑出了它的父View，我感觉它是跑到了整个屏幕的最上面一层，所以使用上面说的两种方法收起键盘的时候，searchBar已经失去了控制，后面大部队再做动画、位移什么的，它就一直停留在自己原来的位置，比如这样的：

![](http://img.blog.csdn.net/20170706215731564?watermark/2/text/aHR0cDovL2Jsb2cuY3Nkbi5uZXQvYTk5NzAxMzkxOQ==/font/5a6L5L2T/fontsize/400/fill/I0JBQkFCMA==/dissolve/70/gravity/Center)


---
以上的方法是我目前能够想到并且可以完美解决我遇到的问题的方法，如果你还有其他方法，欢迎纠错

博客：[这里](http://blog.csdn.net/a997013919/article/details/74507068)
