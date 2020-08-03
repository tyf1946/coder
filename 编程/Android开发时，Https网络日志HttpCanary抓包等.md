# Android开发时，Https网络日志HttpCanary抓包等

Https, ssl/tls 属于加密。CA作为签名认证。

网络请求框架基本通用为square公司的 `retrofit + okhttp `

代码编写过程中，网络请求的查看还是依赖logcat为主。okhttp也提供了专门的logInterupter方便日志查看和跟踪。

但作为客户端，无论是提供给测试使用，还是在真机上查看日志需要，还是需要能直接在真机上查看日志，尤其是查看网络日落日志的需要。

[chuker](https://github.com/ChuckerTeam/chucker) 开源团队提供了非常好的实践。

但除此之外，我们仍需要抓包需求。

mac-charles 算是mac电脑上非常有效的抓包工具了。比较通用不详细介绍了。

今天重点介绍一下：HttpCanary抓包，Android的app，由于国内的一些原因，现在只能在google-play上下载。





