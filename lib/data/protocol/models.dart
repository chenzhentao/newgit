import 'package:azlistview/azlistview.dart';

class ComData {
  int size;
  List datas;

  ComData.fromJson(Map<String, dynamic> json)
      : size = json['size'],
        datas = json['datas'];
}

class ComReq {
  int cid;

  ComReq(this.cid);

  ComReq.fromJson(Map<String, dynamic> json) : cid = json['cid'];

  Map<String, dynamic> toJson() => {
        'cid': cid,
      };
}

class ComListResp<T> {
  int status;
  List<T> list;

  ComListResp(this.status, this.list);
}

class ReposModel {
  ReposModel({this.studentName, this.className, this.subTypeName});

  String createDateStr;
  String updateDateStr;
  String offenseTimeStr;
  double avgScore;
  int studentOffenseId;

  String creator;
  String createDate;
  String updator;
  String updateDate;
  int studentId;

  String studentName;
  int offenseId;
  String score;
  int bonusOrMalus;
  String typeName;

  int typeCategory;
  String subTypeName;
  int gradeId;
  String gradeName;
  String className;

  int schoolId;
  String schoolName;
  int timeSetId;
  String timeSetName;
  String offenseTime;

  String offenseDescription;
  String studentPic;

  ReposModel.fromJson(Map<String, dynamic> json)
      : createDateStr = json['createDateStr'],
        updateDateStr = json['updateDateStr'],
        offenseTimeStr = json['offenseTimeStr'],
        avgScore = json['avgScore'],
        studentOffenseId = json['studentOffenseId'],
        creator = json['creator'],
        createDate = json['createDate'],
        updator = json['updator'],
        updateDate = json['updateDate'],
        studentId = json['studentId'],
        studentName = json['studentName'],
        offenseId = json['offenseId'],
        score = json['score'],
        bonusOrMalus = json['bonusOrMalus'],
        typeName = json['typeName'],
        typeCategory = json['typeCategory'],
        subTypeName = json['subTypeName'],
        gradeId = json['gradeId'],
        gradeName = json['gradeName'],
        className = json['className'],
        schoolId = json['schoolId'],
        schoolName = json['schoolName'],
        timeSetId = json['timeSetId'],
        timeSetName = json['timeSetName'],
        offenseTime = json['offenseTime'],
        offenseDescription = json['offenseDescription'],
        studentPic = json['studentPic'];

  Map<String, dynamic> toJson() => {
        'createDateStr': createDateStr,
        'updateDateStr': updateDateStr,
        'offenseTimeStr': offenseTimeStr,
        'avgScore': avgScore,
        'studentOffenseId': studentOffenseId,
        'creator': creator,
        'createDate': createDate,
        'updator': updator,
        'updateDate': updateDate,
        'studentId': studentId,
        'studentName': studentName,
        'offenseId': offenseId,
        'score': score,
        'bonusOrMalus': bonusOrMalus,
        'typeName': typeName,
        'typeCategory': typeCategory,
        'subTypeName': subTypeName,
        'gradeId': gradeId,
        'gradeName': gradeName,
        'className': className,
        'schoolId': schoolId,
        'schoolName': schoolName,
        'timeSetId': timeSetId,
        'timeSetName': timeSetName,
        'offenseTime': offenseTime,
        'offenseDescription': offenseDescription,
        'studentPic': studentPic,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"createDateStr\":\"$createDateStr\"");
    sb.write("\"updateDateStr\":\"$updateDateStr\"");
    sb.write("\"offenseTimeStr\":\"$offenseTimeStr\"");
    sb.write("\"avgScore\":$avgScore");
    sb.write("\"studentOffenseId\":$studentOffenseId");
    sb.write("\"creator\":\"$creator\"");
    sb.write("\"createDate\":\"$createDate\"");
    sb.write("\"updator\":\"$updator\"");
    sb.write("\"updateDate\":\"$updateDate\"");
    sb.write("\"studentId\":$studentId");
    sb.write("\"studentName\":\"$studentName\"");
    sb.write("\"offenseId\":$offenseId");
    sb.write("\"score\":\"$score\"");
    sb.write("\"bonusOrMalus\":\"$bonusOrMalus\"");
    sb.write("\"typeName\":\"$typeName\"");
    sb.write("\"typeCategory\":\"$typeCategory\"");
    sb.write("\"subTypeName\":\"$subTypeName\"");
    sb.write("\"gradeId\":$gradeId");
    sb.write("\"gradeName\":\"$gradeName\"");
    sb.write("\"className\":\"$className\"");
    sb.write("\"schoolId\":$schoolId");
    sb.write("\"schoolName\":\"$schoolName\"");
    sb.write("\"timeSetId\":$timeSetId");
    sb.write("\"timeSetName\":\"$timeSetName\"");
    sb.write("\"offenseTime\":\"$offenseTime\"");
    sb.write("\"offenseDescription\":\"$offenseDescription\"");
    sb.write("\"studentPic\":\"$studentPic\"");

    sb.write('}');
    return sb.toString();
  }
}

class MessageParentModel {
  String msg;
  int status;
  String code;
  MessageListModel returnValue;
  MessageParentModel.fromJson(Map<String, dynamic> json)
      : msg = json['msg'],
        status = json['status'],
        code = json['code'],
        returnValue = json['returnValue'] ;

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

class MessageListModel {
  List<MessageModel> listVo;
  MessageListModel.fromJson(Map<String, dynamic> json)
      : listVo = (json['listVo'] as List)
            ?.map((e) => e == null
            ? null
            : new MessageModel.fromJson(e as Map<String, dynamic>))
            ?.toList();

