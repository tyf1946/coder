#  聊聊androidx.lifecycle

### 定义和解读
官方定义镇楼：生命周期感知型组件可执行操作来响应另一个组件（如 Activity 和 Fragment）的生命周期状态的变化。
定义，基本上是大白话，不需要再强行解释，核心作用就是使用androidx.lifecycle可以自动适应UI的生命周期变化。

问：那这个lifecycle组件要解决的实际问题是什么？换句话说，为什么我们需要自动适应组件（如 Activity 和 Fragment）的生命周期呢？
再讨论之前，我们仍然是要强调一下JetPack的原则：**分离关注点**和**基于数据驱动界面**。

事实上，在没有lifecycle之前，当我们遇到很多需要响应生命周期的操作的时候（尤其是复杂界面），在类似于onResume，onPause，onXX,onXX等方法里，我们会处理大量数据和逻辑来适应。但这种模式的写法有3个问题：
1. 条理性很差,各种操作混杂一起
2. 扩散极易出错
3. 内存管理复杂，容易溢出
```kotlin
internal class MyLocationListener(
            private val context: Context,
            private val callback: (Location) -> Unit
    ) {

        fun start() {
            // connect to system location service
        }

        fun stop() {
            // disconnect from system location service
        }
    }

    class MyActivity : AppCompatActivity() {
        private lateinit var myLocationListener: MyLocationListener

        override fun onCreate(...) {
            myLocationListener = MyLocationListener(this) { location ->
                // update UI
            }
        }

        public override fun onStart() {
            super.onStart()
            myLocationListener.start()
            // manage other components that need to respond
            // to the activity lifecycle
        }

        public override fun onStop() {
            super.onStop()
            myLocationListener.stop()
            // manage other components that need to respond
            // to the activity lifecycle
			 // ... more action
        }
    }

```

上述就是一个典型的。在我们需要执行长时间运行的操作时尤其如此。这可能会导致出现一种竞争条件，在这种条件下，onStop可能会在 onStart  之前结束，这使得组件留存的时间比所需的时间要长，导致溢出。

而lifecycle是来解决这个问题的，它提供了一种很优雅的方式。

### 使用
```kotlin
internal class MyLocationListener(
            private val context: Context,
            private val lifecycle: Lifecycle,
            private val callback: (Location) -> Unit
    ) {

        private var enabled = false

        @OnLifecycleEvent(Lifecycle.Event.ON_START)
        fun start() {
            if (enabled) {
                // connect
            }
        }

        fun enable() {
            enabled = true
            if (lifecycle.currentState.isAtLeast(Lifecycle.State.STARTED)) {
                // connect if not connected
            }
        }

        @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
        fun stop() {
            // disconnect if connected
        }
    }

class MyObserver : LifecycleObserver {

        @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
        fun connectListener() {
            ...
        }

        @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
        fun disconnectListener() {
            ...
        }
    }

    myLifecycleOwner.getLifecycle().addObserver(MyObserver())
```

1. 注解的方式，可以直接绑定到特定生命周期，自动适应UI的生命周期变化。
2. 各个组件，存储自己的逻辑，分离关注。
3. lifecycle可以返回生命周期状态，来更好为逻辑服务。

### 实际项目
1. （Activity 和 Fragment）不能获取数据，作为展示的担当，他俩的核心责任还是关注在UI上
2. 由ViewModel来承担驱动，通过VM来驱动界面更新（可以通过LiveData实现观察更新，LiveData天生适应lifecycle）
3. 将数据逻辑放在  ViewModel类中。充当界面控制器与应用其余部分之间的连接器。
4. VM不直接获取数据，而是通过数据仓库获取。
5. 可以使用  [Data Binding]处理UI接口，是（Activity 和 Fragment）更加简洁干净。


#