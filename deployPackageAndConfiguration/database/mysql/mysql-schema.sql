-- 1.创建数据库，并进入数据库

CREATE DATABASE ddc_hashrate DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE ddc_hashrate;


-- 2.表结构
create table amount_gas_scale
(
   amount_gas_scale_id  bigint not null auto_increment  comment '算力值和能量值比例id',
   amount_quantity      bigint default 100  comment '算力值数量（分），默认100',
   opb_chain_id         bigint(20)  comment '链标识',
   gas_quantity         decimal(50)  comment '能量值数量',
   eos_ram              bigint  comment 'eos ram价格（1k多少算力值）',
   eos_cpu              bigint  comment 'eos cpu价格（SYS/天多少算力值）',
   eos_net              bigint  comment 'eos net价格（SYS/天多少算力值）',
   force_date           date  comment '生效日期',
   lose_date            date  comment '失效日期',
   create_user_name     varchar(50)  comment '创建人',
   create_date          datetime  comment '创建时间',
   primary key (amount_gas_scale_id)
)
charset = UTF8;

alter table amount_gas_scale comment '算力值和能量值及资源的比例';

create table async_ddc_account_task
(
   async_ddc_account_task_id bigint not null auto_increment  comment '任务编号',
   req_tx_sn            varchar(255)  comment '请求流水号',
   chain_type           varchar(20)  comment '链类型',
   account_name         varchar(255)  comment '链账户名称',
   account_task_type    int  comment '交易类型： 1=链账户创建   2=链账户冻结/解冻 ',
   account_task_hash    varchar(100)  comment '交易hash',
   ddc_account_type     int default 0  comment '用户类型 1=平台方 2=平台方的用户  默认0',
   account_address      varchar(200)  comment '链账户地址',
   irisnet_iaa_address  varchar(200)  comment '文昌链 iaa 地址',
   algorithm_type       varchar(100)  comment '算法类型:sm2/secp256k1',
   account_public_key   varchar(500)  comment '链账户公钥',
   account_private_key  varchar(500)  comment '链账户私钥',
   mnemonic             varchar(200)  comment '助记词',
   create_status        int default 0  comment 'DDC链账户创建状态：1：创建中 , 2：创建成功 , 3：创建失败  0=未发起开通DDC链账户（仅创建opb链账户）',
   open_ddc_yn          int default 1  comment '是否开通过DDC  1=未开通（只开通OPB没有上DDC合约）  5=已开通 默认1',
   error_msg            varchar(2000)  comment '错误信息',
   create_query_status  int default 0  comment '创建查询状态 0：未查询，1：已查询',
   ddc_open_query_status int default 0 comment '链账户ddc开通查询状态 0： 未查询，1：已查询',
   ddc_opening_num      int default 0 comment '链账户长时间处于开通中重试次数',
   create_date          datetime  comment '创建时间',
   update_date          datetime  comment '更新时间',
   primary key (async_ddc_account_task_id)
)
charset = UTF8;

alter table async_ddc_account_task comment '异步DDC链账户-task';

create table async_ddc_tx_task
(
   async_ddc_tx_task_id bigint not null auto_increment  comment '异步交易id',
   req_tx_sn            varchar(100)  comment '交易流水号',
   opc_chain_type       varchar(100)  comment '链标识',
   ddc_type             int  comment 'DDC类型：DDC721=721，DDC1155=1155',
   tx_type              int  comment '交易类型交易类型：
             1=生成
             2=流转
             3=销毁
             4=冻结
             5=解冻
             6=跨链锁定
             7=跨链解锁
             21=元交易生成
             22=元交易流转
             23=元交易销毁',
   tx_hash              varchar(100)  comment '交易hash',
   tx_receipt           text  comment '交易收据',
   block_height         bigint  comment '区块高度',
   block_hash           varchar(255)  comment '区块hash',
   signer_account_addr  varchar(200)  comment '签名账户地址',
   from_account_addr    varchar(200)  comment '发送账户地址',
   to_account_addr      varchar(200)  comment '目标账户地址',
   ddc_id               varchar(50)  comment 'DDC ID',
   ddc_amount           bigint  comment 'DDC 数量',
   ddc_uri              varchar(2000)  comment 'DDC URI',
   ddc_data             varchar(1000)  comment 'DDC附加数据',
   meta_account_encrypt_private varchar(500)  comment '元交易链账号加密私钥',
   chain_service_status int default 0 comment '链服务处理状态：
             0=待处理
             1=处理成功（根据交易hash查询交易回执成功）
             2=处理失败（在处理中拿着交易hash多次失败后的状态，依赖失败次数字段）
             3=处理中（请求链上成功的状态）
             4=需要重试（如 nonce 错误）
              5=待查询交易（请求链上查询交易结果异常）
              6=待人工处理（等待人工处理）',
   chain_service_fail_num int default 0 comment '链服务交易回执查询失败次数',
   chain_service_have_err varchar(5) default 'no' comment '链服务处理是否有异常\r\n             yes=有\r\n             no=没有',
   chain_service_err_reason varchar(2000)  comment '链服务定时处理原失败原因',
   tx_err_msg_zh_cn     varchar(2000)  comment '链服务定时处理失败原因说明',
   tx_err_msg_en        varchar(2000)  comment '链服务定时处理失败原因说明英文',
   tx_date              datetime  comment '链上交易时间',
   chain_service_update_date datetime  comment '链服务最后更新时间',
   operation_status     int default 0 comment '业务处理状态
             0=待处理
             1=已处理',
   operation_update_date datetime  comment '业务最后更新时间',
   submit_date          datetime  comment '链服务提交时间',
   create_date          datetime  comment '创建时间',
   primary key (async_ddc_tx_task_id)
)
charset = UTF8;

alter table async_ddc_tx_task comment '异步DDC交易-task';

create table async_ddc_tx_task_err_log
(
   async_ddc_tx_task_err_log_id bigint not null auto_increment  comment '异常记录id',
   async_ddc_tx_task_id bigint  comment '异步交易id',
   log_type             int(2)  comment '日志类型',
   req_tx_sn            varchar(100)  comment '交易流水号',
   opc_chain_type       varchar(100)  comment '链标识',
   signer_account_addr  varchar(200)  comment '签名账户地址',
   tx_hash              varchar(100)  comment '交易hash',
   err_reason           varchar(1000)  comment '失败原因',
   request_parameter    varchar(5000)  comment '请求报文',
   response_parameter   varchar(5000)  comment '响应报文',
   create_date          datetime  comment '创建时间',
   primary key (async_ddc_tx_task_err_log_id)
)
charset = UTF8;

alter table async_ddc_tx_task_err_log comment '异步DDC交易异常记录';

create table chain_account_trade_record
(
   account_balance_id   bigint not null auto_increment  comment '帐户交易流水ID',
   client_id            bigint not null  comment '服务用户ID',
   client_name          varchar(100)  comment '登录名（账户名）',
   withdraw_cash_id     bigint  comment '提现单ID',
   account_id           bigint  comment '帐户ID',
   remittance_bill_id   bigint  comment '提现单ID',
   trade_type           int not null default 0  comment '帐户交易类型
             余额变更类别
             
             1=线下汇款充值  5=提现  55=提现退款  15=退款   20=DDC生成 120=DDC生成退款  22=DDC流转  122=DDC流转退款   23=DDC销毁  123=DDC销毁退款  
             30=购买套餐
             
             100=gas充值(扣款余额)   1100=gas充值退款(增加余额)   110=EOS资源费充值   1110=EOS资源充值失败资金退款
             
                默认0未知',
   trade_code           varchar(100) not null  comment '帐户交易编号: DD+{UUID}+{timestamp}+{trade_type}',
   trade_amount         bigint not null default 0  comment '交易算力值',
   recharge_amount_rmb  bigint  comment '人民币金额（单位分，充值和提现时不能为空其他类型可不填）',
   after_trade_account_balance bigint  comment '交易后余额',
   charge_type          int not null default 0  comment '充值方式  1=微信  2=支付宝   3=企业银联   4=线下汇款   10=VISA
             默认   0=不是充值为0',
   trade_state          int not null default 1  comment '交易流水总状态
               1= 处理中 (相关子账单在审核路上)
               5=处理成功(相关子账单为成功)
              10=处理失败  (相关子账单为失败)
             默认1',
   pay_bill_refund_id   bigint  comment '订单退款流水ID',
   refund_yn            int default 2  comment '是否已退款 1=已退款(退款金额等于交易金额，全部退完)   2=可退款（还有剩余金额可退）   默认2',
   refund_amount        bigint default 0  comment '退款金额',
   refund_trade_code    varchar(100)  comment '退款后交易编号；当前账单退款发生后生成的新交易编号（新记录）；',
   refund_source_trade_code varchar(100)  comment '退款原始交易编号：被退款的交易编号，即当前退款账单的原始交易编号',
   bill_create_date     datetime not null  comment '账单创建日期',
   rmb_quantity         bigint default 100  comment '人民币比例（分），充值时有值',
   amount_quantity      bigint default 100  comment '算力值比例（分），充值时有值',
   primary key (account_balance_id)
)
charset = UTF8;

alter table chain_account_trade_record comment '帐户交易流水表: 记录余额变更记录

按“balence_change_type”事件生成对应记';

create table chain_attach
(
   attach_id            bigint not null auto_increment  comment '附件id',
   attach_code          varchar(50)  comment '附件编号',
   lockable             int not null default 2  comment '锁定: 1=锁定  2=未锁   默认2',
   create_date          datetime not null  comment '创建时间',
   update_date          datetime not null  comment '更新时间',
   primary key (attach_id)
)
charset = UTF8;

alter table chain_attach comment '附件表';

create table chain_attach_list
(
   attach_list_id       bigint not null auto_increment  comment '用户认证文件ID',
   attach_id            bigint  comment '附件id',
   attach_list_code     varchar(50)  comment '附件编号',
   attach_bio_file_name varchar(200)  comment '附件物理文件名:ftp里的文件名',
   attach_file_name     varchar(200)  comment '附件显示文件名：下载或显示给用户的文件名',
   attach_file_path     varchar(200)  comment '附件地址：FTP地址不包含内，格式：/xxxx/xxx.png等，最前必须有 / ',
   attach_file_type     int default 0  comment '附件类别: 
             1=身份证-正  
             2=营业执照   
              3=复审合同    
             4=身份证-反 
             0=其他
             11=服务说明   
             12=服务手册  
             15=产品手册  
             16=产品说明
             18 =DDC业务数据日报
             20=汇款凭证
             后续增加其他',
   client_id            bigint  comment '服务用户ID',
   Column_9             char(10)  comment '',
   primary key (attach_list_id)
)
charset = UTF8;

alter table chain_attach_list comment '附件记录表';

