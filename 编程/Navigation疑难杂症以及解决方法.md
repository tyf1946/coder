# Jetpack-Navigation疑难杂症以及解决方法

~~[Navigation修改版-避免生命周期重复回调](https://juejin.im/post/5ed75d6d6fb9a047ff1ab407)~~

```
已过期
`BottomNavigationView`在`Navigation`实践中的`FragmentNavigator`中，完成fragment切换，使用的是`fragmentManager.replace`方法，这样导致fragment会销毁重建，事实上我们更多的是只是想用hide、show这种隐藏显示的切换方式。

这篇文章定义了自定义FragmentNavigator，替换掉了replace方法，而是使用hide、show方法。


```

又重新找了找官网，在官网的高级用法示例中，发现了另外一种解法。

`NavigationAdvancedSampl`项目中提供了`NavigationExtensions.kt`扩展，能保持界面状态，但生命周期依然会执行销毁UI的部分，切换回来后，UI状态也是返回。

所以，仍然会留下问题，就是拓展后的数据必须在Fragment的UI周期之外，换句话说，必须有VM或者Presnter承接，所以数据所有相关的会留在VM中处理，而UI相关的，Fragment会自己承接。



但这里仍然留有一个坑，就是如此操作下，每个meau下，都是自己独立的，返回也是相互独立的。这里要注意，独立的返回栈会使singleTop这样的配置失效。



```
FragmentTransaction有一些基本方法，下面给出调用这些方法时，Fragment生命周期的变化：

add(): onAttach()->onCreate()->onCreateView()->onActivityCreated()->onStart()->onResume()，在执行add（）时，同一个Fragment不允许被add()两次

remove(): onPause()->onStop()->onDestroyView()->onDestroy()->onDetach()。

replace():相当于新Fragment调用add()，旧Fragment调用remove(), replace() 方法不会保留 Fragment 的状态，也就是说诸如 EditText 内容输入等用户操作在 remove() 时会消失。分为两种情况

不加addToBackStack（）: new  onAttach() -> new onCreate() -> old  onPause()-> old onStop()-> old onDestroyView()-> old onDestroy()-> old onDetach() -> new onCreateView() -> new  onActivityCreated() -> new  onStart()。

加addToBackStack（）: new  onAttach() -> new onCreate() -> old  onPause()-> old onStop()-> old onDestroyView() -> new  onCreateView -> new  onActivityCreated() -> new  onStart()。

show(): 不调用任何生命周期方法，调用该方法的前提是要显示的Fragment已经被添加到容器，只是纯粹把Fragment UI的setVisibility为true。
hide(): 不调用任何生命周期方法，调用该方法的前提是要显示的Fragment已经被添加到容器，只是纯粹把Fragment UI的setVisibility为false。

detach(): onPause()->onStop()->onDestroyView()。

Detach the given fragment from the UI. This is the same state as when it is put on the back stack: the fragment is removed from the UI, however its state is still being actively managed by the fragment manager. When going into this state its view hierarchy is destroyed.。从中可以看出detach仅仅是销毁fragment的UI，Fragment还被fragmentManager管理。

attach(): onCreateView() -> onActivityCreated -> onStart() -> onResume()。
Re-attach a fragment after it had previously been detached from the UI with detach(android.app.Fragment).意思就是attach重新添加是被detach销毁的fragment.

commit():提交事务·每次提交之前，必须通过mFragmentManager.beginTransaction()重新开始一个事务。

```



