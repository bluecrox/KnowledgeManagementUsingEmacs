这个仓库配合[使用Emacs和坚果云构建自己的笔记系统](https://yiyo.io/2018/06/22/knowledge-management-using-emacs-and-nutstore/)教学使用，对Emacs做一些定制，使之更适合Windows用户的操作习惯。主要定制包括：

## 常用快捷键
* Ctrl-c（复制），Ctrl-v（粘贴），还有Ctrl-x（剪切），Ctrl-z（撤销）
* Ctrl-s（保存）
* Ctrl-Tab（切换窗口）
* Ctrl-f（iSearch查找），左右方向键查找上一个、下一个
* Alt-F 高亮所有的匹配项

## 文件导航
在Emacs启动时自动在编辑器左侧显示文件导航器（treemacs）。

## 全文搜索
在treemacs窗口（获得焦点）时按Ctrl-f进行全文搜索。

## 解决各种因中文字符引起问题
* 解决保存文件（含中文）时提示select coding system的问题
* 解决windows系统复制中文再粘贴到Emacs中显示乱码的问题
* 解决中文表格不对齐和卡顿的问题（使用微软雅黑字体）