create table chain_client_account_record
(
   account_id           bigint not null auto_increment  comment '帐户ID',
   client_id            bigint  comment '服务用户ID',
   account_blance       bigint unsigned not null default 0  comment '帐户余额 :分',
   primary key (account_id)
)
charset = UTF8;

alter table chain_client_account_record comment '帐户记录表';

create table chain_client_have_plan
(
   client_have_plan_id  bigint not null auto_increment  comment '已购套餐ID',
   client_id            bigint  comment '服务用户ID',
   have_plan_code       varchar(50)  comment '套餐编号',
   have_plan_name       varchar(50)  comment '套餐名称',
   have_day_max_req     int  comment '每日最大请求量',
   have_second_trade    int  comment '每秒交易数',
   have_plan_price      bigint default 0  comment '套餐价格',
   plan_type            int not null default 1  comment '套餐收费类型 1=按年 2=按月 默认值为2',
   have_plan_status     int not null default 1  comment '状态 1=启用 2=禁用  5=待发布',
   user_sail_type       int default 1  comment '消费类型  0=免费  1=销售   默认1',
   create_date          datetime not null  comment '创建时间',
   update_date          datetime not null  comment '更新时间',
   next_bill_date       date  comment '下个账单日',
   primary key (client_have_plan_id)
)
charset = UTF8;

alter table chain_client_have_plan comment '用户已购买套餐信息';

create table chain_client_info
(
   client_id            bigint not null auto_increment  comment '服务用户ID',
   client_code          varchar(50)  comment '客户code',
   client_name          varchar(100)  comment '登录名',
   yinlian_dev_id       varchar(100)  comment '银联开发id',
   ent_name             varchar(50)  comment '企业名称',
   corporate_name       varchar(200)  comment '法人姓名',
   pwd                  varchar(100)  comment '密码',
   salt                 varchar(100)  comment '密码盐',
   poic_id              int  comment '省id',
   city_id              int  comment '市id',
   cuty_dsrc_id         int  comment '区县ID',
   country_id           int default 51  comment '国家ID  默认51 中国',
   attach_id            int  comment '附件id',
   ent_approve_attach_id int  comment '企业资质',
   details_address      varchar(500)  comment '详细地址',
   client_phone         varchar(30)  comment '手机号',
   client_email         varchar(50)  comment '电子邮箱',
   auth_type            int default 2  comment '客户类别  1=个人  2=企业  ',
   login_total          int default 0  comment '总登录次数',
   client_introduction  varchar(2000)  comment '客户介绍',
   portal_user_language varchar(10) default 'zh-CN'  comment '用户注册语言 en, zh-CN',
   info_source          varchar(1000)  comment '信息来源推荐',
   client_status        int default 1  comment '状态: 1=正常  2=删除   默认1',
   create_date          datetime  comment '创建时间',
   access_key           varchar(100)  comment '用户接入key',
   update_date          datetime  comment '更新时间',
   last_login_datetime  datetime  comment '上次登录时间',
   api_token            varchar(1000)  comment 'saas api token',
   primary key (client_id)
)
charset = UTF8;

alter table chain_client_info comment '门户用户表';

create table chain_client_info_login_record
(
   login_record_id      int not null auto_increment  comment '登录记录ID',
   client_id            bigint  comment '服务用户ID',
   login_type           int not null default 1  comment '记录类别: 1=登录成功    默认1',
   client_real_name     varchar(500) not null  comment '客户实名',
   login_datetime       datetime not null  comment '登录时间',
   login_message        varchar(1000)  comment '登录备注',
   primary key (login_record_id)
)
charset = UTF8;

alter table chain_client_info_login_record comment '客户登录记录表';

create table chain_pay_gateway_trade
(
   pay_gateway_id       int not null auto_increment  comment '支付网关交易ID',
   account_balence_id   bigint  comment '帐户充值流水ID',
   gateway_code         varchar(50)  comment '网关类别编码 
             GT0001 = 微信
             GT0002 = 银联二维码支付
             GT0003 = 企业网银
             GT0004 = 线下付款
             
             GT00010 = stripe支付
             
             ',
   agent_no             varchar(100)  comment '支付网关流水号:支付时',
   trxamt               bigint  comment '支付金额',
   user_id              varchar(50)  comment '门户登录英文账号',
   client_id            int  comment '服务用户ID',
   gateway_trade_state  int  comment '网关交易状态: 1=待支付   5=支付成功  10=支付失败   15=已过期 ',
   pay_time             datetime  comment '支付回调日期',
   check_count          int default 0  comment '查询次数：定时查支付结果：1s、5s、10s、30s、1min、5min、10min、30min、1h、12h、24h、36h \r\n             36小时查询仍未支付则支付失败',
   next_check_time      datetime default NULL  comment '下次查询时间',
   primary key (pay_gateway_id)
)
charset = UTF8;

alter table chain_pay_gateway_trade comment '支付网关交易表';

create table chain_plan_info
(
   plan_id              bigint not null auto_increment  comment '套餐id',
   plan_code            varchar(50) not null  comment '套餐编号',
   plan_name            varchar(50) not null  comment '套餐名称',
   day_max_req          int not null default 0  comment '每日最大请求量',
   second_trade         int not null default 0  comment '每秒交易数',
   plan_price           bigint default 0  comment '套餐价格',
   plan_status          int not null default 1  comment '状态 1=启用 0=禁用',
   plan_type            int not null default 2  comment '套餐收费类型 1=按年 2=按月',
   create_date          datetime not null  comment '创建时间',
   update_date          datetime  comment '更新时间',
   sail_type            int default 1  comment '消费类型  0=免费  1=销售  默认1',
   primary key (plan_id)
)
charset = UTF8;

alter table chain_plan_info comment '计费套餐信息表';

create table chain_remittance_bill
(
   remittance_bill_id   bigint not null auto_increment  comment '汇款单ID',
   attach_id            bigint  comment '附件id',
   remittance_amount    bigint default 0  comment '汇款金额',
   client_id            bigint  comment '服务用户ID',
   client_real_name     varchar(300)  comment '转帐方名称',
   remittance_user_code varchar(50)  comment '汇款识别码  用户账户loginname',
   process_state        int  comment '流程状态   0=待提交     1=待审核   5=审核失败  10=审核成功',
   auth_user            varchar(50)  comment '汇款审批人',
   auth_desc            varchar(500)  comment '汇款审批意见',
   auth_date            datetime  comment '汇款审批时间： 审批成功，审批失败要生成日期',
   remittance_op_user   varchar(50)  comment '汇款操作人',
   remittance_op_date   datetime  comment '汇款财务操作操作时间',
   remittance_desc      varchar(500)  comment '汇款说明',
   remittance_bank      varchar(200)  comment '汇款银行- 开户行',
   remittance_account   varchar(200)  comment '汇款账户',
   recv_bank            varchar(200)  comment '收款银行',
   recv_account         varchar(200)  comment '收款账户',
   remittance_name      varchar(200)  comment '汇款方名称',
   remittance_date      datetime  comment '汇款时间',
   create_date          datetime not null  comment '创建时间',
   primary key (remittance_bill_id)
)
charset = UTF8;

alter table chain_remittance_bill comment '汇款单 ：需要审核流程才能生成汇款单';

create table chain_status_enums
(
   cse_id               int not null auto_increment  comment '',
   cse_code             varchar(50)  comment '模块编码',
   cse_p_code           varchar(50) default '0'  comment '父模块编码',
   cse_cn_desc          varchar(50)  comment '中文描述',
   cse_en_desc          varchar(50)  comment '英文描述',
   cse_value            int  comment '值',
   cse_remark           varchar(500)  comment '备注',
   lockable             int not null default 2  comment '锁定: 1=锁定  2=未锁   默认2',
   cse_sort             int  comment '排序',
   primary key (cse_id)
)
charset = UTF8;

alter table chain_status_enums comment '系统状态维护表';

create table chain_withdraw_bill
(
   withdraw_cash_id     bigint not null auto_increment  comment '提现单ID',
   withdraw_cash_code   varchar(50)  comment '提现单编号',
   withdraw_account_type_code varchar(50)  comment '提现帐户类型编码
             PAY001:微信
             PAY002：银行卡
             ',
   platform_access_id   varchar(50)  comment '平台接入id     uuid',
   withdraw_amount      bigint default 0  comment '提现算力值',
   withdraw_rmb         bigint default 0  comment '提现人民币金额',
   client_id            bigint  comment '服务用户ID',
   client_real_name     varchar(300)  comment '客户实名',
   withdraw_bank_code   varchar(100)  comment '提现账户号',
   withdraw_process_state int  comment '流程状态  0=待提交   1=待审核   5=审核失败    10=审核成功    15=已确认',
   auth_user            varchar(50)  comment '提现审批人',
   auth_desc            varchar(500)  comment '审批意见',
   auth_date            datetime  comment '审批时间 ： 审批成功，审批失败要生成日期',
   withdraw_op_user     varchar(50)  comment '提现操作人: 财务人',
   withdraw_op_date     datetime  comment '提现操作时间',
   withdraw_desc        varchar(500)  comment '提现说明',
   create_date          datetime not null  comment '创建时间',
   wx_refund_amount     bigint default 0  comment '微信退款',
   yunshanfu_refund_amount bigint default 0  comment '云闪付退款',
   ent_union_refund_amount bigint default 0  comment '云闪付退款',
   offline_withdraw_amount bigint default 0  comment '线下汇款',
   primary key (withdraw_cash_id)
)
charset = UTF8;

alter table chain_withdraw_bill comment '提现单：需要审核流程才能生成退款单';

create table ddc_bill
(
   ddc_bill_id          bigint not null auto_increment  comment 'DDC账单id',
   account_balence_id   bigint  comment '帐户交易流水ID',
   trade_code           varchar(100) not null  comment '帐户交易编号: DD+{UUID}+{timestamp}+{trade_type}',
   client_id            bigint  comment '服务用户ID',
   trade_amount         bigint not null default 0  comment '交易金额分',
   ddc_id               varchar(50)  comment 'DDC ID',
   ddc_type             int default 0  comment 'ddc类型  721=721合约   1155=1155合约   默认0',
   opb_chain_id         int  comment '链标识
             运维推送唯一标示',
   opb_chain_name       varchar(100) default NULL  comment '链名称',
   opb_chain_type       varchar(100)  comment '链类型
             netCode与公链一致',
   ddc_owner            varchar(100)  comment 'ddc_owner',
   send_account         varchar(100)  comment '发送者账户',
   security_data        varchar(1000)  comment '附加数据',
   ddc_desc             varchar(3000)  comment '描述',
   create_date          datetime  comment '创建时间',
   update_date          datetime  comment '更新时间',
   tx_type              int  comment '交易类型   20=DDC生成  22=DDC流转   23=DDC销毁  ',
   burn_quantity        bigint default 1  comment '销毁数量',
   trade_quantity       bigint default 1  comment '流转数量',
   mint_quantity        bigint default 1  comment '生成数量：721默认为1，1155需要填实际数量',
   ddc_uri              varchar(5000)  comment 'ddc_uri',
   primary key (ddc_bill_id)
)
charset = UTF8;

