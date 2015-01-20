# TODO

1. 在 init 生命中初始化 Gruntfile && gulpfile && 相应文件夹

1. 分离 流程中 bower npm 数据结构

    第一时间判断 是否存在 bower 配置，如果不是，则后续流程完全不考虑 bower 部分

1. bower 配置保留文件, 根据文件类型分类存放，styles/fonts/scripts 分文件夹存放，其他放在 package 根下

    或许 增加 ignore 模式

1. 引入 cson-safe

    未使用 cson 而直接正则的原因是 1.8 coffee parse 报错
