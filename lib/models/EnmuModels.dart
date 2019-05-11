class PushType {
  static   var PUSH_TYPEE_SHCOOL = MyEnum("学校通知", 1);
  static   var PUSH_TYPEE_CLASS = MyEnum("班级通知", 2);
  static   var PUSH_TYPEE_PERSON = MyEnum("个人通知", 3);
  static   var PUSH_TYPEE_SISTEM = MyEnum("系统通知", 4);
  static   var PUSH_TYPEE_SHCOOL123 = MyEnum("学校通知 ", 123);

 static String getPushTypeString(int index) {
    switch (index) {
      case 1:
        return "学校通知";
        break;
      case 2:
        return "班级通知";
        break;
      case 3:
        return "个人通知";
        break;
      case 4:
        return "系统通知";
        break;
      case 123:
        return "学校通知";
        break;
    }
  }

 static int getPushTypeIndex(String name) {
    switch (name) {
      case "学校通知":
        return 1;
        break;
      case "班级通知":
        return 2;
        break;
      case "个人通知":
        return 3;
        break;
      case "系统通知":
        return 4;
        break;
    }
    return 0;
  }
}

class MessageType {
static  var MESSAGE_TYPE_ALL = MyEnum("全部通知 ", 0);
static    var MESSAGE_TYPE_TEACHER = MyEnum("老师通知", 1);
static   var MESSAGE_TYPE_STUDENT = MyEnum("学生通知", 2);
static    var MESSAGE_TYPE_PARENTS = MyEnum("家长通知", 3);
static   var MESSAGE_TYPE_SYSTEM = MyEnum("任行宝用户", 4);
static   var MESSAGE_TYPE_ALL123 = MyEnum("全部通知", 123);

 static String getPushTypeString(int index) {
    switch (index) {
      case 0:
        return "全部通知";
        break;
        case 1:
        return "老师通知";
        break;
      case 2:
        return "学生通知";
        break;
      case 3:
        return "家长通知";
        break;
      case 4:
        return "任行宝用户";
        break;
      case 123:
        return "全部通知";
        break;
    }
  }

  static int getPushTypeIndex(String name) {
    switch (name) {
      case "全部通知":
        return 0;
        break;
      case "老师通知":
        return 1;
        break;
      case "学生通知":
        return 2;
        break;
      case "家长通知":
        return 3;
        break;
      case "任行宝用户":
        return 4;
        break;
    }
    return 0;
  }
}

class MyEnum {
  final String name;
  final int index;

  MyEnum(this.name, this.index);
}
