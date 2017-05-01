# colorfulR
Author: Marco.Li

Maintainer: Marco.Li/Matt.Zheng <mattzheng@yeah.net>

Description: wordcloud Extended application
-----------------2017-5-1更新------------------
新更新四个函数：

TermDocumentMatrix，其中这个必须加载slam包，不然不报错：could not find function "as.simple_triplet_matrix"

TermDocumentMatrixCN	Modified command "TermDocumentMatrix" on package tm and defined "TermDocumentMatrixCN"

termFreqCN，Modified command "termFreq" on package tm

wordsCN，Modified command "words" on package NLP


------------------------------------------------
制作教程参考于：

1、https://www.analyticsvidhya.com/blog/2017/03/create-packages-r-cran-github/

2、如何创建 R 包并将其发布在 CRAN / GitHub 上？:http://blog.csdn.net/wemedia/details.html?id=24785

3、R包制作和roxygen2使用说明：http://yulongniu.bionutshell.org/blog/2012/05/30/r-package-and-roxygen2/

4、开发R程序包之忍者篇：https://cos.name/2011/05/write-r-packages-like-a-ninja/


一个最简单的包结构如下（括号中为相应解释）：

pkg (包的名字，请使用一个有意义的名字，不要照抄这里的pkg三个字母)

|

|--DESCRIPTION (描述文件，包括包名、版本号、标题、描述、依赖关系等)

|--R (函数源文件)

   |--function1.R
   
   |--function2.R
   
   |--...
   
|--man (帮助文档)

   |--function1.Rd
   
   |--function2.Rd
   
   |--...
   
|--...






生成过程中主要的文件有以下几类：


NAMESPACE：函数传导，exportPattern("函数名称")

DESCRIPTION：整个packages描述，如需import额外packages需要Imports一下

R：写/存函数的地方，多个函数，可以写多个"xxx.R"，跟内嵌的函数名最好一致

man：在Rstudio中Help Pages显示函数，以便查询。要与R一一对应，而且格式要求比较严格。