  Map<String, dynamic> toJson() => {

    'listVo': listVo,
  };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"listVo\":${listVo.toString()}");
    sb.write('}');
    return sb.toString();
  }
}

class MessageModel {
  int messageId;
  int msgType;
  String msgTitle;
  String msgContent;
  int hasRead;

  int msgScopeType;
  int ownerMobileUserId;

  String msgReceiveNames;
  String msgReceiveIds;
  String delStatus;
  String sendName;
  String createDate;
  String createDateApi;
  int readCount;
  int commentCount;

  MessageModel.fromJson(Map<String, dynamic> json)
      : messageId = json['messageId'],
        msgType = json['msgType'],
        msgTitle = json['msgTitle'],
        msgContent = json['msgContent'],
        hasRead = json['hasRead'],
        msgScopeType = json['msgScopeType'],
        createDate = json['createDate'],
        createDateApi = json['createDateApi'],
        ownerMobileUserId = json['ownerMobileUserId'],
        msgReceiveNames = json['msgReceiveNames'],
        msgReceiveIds = json['msgReceiveIds'],
        delStatus = json['delStatus'],
        sendName = json['sendName'],
        readCount = json['readCount'],
        commentCount = json['commentCount'];

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'msgType': msgType,
        'msgTitle': msgTitle,
        'msgContent': msgContent,
        'hasRead': hasRead,
        'msgScopeType': msgScopeType,
        'createDate': createDate,
        'createDateApi': createDateApi,
        'ownerMobileUserId': ownerMobileUserId,
        'msgReceiveNames': msgReceiveNames,
        'msgReceiveIds': msgReceiveIds,
        'delStatus': delStatus,
        'sendName': sendName,
        'readCount': readCount,
        'commentCount': commentCount,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"messageId\":$messageId");
    sb.write("\"msgType\":$msgType");
    sb.write("\"msgTitle\":\"$msgTitle\"");
    sb.write("\"msgContent\":\"$msgContent\"");
    sb.write("\"hasRead\":$hasRead");
    sb.write("\"msgScopeType\":$msgScopeType");
    sb.write("\"createDate\":\"$createDate\"");
    sb.write("\"createDateApi\":\"$createDateApi\"");
    sb.write("\"ownerMobileUserId\":$ownerMobileUserId");
    sb.write("\"msgReceiveNames\":\"$msgReceiveNames\"");
    sb.write("\"msgReceiveIds\":\"$msgReceiveIds\"");
    sb.write("\"delStatus\":\"$delStatus\"");
    sb.write("\"sendName\":\"$sendName\"");
    sb.write("\"readCount\":\"$readCount\"");
    sb.write("\"commentCount\":$commentCount");
    sb.write('}');
    return sb.toString();
  }
}

class BannerModelParent {
  String msg;
  int status;
  String code;
  List<BannerModel> returnValue;


  BannerModelParent.fromJson(Map<String, dynamic> json)
      : msg = json['msg'],
        status = json['status'],
        code = json['code'],
        returnValue = (json['imagePath'] as List)
            ?.map((e) => e == null
                ? null
                : new BannerModel.fromJson(e as Map<String, dynamic>))
            ?.toList();

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

class BannerModel {
  String title;
  int id;
  String url;
  String imagePath;

  BannerModel.fromJson(Map<String, dynamic> json)
      : title = json['createDate'],
        id = json['id'],
        url = json['schoolLink'],
        imagePath = json['schoolImageUrl'];

  Map<String, dynamic> toJson() => {
        'createDate': title,
        'id': id,
        'schoolLink': url,
        'schoolImageUrl': imagePath,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"createDate\":\"$title\"");
    sb.write(",\"id\":$id");
    sb.write(",\"schoolLink\":\"$url\"");
    sb.write(",\"schoolImageUrl\":\"$imagePath\"");
    sb.write('}');
    return sb.toString();
  }
}

class TreeModel extends ISuspensionBean {
  String name;
  int id;
  List<TreeModel> children;
  String tagIndex;

  TreeModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        children = (json['children'] as List)
            ?.map((e) => e == null
                ? null
                : new TreeModel.fromJson(e as Map<String, dynamic>))
            ?.toList();

  Map<String, dynamic> toJson() => {
        'name': name,
        'id': id,
        'children': children,
      };

  @override
  String toString() {
    StringBuffer sb = new StringBuffer('{');
    sb.write("\"name\":\"$name\"");
    sb.write(",\"id\":$id");
    sb.write(",\"children\":$children");
    sb.write('}');
    return sb.toString();
  }

  @override
  String getSuspensionTag() {
    return tagIndex;
  }
}

class LoginReq {
  String username;
  String password;

  LoginReq(this.username, this.password);

  LoginReq.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };

  @override
  String toString() {
    return '{' +
        " \"username\":\"" +
        username +
        "\"" +
        ", \"password\":\"" +
        password +
        "\"" +
        '}';
  }
}

class RegisterReq {
  String username;
  String password;
  String repassword;

  RegisterReq(this.username, this.password, this.repassword);

  RegisterReq.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        password = json['password'],
        repassword = json['repassword'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'repassword': repassword,
      };

  @override
  String toString() {
    return '{' +
        " \"username\":\"" +
        username +
        "\"" +
        ", \"password\":\"" +
        password +
        "\"" +
        ", \"repassword\":\"" +
        repassword +
        "\"" +
        '}';
  }
}
