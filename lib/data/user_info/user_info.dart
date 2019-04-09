class LogingResult {
  int status;
  String msg;
  List<LoginReturnValue> returnValueList;
  int code;

  LogingResult(int status,String msg ,List<LoginReturnValue> returnValueList,int code) {
    this.status = status;
    this.msg = msg;
    this.returnValueList = returnValueList;
    this.code = code;
  }

  LogingResult.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        msg = json['msg'],
        returnValueList = json['returnValue'],
        code = json['code'];

  Map<String, dynamic> toJson() => {
        'status': status,
        'msg': msg,
        'returnValue': returnValueList,
        'code': code,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"status\":$status");
    sb.write(",\"msg\":\"$msg\"");
    sb.write(",\"returnValue\":$returnValueList");
    sb.write(",\"code\":$code");
    sb.write('}');
    return sb.toString();
  }
}

class LoginReturnValue {
//{returnValue":[{  "":"http://rengxingbao.oss-cn-shenzhen.aliyuncs.com/img1/2019/02/15/db552d93ac5c4b579efc4639bf91eeb6db552d93ac5c4b579efc4639bf91eeb6db552d93ac5c4b579efc4639bf91eeb6.jpeg"},{"mobileId":1451,"roleId":208,"baseRoleId":2,"roleName":"老师","headImageUrl":"http://rengxingbao.oss-cn-shenzhen.aliyuncs.com/img1/2019/02/15/db552d93ac5c4b579efc4639bf91eeb6db552d93ac5c4b579efc4639bf91eeb6db552d93ac5c4b579efc4639bf91eeb6.jpeg"},{"mobileId":1451,"roleId":209,"baseRoleId":2,"roleName":"保安","headImageUrl":"http://rengxingbao.oss-cn-shenzhen.aliyuncs.com/img1/2019/02/15/db552d93ac5c4b579efc4639bf91eeb6db552d93ac5c4b579efc4639bf91eeb6db552d93ac5c4b579efc4639bf91eeb6.jpeg"},{"mobileId":1451,"roleId":301,"baseRoleId":3,"roleName":"家长","headImageUrl":"http://rengxingbao.oss-cn-shenzhen.aliyuncs.com/img1/2019/02/15/db552d93ac5c4b579efc4639bf91eeb6db552d93ac5c4b579efc4639bf91eeb6db552d93ac5c4b

  int mobileId;
  int roleId;
  int baseRoleId;
  String roleName;
  String headImageUrl;
  bool isSelected = false;

  LoginReturnValue.fromJson(Map<String, dynamic> json)
      : mobileId = json['mobileId'],
        roleId = json['roleId'],
        baseRoleId = json['baseRoleId'],
        roleName = json['roleName'],
        headImageUrl = json['headImageUrl'];

  Map<String, dynamic> toJson() => {
        'mobileId': mobileId,
        'roleId': roleId,
        'baseRoleId': baseRoleId,
        'roleName': roleName,
        'headImageUrl': headImageUrl,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"roleId\":$roleId");
    sb.write(",\"mobileId\":$mobileId");
    sb.write(",\"baseRoleId\":$baseRoleId");
    sb.write(",\"roleName\":\"$roleName\"");
    sb.write(",\"headImageUrl\":\"$headImageUrl\"");
    sb.write('}');
    return sb.toString();
  }
}
