# Jetpack疑难杂症以及解决方法

~~[Navigation修改版-避免生命周期重复回调](https://juejin.im/post/5ed75d6d6fb9a047ff1ab407)~~

```
已过期
`BottomNavigationView`在`Navigation`实践中的`FragmentNavigator`中，完成fragment切换，使用的是`fragmentManager.replace`方法，这样导致fragment会销毁重建，事实上我们更多的是只是想用hide、show这种隐藏显示的切换方式。

这篇文章定义了自定义FragmentNavigator，替换掉了replace方法，而是使用hide、show方法。


```

又重新找了找官网，在官网的高级用法示例中，发现了另外一种解法。

`NavigationAdvancedSampl`项目中提供了`NavigationExtensions.kt`扩展，能保持界面状态，但生命周期依然会执行。

所以，仍然会留下问题，就是拓展后的数据无法保留，界面操作的状态也无法保留。（当然数据如果延展到vm中是保留的，但同时滚动状态等未能保留）

