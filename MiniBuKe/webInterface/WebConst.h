//
//  WebConst.h
//  YaQuan
//
//  Created by ren fei on 13-7-19.
//  Copyright (c) 2013年 YaQuan. All rights reserved.
//

#import "HttpInterface.h"

#define LOGIN_ACTION @"/jt_webservice/n_jt_webservice.asmx?op=of_login"

#define today_shopsalequery_ACTION @"/jt_webservice/n_jt_webservice.asmx?op=of_today_shopsalequery"

#define Subbranch_ACTION @"/jt_webservice/n_jt_webservice.asmx?op=of_get_shop_list"

#define of_shopsalequery_ACTION @"/jt_webservice/n_jt_webservice.asmx?op=of_shopsalequery"

#define of_shopgoodssalequery_ACTION @"/jt_webservice/n_jt_webservice.asmx?op=of_shopgoodssalequery"

#define of_countersalequery @"/jt_webservice/n_jt_webservice.asmx?op=of_countersalequery"

#define of_get_vendor_list @"/jt_webservice/n_jt_webservice.asmx?op=of_get_vendor_list"

#define of_countergoodssalequery @"/jt_webservice/n_jt_webservice.asmx?op=of_countergoodssalequery"

#define of_vendorsalequery @"/jt_webservice/n_jt_webservice.asmx?op=of_vendorsalequery"

#define of_vendorgoodssalequery @"/jt_webservice/n_jt_webservice.asmx?op=of_vendorgoodssalequery"

#define of_change_emp_right @"/jt_webservice/n_jt_webservice.asmx?op=of_change_emp_right"

#define of_set_system_connect_accountdb @"/jt_webservice/n_jt_webservice.asmx?op=of_set_system_connect_accountdb"

#define of_change_user_pwd @"/jt_webservice/n_jt_webservice.asmx?op=of_change_user_pwd"

#define of_get_service_info @"/jt_webservice/n_jt_webservice.asmx?op=of_get_service_info"

@interface WebConst : NSObject

@end
