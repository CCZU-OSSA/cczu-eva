<div align=center>
  <img width=200 src="doc\icon.png"  alt="图标"/>
  <h1 align="center">吊大评价</h1>
</div>
<div align=center>


<img src="https://img.shields.io/badge/flutter-3+-blue" alt="Flutter">
  <img src="https://img.shields.io/github/languages/code-size/CCZU-OSSA/cczu-eva?color=green" alt="size">
  <img src="https://img.shields.io/github/license/CCZU-OSSA/cczu-eva" alt="license">
</div>


~~不想手动点评价了！(日后可能会集成到 CCZU Helper 中)~~

[![图片](doc/screenshot.png)](https://github.com/CCZU-OSSA/cczu-eva/releases/latest)



## 平台支持

| Windows | Android | Linux | MacOS | IOS |
| ------- | ------- | ----- | ----- | --- |
| ✅       | ✅       | ❌     | ❌     | ❌   |

由于主要开发人员缺乏 Linux桌面环境 / Apple 设备，所以无法适配对应的版本，你可以尝试自行编译，如果平台对应的功能没有适配，欢迎提供Pull Request~

## 参与本项目

### 反馈意见

如果不知道如何在Github提issue，可以搜一下`如何提issue`

https://github.com/CCZU-OSSA/cczu-eva/issues

### 如何编译

编译之前先确保你的设备上拥有 Rust 与 Flutter 环境，需要`clone`此项目你还需要一个`git`

然后运行以下代码

`<target-platform>`取决于你的目标平台

可以使用`flutter help build`命令查看

```sh
git clone https://github.com/CCZU-OSSA/cczu-eva.git
cd cczu-eva
flutter build <target-platform> --release
```