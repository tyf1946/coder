# Retrofit和Okhttp的碎碎念
### 那么，问题是什么？
Android现在特别流行的网络组合模式: Retrofit + Okhttp + Rxjava + Gson 。一套完整的组合拳下来，网络问题已不成问题了。
那么问题来了，这些到底是什么？
* Retrofit 是网络层框架
* Okhttp 是网络库，或者网络依赖
* Rxjava 是基于响应链式编程的异步处理框架
* Gson 官方认证JSON工具
Rxjava和gson 回头再聊，目的和作用都比较清楚。但，Okhttp和Retorfit，咋一看，似乎都是解决网络层的，事实上，Retorfit2开始，内置的client已经是okhttp了，也可以理解为Retorfit是壳，而Okhttp是网络请求的执行者。也可以理解为，如果我们自己封装Okhttp很牛逼的话，也就没Retrofit什么事儿了。
似乎，到这里为止，这些个东西已经明明白白，清清楚楚了，那么，再问一次，Okhttp和Retorfit他们解决的到底是啥？

### 换个角度，重新理解
```
Retorfit 单词，翻译为改变，改型，改造等。（显然，作为网络框架，改造的肯定就是网络库了）
Okhttp 单词，可以翻译为，搞定Http，没毛病用Http等。
```
所以，我们不妨换一种方法去理解。
网络请求，client和Server的交互，通过Http协议。
`OKHttp`，拆开就是ok和http，不言而喻，它搞得是http协议，不仅仅是协议的具体实现，更是优化了请求的过程，包括连接复用、I/O优化（okio）、拦截器拓展等等吧。
`Retrofit`，而面对的是编程，如何将实现一个网络请求，或者说如何配置一个请求，做到简洁。强大的注解配置，加上可以配置client，序列化适配器，响应适配器等等方式，保证灵活性。让编程更简洁、灵活且优雅