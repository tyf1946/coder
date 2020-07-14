# LiveData , DataBinding以及场景
### 没搞清的问题
在使用`ReacycleView`时，小弟问了一个问题，把我弄混淆了。在`Adapter`中使用的数据，是用DataBinding中的BaseObserve还是用一个LiveData，还是用一个ViewModel包含LiveData，好像是用不同方式来驱动UI进行更新。

我被问的懵了一下，感觉哪里不对，又有点说不出来。便按下重新合计了一下，写了这篇。
本质上：问题混淆了，将LiveData , DataBinding的确都是和数据和UI响应相关的，但混在一起，就造成了迷惑。

### 从头开始屡清楚
	工具是基于解决什么而使用，而不是使用而使用
```
LiveData：是解决数据响应和组件生命周期不协同。
DataBinding：是解决数据和UI绑定，数据改变可以及时同步到UI更改上。
```
~~所以，虽然都是和`Observe`相关，但完全不是一回儿事情~~
我们常用的模式是：Activity/Fragment → ViewModel （LiveData）。
为什么呢？因为Activity/Fragment是生命周期组件，当我们的数据在VM中需要响应这些生命周期，我们自己处理这些响应，需要处理不同周期的注册，移除，响应，等操作，成本太高所以才有了LiveData来统一处理关于生命周期，而我们只需要注册数据变更之后的响应就够了。
其实，最本质的仍然是，生命周期，对于生命周期的响应，使用LiveData或者自己注册LifecycleObserver进行处理。LiveData响应的主体，是自己定义的Observer，虽然大多数情况是响应更新UI，但操作是要代码去执行的，而非自动的。而DataBinding上，则是自动响应的。
也可以理解为，这是不同阶段做出的响应。

### 二者结合起来
其实我们想要的是，数据能根据生命周期响应改变，同时也能直接体现在UI上，而不需要我们再次代码编写改变，也就是绑定。响应生命周期和绑定数据同时同步实现，该怎么搞。
想想，我们的要求貌似也不复杂，都是google的jetpack成员，这俩就没个内部实现吗？
事实上：还真有！ViewDataBinding#LiveDataListener
```java
ViewDataBinding#LiveDataListener

private static class LiveDataListener implements Observer,
        ObservableReference<LiveData<?>> {
    final WeakListener<LiveData<?>> mListener;
    LifecycleOwner mLifecycleOwner;

    public LiveDataListener(ViewDataBinding binder, int localFieldId) {
        mListener = new WeakListener(binder, localFieldId, this);
    }

    @Override
    public void setLifecycleOwner(LifecycleOwner lifecycleOwner) {
        LifecycleOwner owner = (LifecycleOwner) lifecycleOwner;
        LiveData<?> liveData = mListener.getTarget();
        if (liveData != null) {
            if (mLifecycleOwner != null) {
                liveData.removeObserver(this);
            }
            if (lifecycleOwner != null) {
                liveData.observe(owner, this);
            }
        }
        mLifecycleOwner = owner;
    }

    @Override
    public WeakListener<LiveData<?>> getListener() {
        return mListener;
    }

    @Override
    public void addListener(LiveData<?> target) {
        if (mLifecycleOwner != null) {
            target.observe(mLifecycleOwner, this);
        }
    }

    @Override
    public void removeListener(LiveData<?> target) {
        target.removeObserver(this);
    }

    @Override
    public void onChanged(@Nullable Object o) {
        ViewDataBinding binder = mListener.getBinder();
        if (binder != null) {
            binder.handleFieldChange(mListener.mLocalFieldId, mListener.getTarget(), 0);
        }
    }
}
```
源码很简单，`target.observe(mLifecycleOwner, this);`，和我们使用LiveData一样，当数据更新且生命周期状态合适，则通知响应。而`binder.handleFieldChange(mListener.mLocalFieldId, mListener.getTarget(), 0);`则是执行更新。
具体我们如何使用呢？
在布局文件中，引入viewModel后，关联使用。
```
<android.support.design.widget.TextInputEditText
    android:text="@{viewModel.commentText}" />

# 需拆箱，如Int，Float等基础类
android:text="@{safeUnbox(viewModel.age)}"
```

如果只是字段更新了呢？继承BaseObservable，然后`notifyPropertyChanged(BR.url)`便可以更新界面













#代码