alter table ddc_bill comment 'DDC账单';

create table ddc_cost_setup
(
   ddc_cost_setup       bigint not null auto_increment  comment 'DDC费用id',
   tx_type              int  comment '交易类型  1=生成  2=流转  3=销毁',
   tx_amount            bigint  comment '交易所需金额（分）',
   tx_name              varchar(50)  comment '交易名称',
   update_date          datetime  comment '更新时间',
   primary key (ddc_cost_setup)
)
charset = UTF8;

alter table ddc_cost_setup comment 'DDC费用设置';

create table ddc_gas_recharge_bill
(
   energy_plus_work_id  bigint not null auto_increment  comment '能量充值记录id',
   trade_code           varchar(100) not null  comment '帐户交易编号: DD+{UUID}+{timestamp}+{trade_type}',
   client_id            bigint  comment '服务用户ID',
   opb_chain_client_id  varchar(50) not null  comment '用户链账户id',
   account_balence_id   bigint not null  comment '帐户充值流水ID',
   opb_chain_client_address varchar(300) not null  comment '链帐户地址',
   irisnet_iaa_address  varchar(200)  comment '文昌链 iaa 地址',
   pay_amount           bigint not null default 0  comment '兑换gas的资金金额:分',
   gas_quantity         varchar(50) not null  comment '充值gas量',
   one_yuan_gas_quantity varchar(50) not null default '0'  comment '一元对应的gas量',
   opb_chain_id         bigint not null  comment '链标识
             运维推送唯一标示',
   opb_chain_type       varchar(100)  comment '链类型
             netCode与公链一致',
   opb_chain_name       varchar(50) not null  comment '链名称',
   create_date          datetime not null  comment '创建时间',
   eos_cpu_value        bigint default NULL  comment 'cpu比重',
   eos_cpu_price        bigint default NULL  comment 'cpu价格；分/SYS/天',
   eos_cpu_plus_value   bigint  comment 'CPU充值数量',
   eos_ram_value        bigint default NULL  comment 'ram比重',
   eos_ram_price        bigint default NULL  comment 'ram价格，分/bytes/天',
   eos_ram_plus_value   bigint  comment 'RAM充值数量',
   eos_net_value        bigint default NULL  comment 'net比重',
   eos_net_price        bigint default NULL  comment 'net价格，分/SYS/天',
   eos_net_plus_value   bigint  comment 'NET 充值数量',
   eos_resource_valid_date datetime  comment '资源有效期',
   recharge_status      int default 0  comment '充值状态 0=充值中 1=充值成功 2=充值失败',
   update_balance_status int  comment '余额更新状态 0=未更新 1=已更新',
   timing_date          datetime  comment '定时操作时间',
   primary key (energy_plus_work_id)
)
charset = UTF8;

alter table ddc_gas_recharge_bill comment '能量充值记录';

create table ddc_operate_log
(
   ddc_operate_log_id   bigint not null auto_increment  comment 'DDC操作记录id',
   platform_ddc_id      bigint  comment 'ddc交易id',
   client_id            bigint  comment '服务用户ID',
   ddc_id               varchar(300)  comment 'ddc id',
   ddc_type             int default 0  comment 'ddc类型  721=721合约   1155=1155合约   默认0',
   opb_chain_id         bigint  comment '链标识
             运维推送唯一标示',
   opb_chain_name       varchar(100) default NULL  comment '链名称',
   trade_code           varchar(100) not null  comment '帐户交易编号: DD+{UUID}+{timestamp}+{trade_type}',
   user_trade_code      varchar(100)  comment '用户第三方交易流水号（用户传递）',
   ddc_owner            varchar(100)  comment 'ddc_owner',
   send_account         varchar(100)  comment '发送者账户',
   tx_hash              varchar(200)  comment '交易hash',
   tx_type              int  comment '交易类型   20=DDC生成  22=DDC流转   23=DDC销毁  ',
   ddc_operate_log_code varchar(50)  comment 'DDC操作记录code',
   tx_message           text  comment '交易报文',
   tx_status            int default 0  comment '交易状态：0=处理中 1=成功 2=失败',
   block_height         bigint  comment '块高',
   burn_quantity        bigint default 1  comment '销毁数量',
   trade_quantity       bigint default 1  comment '流转数量',
   mint_quantity        bigint default 1  comment '生成数量：721默认为1，1155需要填实际数量',
   err_reason           varchar(2000) DEFAULT NULL COMMENT '失败原因',
   err_reason_en        varchar(2000) DEFAULT NULL COMMENT '失败原因英文',
   tx_security_data     varchar(1000)  comment '交易附加数据',
   block_hash           varchar(200)  comment '块hash',
   create_date          datetime  comment '创建时间',
   update_date          datetime  comment '更新时间',
   tx_date              datetime  comment '链上交易时间',
   primary key (ddc_operate_log_id)
)
charset = UTF8;

alter table ddc_operate_log comment 'DDC操作记录';

create table ddc_owner_details
(
   ddc_owner_id         bigint not null auto_increment  comment 'ddc onwer ID',
   platform_ddc_id      bigint  comment 'ddc交易id',
   ddc_owner            varchar(100)  comment 'ddc_owner',
   ddc_owner_quantity   bigint default 1  comment 'ddc owner 数量：721为1  1155=数量',
   ddc_state            int default 1  comment 'ddc状态  1=正常  4=销毁中 5=销毁  20=发送中 25=发送失败    默认1',
   opb_chain_name       varchar(100) default NULL  comment '链名称',
   opb_chain_id         int  comment '链标识',
   opb_chain_type       varchar(100)  comment '链类型',
   ddc_id               varchar(300)  comment 'ddc id',
   ddc_type             int default 0  comment 'ddc类型  721=721合约   1155=1155合约   默认0',
   create_date          datetime  comment '创建时间',
   update_date          datetime  comment '更新时间',
   primary key (ddc_owner_id)
)
charset = UTF8;

alter table ddc_owner_details comment 'ddc owner 明细';

create table ddc_platform_ddc
(
   platform_ddc_id      bigint not null auto_increment  comment 'ddc交易id',
   platform_ddc_code    varchar(50)  comment 'ddc code',
   attach_code          varbinary(50)  comment '附件编号',
   opb_chain_id         bigint  comment '链标识
             运维推送唯一标示',
   opb_chain_name       varchar(100) default NULL  comment '链名称',
   opb_chain_type       varchar(100)  comment '链类型
             netCode与公链一致',
   client_id            bigint  comment '用户ID',
   client_name          varchar(100)  comment '登录名',
   ddc_id               varchar(300)  comment 'ddc id',
   ddc_name             varchar(100)  comment 'ddc名称',
   ddc_symbol           varchar(200)  comment 'ddc符号',
   ddc_owners           varchar(100)  comment 'ddc_owners（发行者地址）',
   ddc_type             int default 0  comment 'ddc类型  721=721合约   1155=1155合约   默认0',
   ddc_pub_total        bigint default 1  comment 'ddc发行总数量    1155数量      721为1',
   ddc_uri              varchar(5000)  comment 'ddc_uri',
   security_data        varchar(1000)  comment '生成时附加数据',
   ddc_desc             varchar(3000)  comment 'DDC描述',
   ddc_generate_state   int default 1  comment 'DDC状态  
             1=生成中
             5=正常
             10=生成失败
             默认1',
   generate_date        datetime  comment '生成时间',
   burn_quantity        bigint default 0  comment '1155销毁数量，当销毁数量和大于等于发行量时需要将状态更新为销毁',
   burn_status          int default 0  comment '销毁状态：0=正常 1=部分销毁 2=已销毁',
   ops_mgr_state        int default 5  comment '运营冻结状态   1=冻结  5=正常（解冻）  10=冻结中  15=解冻中     默认5',
   create_date          datetime  comment '创建时间',
   update_date          datetime  comment '更新时间',
   primary key (platform_ddc_id)
)
charset = UTF8;

alter table ddc_platform_ddc comment 'DDC 管理';

create index uk_ddc_trade_log on ddc_platform_ddc
(
   ddc_type
);

create table ddc_statistics
(
   ddc_statistics_id    bigint not null auto_increment  comment 'DDC统计id',
   client_id            bigint  comment '服务用户ID',
   ddc_total            int  comment 'ddc总数',
   ddc_valid            int  comment '有效ddc数量',
   ddc_frozen           int  comment '冻结ddc数量',
   ddc_burn             int  comment '销毁ddc数量',
   create_date          datetime  comment '创建时间',
   update_date          datetime  comment '更新时间',
   primary key (ddc_statistics_id)
)
charset = UTF8;

alter table ddc_statistics comment 'DDC统计表';

create table function_menu
(
   function_menu_id     bigint not null auto_increment  comment '功能菜单id',
   menu_name            varchar(100)  comment '菜单名',
   menu_code            varchar(50)  comment '菜单名code',
   father_menu_id       bigint not null  comment '父id：0代表根节点',
   support_yn           int not null default 0  comment '门户是否支持: 0=不支持 1=支持',
   create_date          datetime  comment '创建时间',
   update_date          datetime  comment '更新时间',
   primary key (function_menu_id)
)
charset = UTF8;

alter table function_menu comment '门户功能配置';

create table need_to_be
(
   need_to_be_id        bigint not null auto_increment  comment '待办事项id',
   client_name          varchar(100)  comment '登录名',
   client_phone         varchar(30)  comment '手机号',
   client_email         varchar(50)  comment '电子邮箱',
   need_to_be_type      int  comment '待办类型：1=汇款登记  2=提现审核  3=key申请',
   apply_code           varchar(200)  comment '申请单号',
   need_to_be_date_id   bigint  comment '待办的数据id',
   need_to_bedate       varchar(2000)  comment '待办所需参数',
   need_to_be_status    int default 0  comment '状态 0=未办 1=已办',
   update_date          datetime  comment '更新时间',
   create_date          datetime  comment '创建时间',
   primary key (need_to_be_id)
)
charset = UTF8;

alter table need_to_be comment '待办事项信息';

create table node_examine_info
(
   node_examine_info_id bigint not null auto_increment  comment '审核信息id',
   node_join_network_id bigint  comment '入网节点id',
   examine_remarks      varchar(2000)  comment '审核意见',
   examine_status       int default 0  comment '审核状态 0=待审核 1=审核通过 2=审核不通过',
   examine_date         datetime  comment '审核时间',
   create_date          datetime  comment '创建时间',
   primary key (node_examine_info_id)
)
charset = UTF8;

alter table node_examine_info comment '节点审核记录信息';

