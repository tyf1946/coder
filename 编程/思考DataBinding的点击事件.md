# 思考DataBinding的点击事件
### 基于`databinding`的点击方式
```
# xml
<Button
     android:layout_width="match_parent"
     android:layout_height="48dp"
     android:onClick="@{() -> viewModel.click()}"
/>

// viewmodel 
public void click(){
}
```
当然，基于参数和缩写等方式，也有其他展示方式，但原理是相同的。
```
#xml 
android:onClick="@{viewModel::click}
android:onClick="@{(view)->listener.onCheckBoxClick(obj,view)}"
```
### 本质
看一下`databinding`自动生成的代码(省略掉无关代码后)
```java
	 ......
    private final android.view.View.OnClickListener mCallback2;
    // values
    // listeners
    // Inverse Binding Event Handlers

    @Override
    protected void executeBindings() {
        HomeViewModel home = mHome;
        // batch finished
        if ((dirtyFlags & 0x4L) != 0) {
            this.mboundView1.setOnClickListener(mCallback2);
        }
    }
    // Listener Stub Implementations
    // callback impls
    public final void _internalCallbackOnClick(int sourceId , android.view.View callbackArg_0) {
        HomeViewModel home = mHome;
        homeJavaLangObjectNull = (home) != (null);
        if (homeJavaLangObjectNull) {
            home.loadNextPage();
        }
    }
......
}
```
很简单，就是将我们平时撰写的`setOnClickListener `样本代码由系统生成。
这里清楚之后，思考一下，点击事件在databinding中如何管理使用呢？
### 管理事件
基于jetpack的很多工具和库的思考方式是：**分离关注点**和**基于数据驱动界面**。
在这两个原则之上，`viewmodel`是jetpack所推崇的实践模式。
因此，`ViewModel`承接点击后的事件处理的正统。
但实际业务开发中，并没想象中那么容易分离。`ViewModel`有一个很重要的原则，不关注Android系统。翻译一下就是，`ViewModel`中不能出现Android系统框架下的`activity`，`fragment`，`context`等。一切对界面的驱动都是由更改数据完成的。（这里对数据便有了一个特殊要求，要和界面状态保持绑定）


这里，还要补充一点。对于列表数据，建议全部由viewmodel组成。




