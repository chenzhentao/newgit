class IdentityBeanParent {
  String msg;
  int status;
  String code;
  IdentityBean returnValue;

//(json['children'] as List)
//            ?.map((e) => e == null
//                ? null
//                : new TreeModel.fromJson(e as Map<String, dynamic>))
//            ?.toList();
  IdentityBeanParent.fromJson(Map<String, dynamic> json)
      : msg = json['msg'],
        status = json['status'],
        code = json['code'],
        returnValue = (json['returnValue'])
            ?.map((e) => e == null
            ? null
            : new IdentityBean.fromJson(e as Map<String, dynamic>));

  Map<String, dynamic> toJson() => {
    'msg': msg,
    'status': status,
    'code': code,
    'imagePath': returnValue,
  };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"msg\":\"$msg\"");
    sb.write(",\"status\":$status");
    sb.write(",\"code\":\"$code\"");
    sb.write(",\"returnValue\":\"$returnValue\"");
    sb.write('}');
    return sb.toString();
  }
}

class IdentityBean {
  UserVobean userVo;
  int mobileId;
  int roleId;
  int baseRoleId;
  String roleName;

  IdentityBean.fromJson(Map<String, dynamic> json)
      : userVo = UserVobean.fromJson(json['userVo']),
        mobileId = json['mobileId'],
        roleId = json['roleId'],
        baseRoleId = json['baseRoleId'],
        roleName = json['roleName'];

  Map<String, dynamic> toJson() => {
    'userVo': userVo,
    'mobileId': mobileId,
    'roleId': roleId,
    'baseRoleId': baseRoleId,
    'roleName': roleName,
  };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"userVo\":$userVo");
    sb.write(",\"mobileId\":$mobileId");
    sb.write(",\"roleId\":$roleId");
    sb.write(",\"baseRoleId\":$baseRoleId");
    sb.write(",\"roleName\":\"$roleName\"");
    sb.write('}');
    return sb.toString();
  }
}

class UserVobean {
  int id;

  String userName;

  String userPhone;
  int attendanceType;

  String headTeacherName;

  int schoolId;

  SclassVosbean sclassVosbean;

  List<SclassVosbean> sclassVos;

  String schoolName;

  UserVobean.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        userName = json['userName'],
        userPhone = json['userPhone'],
        attendanceType = json['attendanceType'],
        headTeacherName = json['headTeacherName'],
        schoolId = json['schoolId'],
//        sclassVosbean = json['sclassVosbean'],
        sclassVos = (json['sclassVos'] as List)
            ?.map((e) => e == null
            ? null
            : new SclassVosbean.fromJson(e as Map<String, dynamic>))
            ?.toList(),

  schoolName = json['schoolName'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'userName': userName,
    'userPhone': userPhone,
    'attendanceType': attendanceType,
    'headTeacherName': headTeacherName,
    'schoolId': schoolId,
//    'sclassVosbean': sclassVosbean.toJson(),
    'sclassVos': sclassVos.toString(),
    'schoolName': schoolName,
  };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"id\":$id");
    sb.write(",\"userName\":\"$userName\"");

    sb.write(",\"userPhone\":\"$userPhone\"");
    sb.write(",\"attendanceType\":$attendanceType");
    sb.write(",\"headTeacherName\":\"$headTeacherName\"");
    sb.write(",\"schoolId\":$schoolId");
    sb.write(",\"sclassVosbean\":\"$sclassVosbean\"");
    sb.write(",\"sclassVos\":$sclassVos");
    sb.write(",\"schoolName\":\"$schoolName\"");
    sb.write('}');
    return sb.toString();
  }
}

class SclassVosbean {
  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"gradeName\":\"$gradeName\"");
    sb.write(",\"studentName\":\"$studentName\"");
    sb.write(",\"schoolId\":$schoolId");
    sb.write(",\"studentId\":$studentId");
    sb.write(",\"headTeacherName\":\"$headTeacherName\"");

    sb.write(",\"studentUrl\":\"$studentUrl\"");
    sb.write(",\"schoolName\":\"$schoolName\"");
    sb.write(",\"schoolUserId\":$schoolUserId");

    sb.write(",\"gradeId\":$gradeId");
    sb.write(",\"classId\":$classId");
    sb.write(",\"className\":\"$className\"");
    sb.write('}');
    return sb.toString();

  }

  SclassVosbean(int classId, String className) {
    this.classId = classId;
    this.className = className;
    this.gradeName = "";
    this.gradeId = 0;
  }

  SclassVosbean.fromJson(Map<String, dynamic> json)
      : classId = json['classId'],
        className = json['className'],
        gradeName = json['gradeName'],
        studentName = json['studentName'],
        schoolId = json['schoolId'],
        studentId = json['studentId'],

        headTeacherName = json['headTeacherName'],
        schoolUserId = json['schoolUserId'],
        gradeId = json['gradeId'],
        schoolName = json['schoolName'],
        studentUrl = json['studentUrl'];

  Map<String, dynamic> toJson() => {
    'classId': classId,
    'className': className,
    'gradeName': gradeName,
    'studentName': studentName,
    'schoolId': schoolId,
    'studentId': studentId,
    'headTeacherName': headTeacherName,
    'schoolUserId': schoolUserId,
    'gradeId': gradeId,
    'schoolName': schoolName,
    'studentUrl': studentUrl,
  };

  /**
   * classId : 3
   * className : 103班
   * "studentName": "范举",
   * "gradeName":"计算机2018级"
   */

  int classId;

  String className;

  String gradeName;

  String studentName;

  int schoolId;

  int studentId;

  String headTeacherName;

  int schoolUserId;

  int gradeId;

  String schoolName;

  String studentUrl;
}