create table node_join_network
(
   node_join_network_id bigint not null auto_increment  comment '入网节点id',
   node_join_network_code varchar(50)  comment '入网节点code（提交DDC运营审核时的唯一标识）',
   user_id              bigint  comment '用户id',
   opb_chain_id         bigint  comment '链标识
             运维推送唯一标示',
   opb_chain_name       varchar(100) default NULL  comment '链名称',
   opb_chain_type       varchar(100)  comment '链类型
             netCode与公链一致',
   node_ip              varchar(50)  comment '节点ip',
   node_join_network_name varchar(200)  comment '入网节点名称',
   node_status          int default 0  comment '节点状态：
             0=待审核
             1=入网中（审核通过）
             2=审核拒绝
             3=数据已保存
             5=入网失败
             10=待确认入网
             15=已确认入网
             20=入网完成
             25=退网中
             30=退网完成
			 35=删除
             ',
   proof_attach_id      bigint  comment '证书附件id',
   download_yn          int default 0  comment '证书是否已下载 0=未下载 1=已下载 3=无需下载',
   create_date          datetime  comment '创建时间',
   update_date          datetime  comment '更新时间',
   timing_date          datetime  comment '定时操作时间',
   leave_operate_user   varchar(200)  comment '退网操作人',
   leave_operate_date   datetime  comment '退网时间',
   leave_operate_remark text  comment '退网说明',
   node_join_remark     text  comment '节点入网说明',
   fail_reason          text  comment '失败原因',
   primary key (node_join_network_id)
)
charset = UTF8;

alter table node_join_network comment '入网节点信息';

create table node_join_param_info
(
   node_join_param_info_id bigint not null auto_increment  comment '节点入网参数值id',
   node_join_network_id bigint  comment '入网节点id',
   opb_chain_join_param_id bigint  comment '接入参数数据id',
   param_name           varchar(20) not null default ''  comment '参数名称',
   param_key            varchar(20) not null default ''  comment '参数key',
   param_type           smallint not null default 1  comment '字段类型    1:文件    2：文本框   3：下拉框    4：数值   5：文本域',
   param_value          varchar(2000) not null default ''  comment '参数值',
   attach_id            bigint  comment '附件id',
   create_date          datetime  comment '创建时间',
   apply_type           smallint not null default 1  comment '申请类型   1：入网中     10：待确认入网（待算力中心入网通知）',
   primary key (node_join_param_info_id)
)
charset = UTF8;

alter table node_join_param_info comment '节点入网参数值';

create table opb_chain_client_info
(
   opb_chain_client_id  bigint not null auto_increment  comment '用户链账户id',
   opb_chain_client_code varchar(50)  comment '链账户code',
   client_id            int  comment '服务用户ID',
   opb_chain_name       varchar(100) default NULL  comment '链名称',
   opb_chain_type       varchar(100)  comment '链类型
             netCode与公链一致',
   opb_chain_id         int  comment '链标识',
   opb_chain_client_name varchar(200)  comment '链账户名称',
   opb_algorithm_type   int default 0  comment '算法类型
             算法类型未确定  0：未知默认值',
   opb_algorithm_name   varchar(50) default NULL  comment '框架算法类型名称',
   opb_chain_client_address varchar(200) default NULL  comment '链账户地址',
   irisnet_iaa_address  varchar(200)  comment '文昌链 iaa 地址',
   key_type             int default 1  comment '秘钥模式 1=秘钥托管 2=公钥上传 3=账户地址上传',
   lockable             int not null default 2  comment '锁定: 1=锁定  2=未锁 默认2',
   opb_create_status    int default 0  comment 'DDC链账户创建状态
             1：创建中 , 2：创建成功 , 3：创建失败  0=未发起开通DDC链账户（仅创建opb链账户）',
   open_ddc_yn          int not null default 1  comment '是否开通过DDC  1=未开通（只开通OPB没有上DDC合约）  5=已开通 默认1',
   platform_set_state   int not null default 2  comment '平台方控制状态  1=冻结    2=已启用(未冻结)    3=冻结中   4=解冻中    默认2',
   ops_platform_state   int default 2  comment '平台方控制状态  1=冻结    2=已启用(未冻结)    3=冻结中   4=解冻中    默认2',
   trade_fee_balance    bigint default 0  comment '业务费余额(分)',
   balance_last_update_time datetime  comment '业务费最后更新时间',
   gas_balance          decimal(50) default 0  comment 'gas余额',
   gas_last_update_time datetime  comment 'gas最后更新时间',
   ram_value            bigint default 0  comment '中移链 RAM',
   cpu_value            bigint default 0  comment '中移链 CPU',
   net_value            bigint default 0  comment '中移链 NET',
   resource_valid_date  datetime  comment '中移链资源有效期',
   create_time          datetime not null  comment '创建时间',
   update_time          datetime not null  comment '更新时间',
   primary key (opb_chain_client_id)
)
charset = UTF8;

alter table opb_chain_client_info comment '用户链账户信息表';

create table opb_chain_client_operate
(
   opb_chain_client_operate_id bigint not null auto_increment  comment '链账户操作记录id',
   opc_chain_client_id  bigint  comment '用户链账户id',
   operate_type         int  comment '操作类型 1=冻结 2=解冻',
   operate_date         datetime  comment '操作时间',
   operate_remark       text  comment '备注',
   primary key (opb_chain_client_operate_id)
)
charset = UTF8;

alter table opb_chain_client_operate comment '链账户操作记录';

create table opb_chain_client_statistics
(
   opb_chain_client_statistics_id bigint not null auto_increment  comment '数据id',
   client_id            bigint  comment '服务用户ID',
   chain_client_total   int  comment '链账户总数',
   chain_client_valid   int  comment '有效链账户',
   chain_client_frozen  int  comment '冻结链账户',
   create_date          datetime  comment '创建时间',
   update_date          datetime  comment '更新时间',
   primary key (opb_chain_client_statistics_id)
)
charset = UTF8;

alter table opb_chain_client_statistics comment '链账户统计';

create table opb_chain_join_param
(
   opb_chain_join_param_id bigint not null auto_increment  comment '接入参数数据id',
   opb_chain_id         bigint  comment '链标识',
   param_name           varchar(20) not null default ''  comment '参数名称',
   param_key            varchar(20) not null default ''  comment '参数key',
   param_type           smallint not null default 1  comment '字段类型    1:文件    2：文本框   3：下拉框    4：数值   5：文本域',
   blank_type           smallint not null default 1  comment '是否可为空   1:不可为空      0：可以为空',
   min_value            int not null default 0  comment '最小长度/大小（MB）',
   max_value            int not null default 0  comment '最大长度/大小（MB）',
   param_format         varchar(20)  comment '格式    为文件时，不能为空    如果支持多种，逗号隔开',
   encryption_type      smallint not null default 1  comment '加密方式      0：不加密  1：RAS      2：Base64    3......',
   apply_type           smallint not null default 1  comment '申请类型   1：入网中     10：待确认入网（待算力中心入网通知）',
   primary key (opb_chain_join_param_id)
)
charset = UTF8;

alter table opb_chain_join_param comment '开放链节点接入参数信息';

create table opb_chain_record
(
   opb_chain_id         bigint not null  comment '链标识
             运维推送唯一标示',
   opb_chain_name_en    varchar(100) default NULL  comment '链名称英文',
   opb_chain_name       varchar(100) default NULL  comment '链名称',
   opb_chain_type       varchar(100)  comment '链类型
             netCode与公链一致',
   opb_remarks          text default NULL  comment '描述',
   opb_remarks_en       text  comment '英文描述',
   opb_state            int default 1  comment '开放联盟链状态
             0=禁用  ，  1=启用  ，  默认=1',
   opb_gas_rmb          int default NULL  comment '能量值人民币',
   opb_gas_value        bigint  comment '能量值',
   opb_algorithm_type   int default 0  comment '算法类型
             算法类型未确定  0：未知默认值',
   opb_algorithm_name   varchar(50) default NULL  comment '框架算法类型名称',
   opb_protocal         varchar(50) default NULL  comment '开放链支持协议 (多个用逗号隔开)',
   opb_chain_url        varchar(800)  comment '开放链官网地址',
   opb_browser_url      varchar(500)  comment '浏览器地址',
   opb_cc_format        varchar(200) default NULL  comment '合约支持格式
             支持的部署合约文件格式,多个以，隔开
             例：zip,rar',
   opb_file_max_size    int default -1  comment '合约文件最大值
             单位KB
             如果为-1表示不限制',
   official_use         int default 1  comment '公网门户框架 : 1=公网使用  2= 第三方门户使用   默认1',
   outside_portal_code  varchar(50) default 'protal'  comment '第三方门户标识  NONE',
   opb_online_create    int default 1  comment '0：支持1：不支持',
   opb_price_type       int default 1  comment '计费类型：1：能量值，2：资源',
   opb_open_original_transaction int default 0  comment '是否支持原交易  1=支持  2=不支持   默认=0',
   portal_open_yn       int default 0  comment '门户是否支持该框架 0=不支持 1=支持',
   sort_value           int default 0  comment '排序值，越小越靠前',
   primary key (opb_chain_id)
)
charset = UTF8;

alter table opb_chain_record comment '开放联盟链链信息';

create table plan_bill
(
   bill_pubchain_id     bigint not null auto_increment  comment '套餐账单ID',
   account_balence_id   bigint  comment '帐户交易流水ID',
   trade_code           varchar(100) not null  comment '帐户交易流水号',
   client_id            bigint  comment '服务用户ID',
   have_plan_name       varchar(50)  comment '套餐名称',
   have_day_max_req     int  comment '每日最大请求量',
   have_second_trade    int  comment '每秒交易数',
   have_plan_price      bigint default 0  comment '套餐价格',
   plan_type            int default 1  comment '套餐收费类型 1=按年 2=按月',
   create_date          datetime  comment '创建时间',
   next_bill_date       date  comment '下个账单日',
   primary key (bill_pubchain_id)
)
charset = UTF8;

alter table plan_bill comment '套餐账单表';

create table plan_request_detailed
(
   plan_request_detailed_id bigint not null auto_increment  comment '请求明细id',
   access_key           varchar(100)  comment '接入key',
   chain_type           varchar(50)  comment '链标识',
   status               int  comment '响应状态码',
   method               varchar(50)  comment '请求方法',
   path                 varchar(200)  comment '请求路由',
   body_size            bigint  comment '请求体大小',
   request_addr         varchar(500)  comment '远程请求地址',
   upstream_addr        varchar(500)  comment '上游地址',
   req_time             datetime  comment '请求时间',
   resp_time            datetime  comment '响应时间',
   primary key (plan_request_detailed_id)
)
charset = UTF8;

alter table plan_request_detailed comment '套餐请求量明细';

