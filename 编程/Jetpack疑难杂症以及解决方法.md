# Jetpack疑难杂症以及解决方法

[Navigation修改版-避免生命周期重复回调](https://juejin.im/post/5ed75d6d6fb9a047ff1ab407)

`BottomNavigationView`在`Navigation`实践中的`FragmentNavigator`中，完成fragment切换，使用的是`fragmentManager.replace`方法，这样导致fragment会销毁重建，事实上我们更多的是只是想用hide、show这种隐藏显示的切换方式。

这篇文章定义了自定义FragmentNavigator，替换掉了replace方法，而是使用hide、show方法。

