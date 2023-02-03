# Tron链离线签名转账

实现离线签名，直接转账到对应钱包

## 1.快速启动
1.0 安装docker

1.1 从tora-library 下载 docker
    ```
    git clone https://github.com/tora-library/tron-transfer.git
    ```

1.2 解压

1.3 修改配置文件
  java-ts/bin/classes/application.yml

1.4 运行服务
  sh docker.sh --run

## 2.接口说明

  服务 | 接口地址 | 参数 | 说明
  ---- | --------------- | ---------------- | -----------------------
  DAC提现 | /tron/dac/transfer | {address: "(base58)", amount: 100} | 提现DAC到指定TRON地址
  查询DAC余额 | /tron/dac/balance | {address: "(base58)"} | 查询DAC账户余额
  USDT提现 | /tron/usdt/transfer | {address: "(base58)", amount: 100} | 提现USDT到指定TRON地址
  查询USDT余额 | /tron/usdt/balance | {address: "(base58)"} | 查询USDT账户余额
  查询交易状态 | /tron/query | {hash: ""} | 查询提现交易的状态