create table plan_request_statistics
(
   plan_request_statistics_id bigint not null auto_increment  comment '套餐请求量ID',
   client_id            bigint  comment '服务用户ID',
   request_date         date  comment '请求日期',
   request_num          int  comment '请求数量',
   primary key (plan_request_statistics_id)
)
charset = UTF8;

alter table plan_request_statistics comment '套餐请求量统计';

create table portal_config
(
   portal_config_id     bigint not null auto_increment  comment '门户配置id',
   portal_title         varchar(50)  comment '门户title',
   log_attach_id        bigint  comment 'logo附件id',
   backdrop_attach_id   bigint  comment '背景图附件id',
   portal_introduce     text  comment '门户介绍',
   saas_url             varchar(500)  comment 'saas api地址',
   contact_address      varchar(500)  comment '联系地址',
   email                varchar(200)  comment '联系邮箱',
   phone                varchar(15)  comment '手机号',
   copyright            varchar(1000)  comment '版权信息',
   theme_code           varchar(200)  comment '门户主题编号',
   create_date          datetime  comment '创建时间',
   update_date          datetime  comment '更新时间',
   saas_attach_id       bigint  comment 'saas api文档附件id',
   primary key (portal_config_id)
)
charset = UTF8;

alter table portal_config comment '门户配置表';

create table proxy_account_status_log
(
   account_status_log_id varchar(50) not null  comment '链账户状态记录主键id',
   account_addr         varchar(100)  comment '账户地址',
   chain_account_type   int  comment '平台方管理状态：1=解冻 2=冻结',
   operate_type         int  comment '运营方管理状态：1=解冻 2=冻结',
   opc_chain_type       varchar(100)  comment '链标识',
   query_type           int default 0 comment '查询状态查询状态 0=需要查询 1=已经查询出结果无需再次查询到期后删除',
   create_date          datetime  comment '创建时间',
   uu_hash              varchar(50)  comment '在推送数据时用于判断数据唯一性',
   primary key (account_status_log_id)
)
charset = UTF8;

alter table proxy_account_status_log comment '链账户状态记录表';

create table proxy_chain_account_log
(
   chain_account_log_id varchar(50) not null  comment '链账户记录主键id',
   account_addr         varchar(200)  comment '账户地址',
   account_name         varchar(100)  comment '账户名称',
   chain_create_date    datetime  comment '链上创建时间',
   user_did             varchar(200)  comment '终端用户did',
   platform_did         varchar(200)  comment '平台方did',
   opc_chain_type       varchar(100)  comment '链标识',
   query_type           int default 0 comment '查询状态 0=需要查询 1=已经查询出结果无需再次查询到期后删除',
   user_role            int  comment '用户角色 0=运营方 1=平台方 2=终端用户',
   create_date          datetime  comment '创建时间',
   uu_hash              varchar(50)  comment '在推送数据时用于判断数据唯一性',
   primary key (chain_account_log_id)
)
charset = UTF8;

alter table proxy_chain_account_log comment '链账户记录，记录链上DDC链账户';

create table proxy_ddc_operation_log
(
   ddc_operation_log_id varchar(50) not null  comment 'DDC操作记录主键id',
   block_height         bigint  comment '块高',
   ddc_id               varchar(50)  comment 'DDC ID',
   ddc_type             int  comment 'DDC类型：721=721  1155=1155',
   owner_account_addr   varchar(100)  comment 'owner账户地址',
   from_account_addr    varchar(100)  comment 'from账户地址',
   circulation_num      bigint  comment '1155交易数量',
   tx_hash              varchar(200)  comment '交易hash',
   tx_type              int  comment '交易类型
             1=生成
              2=流转
             3=销毁
             4=冻结
             5=解冻 
             6=跨链锁定
             7=跨链解锁
             21=元交易生成
             22=元交易流转
             23=元交易销毁',
   opc_chain_type       varchar(100)  comment '链标识',
   query_type           int default 0 comment '查询状态
             0=需要查询
             1=已经查询',
   ddc_symbol           varchar(50)  comment 'DDC 符号',
   ddc_uri              varchar(500)  comment 'DDC URI',
   tx_date              datetime  comment '链上交易时间',
   create_date          datetime  comment '创建时间',
   uu_hash              varchar(50)  comment '在推送数据时用于判断数据唯一性',
   primary key (ddc_operation_log_id)
)
charset = UTF8;

alter table proxy_ddc_operation_log comment '记录DDC链上的操作记录';

create table proxy_ddc_operation_tx_data
(
   operation_tx_data_id varchar(50) not null  comment 'DDC操作记录报文主键id',
   ddc_operation_log_id varchar(50)  comment 'DDC操作记录主键id',
   tx_data              text  comment '交易报文',
   primary key (operation_tx_data_id)
)
charset = UTF8;

alter table proxy_ddc_operation_tx_data comment '记录DDC操作记录的交易报文';

create table support_network_protocol
(
   support_network_protocol_id bigint not null auto_increment  comment '支持的协议id',
   opb_chain_id         bigint  comment '链标识
             运维推送唯一标示',
   opb_chain_name       varchar(100) default NULL  comment '链名称',
   opb_chain_type       varchar(100)  comment '链类型
             netCode与公链一致',
   network_protocol     varchar(50)  comment '网络协议',
   support_yn           int default 0  comment '是否支持 0=不支持 1=支持，默认0',
   create_date          datetime  comment '创建时间',
   update_date          datetime  comment '更新时间',
   primary key (support_network_protocol_id)
)
charset = UTF8;

alter table support_network_protocol comment '系统支持的协议';

create table sys_city
(
   city_id              int not null auto_increment  comment '',
   poic_id              int  comment '省id',
   city_code            varchar(50)  comment 'city_code',
   city_name            varchar(50)  comment '市名',
   primary key (city_id)
)
charset = UTF8;

alter table sys_city comment '市';

create table sys_comp_recv_account_info
(
   recv_account_id      int not null auto_increment  comment '',
   account_user_name    varchar(100)  comment '户名',
   account_user_name_en varchar(100)  comment '户名EN',
   account_user_code    varchar(100)  comment '帐户',
   account_user_code_en varchar(100)  comment '帐户EN',
   recv_bank            varchar(200)  comment '开户行（收款银行）',
   recv_bank_en         varchar(200)  comment '开户行EN',
   bank_code            varchar(100)  comment '银行号',
   remittance_user_code varchar(50)  comment '汇款识别码  用户账户loginname',
   field5               varchar(100)  comment '',
   field4               varchar(100)  comment '',
   field3               varchar(100)  comment '',
   field1               varchar(100)  comment '',
   field2               varchar(100)  comment '',
   primary key (recv_account_id)
)
charset = UTF8;

alter table sys_comp_recv_account_info comment '公司银行收款信息';

create table sys_country
(
   country_id           int not null auto_increment  comment '国家ID',
   en_name              varchar(100)  comment '英文名',
   en_short_name        varchar(20)  comment '英文简称',
   cn_name              varchar(100)  comment '中文名',
   country_code         varchar(50)  comment '国家代码',
   primary key (country_id)
)
charset = UTF8;

alter table sys_country comment '国家';

create table sys_country_district
(
   cuty_dsrc_id         int not null auto_increment  comment '',
   city_id              int  comment '市id',
   cuty_dsrc_name       varchar(100) not null  comment '区县名称',
   cuty_dsrc_class      int not null  comment '区县类别 : 1-区  2-县',
   primary key (cuty_dsrc_id)
)
charset = UTF8;

alter table sys_country_district comment '区/县';

create table sys_dic
(
   dic_code             varchar(100) not null  comment '字典编码',
   dic_name             text not null  comment '字典名称',
   dic_name_en          text not null  comment '字典名称-英文',
   p_dic_code           varchar(20) default '0'  comment '父字典编码',
   create_date          datetime default NULL  comment '创建时间',
   update_date          datetime default NULL  comment '更新时间',
   dic_details          varchar(500)  comment '备注'
)
charset = UTF8;

alter table sys_dic comment '系统字典';

create table sys_message_send_config
(
   msg_config_id        int not null auto_increment  comment '配置ID',
   msg_code             varchar(20) not null  comment '消息发送配置ID',
   send_type            varchar(20) default 'none'  comment '发送类别: email=邮箱， sms=短信， system=消息中心   默认= none',
   temp                 varchar(500)  comment '模板内容',
   email_subject        varchar(100)  comment '邮箱标题',
   email_content_type   int default 2  comment '邮箱内容类别  1=html 2=纯文本  默认2',
   sms_tempid           varchar(50)  comment '短信内容模板ID',
   lockable             int not null default 2  comment '锁定: 1=锁定  2=未锁   默认2',
   code_desc            varchar(200)  comment '描述',
   primary key (msg_config_id)
)
charset = UTF8;

alter table sys_message_send_config comment '消息发送配置';

create table sys_province
(
   poic_id              int not null  comment '',
   country_id           int default 51  comment '国家ID:  默认为中国',
   poic_code            varchar(10) not null  comment '',
   poic_name            varchar(50)  comment '',
   primary key (poic_id)
)
charset = UTF8;

alter table sys_province comment '省';

create table sys_recharge_gateway_type
(
   gateway_code         varchar(50) not null  comment '网关类别编码 
             GT0001 = 微信
             GT0002 = 银联二维码支付
             GT0003 = 企业网银
             GT0004 = 线下付款
             GTY0001	微信支付
             GTY0002	银联二维码支付
             ',
   gateway_type_name    varchar(100)  comment '网关名称',
   gateway_icon_url     varchar(100)  comment '网关ICON: 项目里对应的icon 图标url地址',
   gateway_req_url      varchar(200)  comment '网关接口地址',
   gateway_req_query_url varchar(200)  comment '网关支付状态查询接口地址',
   gateway_prd_code     varchar(100)  comment '商品编号',
   gateway_prd_desc     varchar(500)  comment '商品描述v',
   gateway_prd_name     varchar(200)  comment '商品名称',
   gateway_client_ip    varchar(50)  comment '用户端IP',
   gateway_callback_url varchar(200)  comment '网关回调后台地址',
   gateway_sort         int default 0  comment '排序  默认 0',
   primary key (gateway_code)
)
charset = UTF8;

alter table sys_recharge_gateway_type comment '网关类别表';

create table sys_resource
(
   rsuc_id              bigint not null auto_increment  comment '资源id',
   parent_id            int  comment '父编号',
   rsuc_code            varchar(200)  comment '资源路径',
   rsuc_name            varchar(200)  comment '资源名称',
   priority             int  comment '顺序',
   rsuc_type            int not null default 1  comment '权限类别  1=页面  2=按钮  默认1',
   locking              int default 1  comment '0：锁定， 1：未锁',
   primary key (rsuc_id)
)
charset = UTF8;

alter table sys_resource comment '资源表：  等于权限';

