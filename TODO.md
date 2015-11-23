# TODO

1. print helper info

1. cnpm

1. config 对象 对外 提供接口

1. libs helper 对外提供接口

1. gulp-reqrun 项目

1. woff2

1. pkgs 增加 可配置 指定版本

1. install 可指定 npm / bower

1. 增加 move libs helper

1. handle bower config 为 array 的情况

1. 分离 流程中 bower npm 数据结构

    第一时间判断 是否存在 bower 配置，如果不是，则后续流程完全不考虑 bower 部分

1. bower 配置保留文件, 根据文件类型分类存放，styles/fonts/scripts 分文件夹存放，其他放在 package 根下

    或许 增加 ignore 模式

1. 引入 cson-safe

    未使用 cson 而直接正则的原因是 1.8 coffee parse 报错