create table sys_resource_apimapping
(
   sys_resource_api_id  int not null auto_increment  comment '资源_URI ID',
   api_uri              varchar(200)  comment 'api_uri',
   rsuc_code            varchar(200)  comment '资源编号',
   ischecked            int default 1  comment '是否权限校验 1:校验2：不校验',
   locking              int default 1  comment '锁定  1：未锁定   2：锁定',
   field1               varchar(50)  comment '所属模块(OPS：为运营权限 其他为门户菜单权限)',
   field2               varchar(50)  comment '所属系统 OPS:运营系统 POTRAL:门户系统',
   field3               varchar(50)  comment '备用字段3',
   field4               varchar(50)  comment '备用字段4',
   field5               varchar(50)  comment '备用字段5',
   primary key (sys_resource_api_id)
)
charset = UTF8;

alter table sys_resource_apimapping comment '资源_URI';

create table sys_role
(
   role_id              bigint not null auto_increment  comment '角色id',
   role_name            varchar(100)  comment '角色名',
   role_code            varchar(50)  comment '',
   description          varchar(500)  comment '描述',
   locking              int default 1  comment '0：锁定， 1：未锁',
   create_date          datetime default NULL  comment '创建时间',
   update_date          timestamp default CURRENT_TIMESTAMP  comment '更新时间',
   create_user_id       int  comment '创建人ID',
   update_user_id       int  comment '修改人ID',
   primary key (role_id)
)
charset = UTF8;

alter table sys_role comment '角色';

create table sys_role_resource
(
   role_resource_id     bigint not null auto_increment  comment '权限绑定id',
   role_id              bigint  comment '角色id',
   rsuc_id              bigint  comment '资源id',
   primary key (role_resource_id)
)
charset = UTF8;

alter table sys_role_resource comment '角色_资源';

create table sys_user_principal
(
   user_id              bigint not null auto_increment  comment '用户id',
   login_name           varchar(50) not null  comment '登陆名',
   user_name            varchar(50)  comment '用户名',
   user_email           varchar(100)  comment '邮箱',
   phone                varchar(50)  comment '手机号',
   password             varchar(100)  comment '密码',
   salt                 varchar(100)  comment '密码盐',
   user_lock            int default 2  comment '锁定用户: 1 - 锁定  2-未锁定',
   create_date          datetime default NULL  comment '创建时间',
   update_date          datetime  comment '更新时间',
   primary key (user_id)
)
charset = UTF8;

alter table sys_user_principal comment '运营用户表';

create table sys_user_role
(
   user_role_id         bigint not null auto_increment  comment '',
   user_id              bigint  comment '',
   role_id              bigint  comment '角色id',
   primary key (user_role_id)
)
charset = UTF8;
alter table sys_user_role comment '用户角色';

ALTER TABLE chain_client_info MODIFY client_name VARCHAR (100) CHARACTER SET utf8 COLLATE utf8_bin;

ALTER TABLE chain_account_trade_record MODIFY client_name VARCHAR (100) CHARACTER SET utf8 COLLATE utf8_bin;

ALTER TABLE ddc_platform_ddc MODIFY client_name VARCHAR (100) CHARACTER SET utf8 COLLATE utf8_bin;

ALTER TABLE need_to_be MODIFY client_name VARCHAR (100) CHARACTER SET utf8 COLLATE utf8_bin;

ALTER TABLE sys_user_principal MODIFY login_name VARCHAR (100) CHARACTER SET utf8 COLLATE utf8_bin;

-- 3.索引
ALTER TABLE ddc_operate_log ADD INDEX idx_trade_code (trade_code);

ALTER TABLE ddc_operate_log ADD INDEX idx_user_trade_code (user_trade_code);

ALTER TABLE ddc_operate_log ADD INDEX idx_client_id (client_id);

ALTER TABLE ddc_owner_details ADD INDEX idx_platform_ddc_id (platform_ddc_id);

ALTER TABLE ddc_owner_details ADD INDEX idx_ddc_owner (ddc_owner);

ALTER TABLE ddc_bill ADD INDEX idx_trade_code (trade_code);

ALTER TABLE chain_attach_list ADD INDEX idx_attach_list_code (attach_list_code);

ALTER TABLE async_ddc_account_task ADD INDEX idx_ddc_open_query_status (ddc_open_query_status);

ALTER TABLE async_ddc_account_task ADD INDEX idx_open_ddc_yn (open_ddc_yn);

ALTER TABLE async_ddc_account_task ADD INDEX idx_create_query_status (create_query_status);

ALTER TABLE async_ddc_account_task ADD INDEX idx_create_status (create_status);

ALTER TABLE opb_chain_client_info ADD INDEX idx_opb_chain_client_address (opb_chain_client_address);

-- 4.初始化数据

#----下拉框状态----

INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_USER_STATUS_1', 'OPS_USER_STATUS', '禁用', 'User Disabled', '1', '运营用户管理-用户状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_USER_STATUS_2', 'OPS_USER_STATUS', '启用', 'User Eeable', '2', '运营用户管理-用户状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_ROLE_STATUS_0', 'OPS_ROLE_STATUS', '禁用', 'Role Disabled', '0', '运营角色管理-角色状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_ROLE_STATUS_1', 'OPS_ROLE_STATUS', '启用', 'Role Enabled', '1', '运营角色管理-角色状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_MANAGE_SYS_STATUS_1', 'OPS_DDC_MANAGE_SYS_STATUS', '冻结', 'Frozen', '1', 'DDC管理-管理状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_MANAGE_SYS_STATUS_5', 'OPS_DDC_MANAGE_SYS_STATUS', '解冻', 'Unfrozen', '5', 'DDC管理-管理状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_MANAGE_SYS_STATUS_10', 'OPS_DDC_MANAGE_SYS_STATUS', '冻结中', 'Freezing', '10', 'DDC管理-管理状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_MANAGE_SYS_STATUS_15', 'OPS_DDC_MANAGE_SYS_STATUS', '解冻中', 'Unfreezing', '15', 'DDC管理-管理状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PACKAGE_MANAGEMENT_STATUS_1', 'PACKAGE_MANAGEMENT_STATUS', '启用', 'Package Eeable', '1', '运营套餐管理-套餐状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PACKAGE_MANAGEMENT_STATUS_0', 'PACKAGE_MANAGEMENT_STATUS', '禁用', 'Package Disabled', '0', '运营套餐管理-套餐状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_1', 'PORTAL_ACCOUNT_TRADE_TYPE', '资金账户充值', 'Billing Account Deposit', '1', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_5', 'PORTAL_ACCOUNT_TRADE_TYPE', '资金账户提现', 'Billing Account Withdrawal', '5', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_100', 'PORTAL_ACCOUNT_TRADE_TYPE', '能量值充值', 'Gas Fee Recharge', '100', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_1100', 'PORTAL_ACCOUNT_TRADE_TYPE', '能量值充值退款', 'Refund of recharged gas fee', '1100', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_20', 'PORTAL_ACCOUNT_TRADE_TYPE', 'DDC生成', 'DDC Minit', '20', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_22', 'PORTAL_ACCOUNT_TRADE_TYPE', 'DDC发送', 'DDC Transfer', '22', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_23', 'PORTAL_ACCOUNT_TRADE_TYPE', 'DDC销毁', 'DDC Destroyed', '23', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_110', 'PORTAL_ACCOUNT_TRADE_TYPE', '资源充值', 'Resource Fee Recharge', '110', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_1110', 'PORTAL_ACCOUNT_TRADE_TYPE', '资源充值退款', 'Refund of recharged resource fee', '1110', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_120', 'PORTAL_ACCOUNT_TRADE_TYPE', 'DDC生成退款', 'Refund DDC Minit', '120', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_122', 'PORTAL_ACCOUNT_TRADE_TYPE', 'DDC发送退款', 'Refund DDC Transfer', '122', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_123', 'PORTAL_ACCOUNT_TRADE_TYPE', 'DDC销毁退款', 'Refund DDC Destroyed', '123', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_TYPE_721', 'PORTAL_DDC_TYPE', 'ERC-721', 'ERC-721', '721', '门户-官方DDC-DDC类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_TYPE_1155', 'PORTAL_DDC_TYPE', 'ERC-1155', 'ERC-1155', '1155', '门户-官方DDC-DDC类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_CERTIFICATE_DOWNLOAD_STATUS_0', 'OPS_CERTIFICATE_DOWNLOAD_STATUS', '未下载', 'Not downloaded', '0', '运营-证书是否已下载状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_CERTIFICATE_DOWNLOAD_STATUS_1', 'OPS_CERTIFICATE_DOWNLOAD_STATUS', '已下载', 'Downloaded', '1', '运营-证书是否已下载状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_COST_SETUP_1', 'OPS_DDC_COST_SETUP', 'DDC生成', 'Ddc Mint', '1', '官方DDC管理-DDC费用设置-费用类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_COST_SETUP_2', 'OPS_DDC_COST_SETUP', 'DDC转移', 'Ddc Transfer', '2', '官方DDC管理-DDC费用设置-费用类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_COST_SETUP_3', 'OPS_DDC_COST_SETUP', 'DDC销毁', 'Ddc Destroyed', '3', '官方DDC管理-DDC费用设置-费用类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_NODE_ADMINISTRATION_STATUS_0', 'OPS_NODE_ADMINISTRATION_STATUS', '待审核', 'Pending Review', '0', '运营-链节点管理-节点状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_NODE_ADMINISTRATION_STATUS_1', 'OPS_NODE_ADMINISTRATION_STATUS', '入网中', 'Approved', '1', '运营-链节点管理-节点状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_NODE_ADMINISTRATION_STATUS_2', 'OPS_NODE_ADMINISTRATION_STATUS', '审核拒绝', 'Not Approved', '2', '运营-链节点管理-节点状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_NODE_ADMINISTRATION_STATUS_5', 'OPS_NODE_ADMINISTRATION_STATUS', '入网失败', 'Failed Access', '5', '运营-链节点管理-节点状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_NODE_ADMINISTRATION_STATUS_10', 'OPS_NODE_ADMINISTRATION_STATUS', '待确认入网', 'To Be Confirmed Access', '10', '运营-链节点管理-节点状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_NODE_ADMINISTRATION_STATUS_15', 'OPS_NODE_ADMINISTRATION_STATUS', '已确认入网', 'Confirmed Access', '15', '运营-链节点管理-节点状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_NODE_ADMINISTRATION_STATUS_20', 'OPS_NODE_ADMINISTRATION_STATUS', '入网完成', 'Successful Access', '20', '运营-链节点管理-节点状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_NODE_ADMINISTRATION_STATUS_30', 'OPS_NODE_ADMINISTRATION_STATUS', '退网完成', 'Back Out', '30', '运营-链节点管理-节点状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_GENERATE_STATUS_10', 'PORTAL_DDC_GENERATE_STATUS', '生成处理中', 'Generation Processing', '10', '门户-官方DDC管理-DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_GENERATE_STATUS_1', 'PORTAL_DDC_GENERATE_STATUS', '正常', 'Valid', '1', '门户-官方DDC管理-DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_GENERATE_STATUS_15', 'PORTAL_DDC_GENERATE_STATUS', '生成失败', 'Generation Failed', '15', '门户-官方DDC管理-DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_GENERATE_STATUS_20', 'PORTAL_DDC_GENERATE_STATUS', '发送处理中', 'Sending', '20', '门户-官方DDC管理-DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_GENERATE_STATUS_25', 'PORTAL_DDC_GENERATE_STATUS', '发送失败', 'Send Failed', '25', '门户-官方DDC管理-DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_GENERATE_STATUS_100', 'PORTAL_DDC_GENERATE_STATUS', '已冻结', 'Frozen', '100', '门户-官方DDC管理-DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_CHARGE_TYPE_1', 'OPS_CHARGE_TYPE', '微信', 'Wechat', '1', '运营-用户资金管理-充值查询-充值方式', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_CHARGE_TYPE_2', 'OPS_CHARGE_TYPE', '支付宝', 'Alipay', '2', '运营-用户资金管理-充值查询-充值方式', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_CHARGE_TYPE_3', 'OPS_CHARGE_TYPE', '企业银联', 'Enterprise UnionPay', '3', '运营-用户资金管理-充值查询-充值方式', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_CHARGE_TYPE_4', 'OPS_CHARGE_TYPE', '线下汇款', 'Offline Remittance', '4', '运营-用户资金管理-充值查询-充值方式', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_CHARGE_TYPE_10', 'OPS_CHARGE_TYPE', 'VISA', 'VISA', '10', '运营-用户资金管理-充值查询-充值方式', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_WITHDRAW_PROCESS_TYPE_1', 'OPS_WITHDRAW_PROCESS_TYPE', '待审核', 'Pending Review', '1', '运营-用户资金管理-提现管理-提现状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_WITHDRAW_PROCESS_TYPE_5', 'OPS_WITHDRAW_PROCESS_TYPE', '审核失败', 'Not Approved', '5', '运营-用户资金管理-提现管理-提现状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_WITHDRAW_PROCESS_TYPE_10', 'OPS_WITHDRAW_PROCESS_TYPE', '审核成功', 'Approved', '10', '运营-用户资金管理-提现管理-提现状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_WITHDRAW_PROCESS_TYPE_15', 'OPS_WITHDRAW_PROCESS_TYPE', '已确认', 'Confirmed', '15', '运营-用户资金管理-提现管理-提现状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_REMITTANCE_APPROVED_TYPE_1', 'OPS_REMITTANCE_APPROVED_TYPE', '待审核', 'Pending Review', '1', '运营-用户资金管理-汇款登记-审核状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_REMITTANCE_APPROVED_TYPE_5', 'OPS_REMITTANCE_APPROVED_TYPE', '审核失败', 'Not Approved', '5', '运营-用户资金管理-汇款登记-审核状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_REMITTANCE_APPROVED_TYPE_10', 'OPS_REMITTANCE_APPROVED_TYPE', '审核成功', 'Approved', '10', '运营-用户资金管理-汇款登记-审核状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_ACCOUNT_TRADE_TYPE_55', 'PORTAL_ACCOUNT_TRADE_TYPE', '账户提现退款', 'Account Withdrawal Refund', '55', '首页-交易类型', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_GENERATE_STATUS_4', 'PORTAL_DDC_GENERATE_STATUS', '销毁处理中', 'Burning', '4', '门户-官方DDC管理-DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_CHAIN_ACCOUNT_STATUS_1', 'PORTAL_CHAIN_ACCOUNT_STATUS', '已冻结', 'Frozen', '1', '门户-链账户管理-链账户状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_CHAIN_ACCOUNT_STATUS_2', 'PORTAL_CHAIN_ACCOUNT_STATUS', '已启用', 'Enabled', '2', '门户-链账户管理-链账户状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_NODE_ADMINISTRATION_STATUS_3', 'OPS_NODE_ADMINISTRATION_STATUS', '已保存', 'Save', '3', '运营-链节点管理-节点状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_721_MANAGE_STATUS_1', 'OPS_DDC_721_MANAGE_STATUS', '生成处理中', 'Generation Processing', '1', 'DDC管理-721DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_721_MANAGE_STATUS_5', 'OPS_DDC_721_MANAGE_STATUS', '正常', 'Valid', '5', 'DDC管理-721DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_721_MANAGE_STATUS_10', 'OPS_DDC_721_MANAGE_STATUS', '生成失败', 'Generation Failed', '10', 'DDC管理-721DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_721_MANAGE_STATUS_15', 'OPS_DDC_721_MANAGE_STATUS', '发送处理中', 'Sending', '15', 'DDC管理-721DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_721_MANAGE_STATUS_20', 'OPS_DDC_721_MANAGE_STATUS', '发送失败', 'Send Failed', '20', 'DDC管理-721DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_721_MANAGE_STATUS_25', 'OPS_DDC_721_MANAGE_STATUS', '销毁处理中', 'Burning', '25', 'DDC管理-721DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_721_MANAGE_STATUS_35', 'OPS_DDC_721_MANAGE_STATUS', '销毁', 'Burn', '35', 'DDC管理-721DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_MANAGE_STATUS_1', 'OPS_DDC_MANAGE_STATUS', '生成处理中', 'Generation Processing', '1', 'DDC管理-1155DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_MANAGE_STATUS_5', 'OPS_DDC_MANAGE_STATUS', '正常', 'Valid', '5', 'DDC管理-1155DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_MANAGE_STATUS_10', 'OPS_DDC_MANAGE_STATUS', '生成失败', 'Generation Failed', '10', 'DDC管理-1155DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_MANAGE_STATUS_25', 'OPS_DDC_MANAGE_STATUS', '销毁处理中', 'Burning', '25', 'DDC管理-1155DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_MANAGE_STATUS_35', 'OPS_DDC_MANAGE_STATUS', '销毁', 'Burn', '35', 'DDC管理-1155DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_MGR_STATE_STATUS_1', 'OPS_MGR_STATE_STATUS', '冻结', 'Frozen', '1', '门户-官方DDC管理-DDC运营冻结状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_MGR_STATE_STATUS_5', 'OPS_MGR_STATE_STATUS', '正常', 'Valid', '5', '门户-官方DDC管理-DDC运营冻结状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'DDC_GENERATE_STATE_STATUS_1', 'DDC_GENERATE_STATE_STATUS', '生成处理中', 'Generation Processing', '1', '门户-官方DDC管理-DDC生成状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'DDC_GENERATE_STATE_STATUS_5', 'DDC_GENERATE_STATE_STATUS', '正常', 'Valid', '5', '门户-官方DDC管理-DDC生成状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'DDC_GENERATE_STATE_STATUS_10', 'DDC_GENERATE_STATE_STATUS', '生成失败', 'Generation Failed', '10', '门户-官方DDC管理-DDC生成状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_STATE_STATUS_1', 'PORTAL_DDC_STATE_STATUS', '正常', 'Valid', '1', '门户-官方DDC管理-DDC发送状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_STATE_STATUS_4', 'PORTAL_DDC_STATE_STATUS', '销毁处理中', 'Burning', '4', '门户-官方DDC管理-DDC发送状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_STATE_STATUS_5', 'PORTAL_DDC_STATE_STATUS', '销毁', 'Burn', '5', '门户-官方DDC管理-DDC发送状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_STATE_STATUS_20', 'PORTAL_DDC_STATE_STATUS', '发送处理中', 'Sending', '20', '门户-官方DDC管理-DDC发送状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'PORTAL_DDC_STATE_STATUS_25', 'PORTAL_DDC_STATE_STATUS', '发送失败', 'Send Failed', '25', '门户-官方DDC管理-DDC发送状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_OWNER_MANAGE_STATUS_1', 'OPS_DDC_OWNER_MANAGE_STATUS', '生成处理中', 'Generation Processing', '1', 'DDC管理-持有者DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_OWNER_MANAGE_STATUS_5', 'OPS_DDC_OWNER_MANAGE_STATUS', '正常', 'Valid', '5', 'DDC管理-持有者DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_OWNER_MANAGE_STATUS_10', 'OPS_DDC_OWNER_MANAGE_STATUS', '生成失败', 'Generation Failed', '10', 'DDC管理-持有者DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_OWNER_MANAGE_STATUS_15', 'OPS_DDC_OWNER_MANAGE_STATUS', '发送处理中', 'Sending', '15', 'DDC管理-持有者DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_OWNER_MANAGE_STATUS_20', 'OPS_DDC_OWNER_MANAGE_STATUS', '发送失败', 'Send Failed', '20', 'DDC管理-持有者DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_OWNER_MANAGE_STATUS_25', 'OPS_DDC_OWNER_MANAGE_STATUS', '销毁处理中', 'Burning', '25', 'DDC管理-持有者DDC状态', '2', '1');
INSERT INTO chain_status_enums ( cse_code, cse_p_code, cse_cn_desc, cse_en_desc, cse_value, cse_remark, lockable, cse_sort) VALUES ( 'OPS_DDC_OWNER_MANAGE_STATUS_35', 'OPS_DDC_OWNER_MANAGE_STATUS', '销毁', 'Burn', '35', 'DDC管理-持有者DDC状态', '2', '1');



#---权限 resource------

INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('1', '0', 'P0', 'BSN城市算力中心管理系统', '1', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('2', '1', 'P1', '首页', '1', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('3', '1', 'P2', '门户配置管理', '2', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('4', '1', 'P3', '注册用户管理', '3', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('5', '73', 'P4', '节点管理', '4', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('6', '1', 'P5', '链账户管理', '5', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('7', '1', 'P6', '网络接入', '6', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('8', '1', 'P7', '应用接入', '7', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('9', '1', 'P8', '用户资金管理', '8', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('10', '1', 'P9', '系统用户管理', '9', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('11', '3', 'P10', '保存', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('12', '4', 'P11', '删除', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('13', '5', 'P12', '节点入网', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('14', '5', 'P13', '查看', '2', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('15', '5', 'P14', '确认入网', '3', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('16', '5', 'P15', '退网', '4', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('17', '73', 'P16', '能量值价格管理', '1', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('18', '6', 'P17', '链账户信息', '2', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('19', '6', 'P18', '能量值/资源消耗流水', '3', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('20', '17', 'P19', '新增', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('21', '17', 'P20', '查看', '2', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('22', '18', 'P21', '查看', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('23', '19', 'P22', '查看', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('24', '7', 'P23', '网关管理', '1', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('25', '7', 'P24', '接入管理', '2', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('27', '8', 'P26', '官方DDC', '1', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('32', '27', 'P31', 'DDC费用设置', '1', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('33', '27', 'P32', '721DDC管理', '2', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('34', '27', 'P33', '1155DDC管理', '3', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('35', '32', 'P34', '编辑', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('36', '33', 'P35', '查看', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('37', '36', 'P36', '区块信息查看', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('38', '34', 'P37', '查看', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('39', '38', 'P38', '区块信息查看', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('40', '9', 'P39', '收款账户配置', '1', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('41', '9', 'P40', '汇款登记', '2', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('42', '9', 'P41', '充值查询', '3', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('43', '9', 'P42', '提现管理', '4', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('44', '9', 'P43', '算力值流水', '4', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('45', '40', 'P44', '保存', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('46', '41', 'P45', '新增', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('47', '41', 'P46', '审核', '2', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('48', '41', 'P47', '编辑', '3', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('49', '41', 'P48', '查看', '4', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('50', '42', 'P49', '查看', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('51', '43', 'P50', '审核', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('52', '43', 'P51', '确认', '2', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('53', '43', 'P52', '查看', '3', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('54', '10', 'P53', '用户管理', '1', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('55', '10', 'P54', '角色管理', '2', '1', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('56', '54', 'P55', '新增', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('57', '54', 'P56', '编辑', '2', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('58', '54', 'P57', '禁用', '3', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('59', '54', 'P58', '启用', '4', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('60', '54', 'P59', '查看', '5', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('61', '54', 'P60', '重置密码', '6', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('62', '54', 'P61', '删除', '7', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('63', '55', 'P62', '新增', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('64', '55', 'P63', '编辑', '2', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('65', '55', 'P64', '禁用', '3', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('66', '55', 'P65', '启用', '4', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('67', '55', 'P66', '查看', '5', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('68', '55', 'P67', '删除', '6', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('69', '5', 'P68', '重新提交', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('71', '24', 'P70', '保存', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('26', '24', 'P25', '修改接入方式', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('72', '5', 'P71', '删除', '1', '2', '1');
INSERT INTO sys_resource (rsuc_id, parent_id, rsuc_code, rsuc_name, priority, rsuc_type, locking) VALUES ('73', '1', 'P72', '链节点管理', '1', '1', '1');


#------初始管理员角色-----
INSERT INTO sys_role (role_id, role_name, role_code, description, locking, create_date, update_date, create_user_id, update_user_id) VALUES ('1', '系统管理员', 'R001', '超级系统管理员', '1', '2022-11-15 17:13:13', '2022-11-15 17:13:29', '1', '1');


#------初始化角色对应权限code----
INSERT INTO sys_role_resource (
	role_id,
	rsuc_id
)
SELECT
	role_id,
	rsuc_id
FROM sys_role ro LEFT JOIN sys_resource re ON ro.role_id = re.locking
WHERE ro.role_id =1;
INSERT INTO sys_role_resource (role_id, rsuc_id) VALUES ( '1', '72');
INSERT INTO sys_role_resource (role_id, rsuc_id) VALUES ( '1', '73');


#------初始管理员用户----
INSERT INTO sys_user_principal (user_id, login_name, user_name, user_email, phone, password, salt, user_lock, create_date, update_date) VALUES ('1', 'admin', '超级管理员', NULL, NULL, 'a7fe12e20cb9c5abcc16a41582bcd616cb86c3ced5746e3fc7b98fd8d1c4befb', '87b2c367d9f060f3da7eb3e83a543ecb', '2', '2022-11-15 11:04:23', '2022-11-15 11:04:32');



#------初始用户与角色对应关系------
INSERT INTO sys_user_role (user_role_id, user_id, role_id) VALUES ('1', '1', '1');


#-------初始化管理员权限url------

INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/user/portal/searches', 'P3', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/user/portal/remove', 'P11', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/recharge/data/searches', 'P41', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/recharge/offline/detail/search', 'P49', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/withdraw/data/searches', 'P42', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/withdraw/check/modify', 'P50', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/withdraw/detail/searches', 'P52', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/withdraw/sure/modify', 'P51', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/receive/account/search', 'P39', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/receive/account/save', 'P44', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/receive/account/modify', 'P44', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/remittance/searches', 'P40', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/remittance/save', 'P45', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/remittance/modify', 'P47', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/remittance/audit/save', 'P46', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/remittance/detail/search', 'P48', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/remittance/clientname/search', 'P45', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/trade/searches', 'P43', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/opb/project/setting/gateway/searches', 'P23', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/opb/project/setting/gateway/modify', 'P25', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/opb/project/access/users/searches', 'P24', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/ddc/mgr/721ddc/searches', 'P32', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/ddc/mgr/721ddc/baseinfo/search', 'P35', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/ddc/mgr/721ddc/operatelog/searches', 'P35', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/ddc/mgr/ddc/blockinfo/search', 'P36', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/ddc/mgr/1155ddc/searches', 'P33', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/ddc/mgr/1155ddc/baseinfo/search', 'P37', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/ddc/mgr/1155ddc/operatelog/searches', 'P37', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/ddc/mgr/1155ddc/ownerdetails/searches', 'P37', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/ddc/mgr/ddc/blockinfo/search', 'P38', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/feemgr/cost/searches', 'P31', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/feemgr/cost/modify', 'P34', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/resource/searches', 'P54', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/user/searches', 'P53', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/user/save', 'P55', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/user/search', 'P59', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/user/modify', 'P56', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/user/lock/modify', 'P57', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/user/lock/modify', 'P58', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/user/pass/modify', 'P60', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/user/remove', 'P61', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/user/permissions/searches', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/user/management/pass/modify', 'P0', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/role/searches', 'P54', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/role/search', 'P66', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/role/save', 'P62', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/role/modify', 'P63', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/role/status/modify', 'P64', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/role/status/modify', 'P65', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/role/remove', 'P67', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/home/needtobe/searches', 'P1', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/node/searches', 'P4', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/node/details', 'P13', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/node/chainList', 'P12', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/node/paramList', 'P12', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/node/apply', 'P12', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/node/confirm', 'P14', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/opb/node/node/quit', 'P15', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/opb/energy/price/gas/searches', 'P16', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/opb/energy/price/gas/save', 'P19', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/opb/energy/price/gas/search', 'P20', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/opb/client/searches', 'P17', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/opb/client/search', 'P21', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/config/search', 'P2', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/config/save', 'P10', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/anon/captcha/render', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/anon/v1/file/file/downLoad', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/anon/v1/file/file/upload', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/anon/v1/file/pic/downLoad', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/anon/v1/opb/record/framework/searches', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/anon/v1/rsa/data/search', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/anon/v1/status/data/searches', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/user/platform/search', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/anon/', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/swg/authentication/login', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/swg/authentication/logout', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/node/cert/create', 'SYS0', '2', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/node/retry', 'P4', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/authmgr/user/role/searches', 'P53', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/sys/v1/opb/account/save', 'SYS0', '2', '1', 'PORTAL_NETWORK_ACCESS,PORTAL_DDC', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/sys/v1/opb/account/searches', 'SYS0', '2', '1', 'PORTAL_NETWORK_ACCESS,PORTAL_DDC', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/sys/v1/opb/project/network/access/search', 'SYS0', '2', '1', 'PORTAL_NETWORK_ACCESS', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/sys/v1/opb/project/network/key/modify', 'SYS0', '2', '1', 'PORTAL_NETWORK_ACCESS', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/sys/v1/ddc/save', 'SYS0', '2', '1', 'PORTAL_DDC', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/sys/v1/ddc/send', 'SYS0', '2', '1', 'PORTAL_DDC', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/sys/v1/ddc/burn', 'SYS0', '2', '1', 'PORTAL_DDC', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/anon/v1/file/file/base64/upload', 'SYS0', '2', '1', 'PORTAL_DDC', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/sys/v1/ddc/fee/searches', 'SYS0', '2', '1', 'PORTAL_DDC', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/sys/v1/ddc/transfer/searches', 'SYS0', '2', '1', 'PORTAL_DDC', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/sys/v1/opb/account/hashrate/gas/search', 'SYS0', '2', '1', 'PORTAL_NETWORK_ACCESS', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcportal/sys/v1/opb/account/hashrate/resource/search', 'SYS0', '2', '1', 'PORTAL_NETWORK_ACCESS', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( 'ddcportal/sys/v1/opb/account/gas/recharge', 'SYS0', '2', '1', 'PORTAL_NETWORK_ACCESS', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( 'ddcportal/sys/v1/opb/account/resource/recharge', 'SYS0', '2', '1', 'PORTAL_NETWORK_ACCESS', 'PORTAL', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/opb/project/setting/kong/modify', 'P70', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/node/delete', 'P71', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);
INSERT INTO sys_resource_apimapping ( api_uri, rsuc_code, ischecked, locking, field1, field2, field3, field4, field5) VALUES ( '/ddcops/sys/v1/opb/energy/cur/price/gas/search', 'P16', '1', '1', 'OPS', 'OPS', NULL, NULL, NULL);

#----------短信模板---------
INSERT INTO sys_message_send_config ( msg_code, send_type, temp, email_subject, email_content_type, sms_tempid, lockable, code_desc) VALUES ( 'MID0101', 'sms', '验证码 ${验证码}。请勿将验证码告知他人，如非您本人操作请忽略，感谢您的支持！', '', '2', 'PTAGPY8ZXFKL580080', '2', '登录，注册，忘记密码，用户信息修改');

INSERT INTO function_menu (function_menu_id, menu_name, menu_code, father_menu_id, support_yn, create_date, update_date) VALUES ('1', '应用接入', 'PORTAL_APPLICATION_ACCESS', '0', '1', '2022-11-09 10:01:30', '2022-12-01 10:11:41');
INSERT INTO function_menu (function_menu_id, menu_name, menu_code, father_menu_id, support_yn, create_date, update_date) VALUES ('2', '官方DDC', 'PORTAL_DDC', '1', '1', '2022-11-09 10:02:23', '2022-12-01 10:11:41');
INSERT INTO function_menu (function_menu_id, menu_name, menu_code, father_menu_id, support_yn, create_date, update_date) VALUES ('3', '网络接入', 'PORTAL_NETWORK_ACCESS', '0', '1', '2022-11-15 14:23:40', '2022-12-01 10:11:41');

INSERT INTO ddc_cost_setup (ddc_cost_setup, tx_type, tx_amount, tx_name, update_date) VALUES ('1', '1', '100', NULL, '2022-11-10 16:34:25');
INSERT INTO ddc_cost_setup (ddc_cost_setup, tx_type, tx_amount, tx_name, update_date) VALUES ('2', '2', '30', NULL, '2022-11-10 16:33:23');
INSERT INTO ddc_cost_setup (ddc_cost_setup, tx_type, tx_amount, tx_name, update_date) VALUES ('3', '3', '30', NULL, '2022-11-10 16:33:45');