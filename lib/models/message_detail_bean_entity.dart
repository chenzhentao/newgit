class MessageDetailBeanEntity {
	String msg;
	MessageDetailBeanReturnvalue returnValue;
	String code;
	String status;

	MessageDetailBeanEntity({this.msg, this.returnValue, this.code, this.status});

	MessageDetailBeanEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		returnValue = json['returnValue'] != null ? new MessageDetailBeanReturnvalue.fromJson(json['returnValue']) : null;
		code = json['code'];
		status = json['status'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msg'] = this.msg;
		if (this.returnValue != null) {
      data['returnValue'] = this.returnValue.toJson();
    }
		data['code'] = this.code;
		data['status'] = this.status;
		return data;
	}
}

class MessageDetailBeanReturnvalue {
	MessageDetailBeanReturnvalueSchoolfamilymessageinfovo schoolFamilyMessageInfoVo;
	int totalPages;
	List<MessageDetailBeanReturnvalueListvo> listVo;

	MessageDetailBeanReturnvalue({this.schoolFamilyMessageInfoVo, this.totalPages, this.listVo});

	MessageDetailBeanReturnvalue.fromJson(Map<String, dynamic> json) {
		schoolFamilyMessageInfoVo = json['SchoolFamilyMessageInfoVo'] != null ? new MessageDetailBeanReturnvalueSchoolfamilymessageinfovo.fromJson(json['SchoolFamilyMessageInfoVo']) : null;
		totalPages = json['totalPages'];
		if (json['listVo'] != null) {
			listVo = new List<MessageDetailBeanReturnvalueListvo>();(json['listVo'] as List).forEach((v) { listVo.add(new MessageDetailBeanReturnvalueListvo.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.schoolFamilyMessageInfoVo != null) {
      data['SchoolFamilyMessageInfoVo'] = this.schoolFamilyMessageInfoVo.toJson();
    }
		data['totalPages'] = this.totalPages;
		if (this.listVo != null) {
      data['listVo'] =  this.listVo.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class MessageDetailBeanReturnvalueSchoolfamilymessageinfovo {
	List<Null> photoList;
	int msgType;
	String sendName;
	String musicUrl;
	int messageId;
	int pageSize;
	int musicTime;
	String msgContent;
	String msgTitle;
	int msgScopeType;
	int readType;
	String msgReceiveNames;
	String createDateApi;

	MessageDetailBeanReturnvalueSchoolfamilymessageinfovo({this.photoList, this.msgType, this.sendName, this.musicUrl, this.messageId, this.pageSize, this.musicTime, this.msgContent, this.msgTitle, this.msgScopeType, this.readType, this.msgReceiveNames, this.createDateApi});

	MessageDetailBeanReturnvalueSchoolfamilymessageinfovo.fromJson(Map<String, dynamic> json) {
		if (json['photoList'] != null) {
			photoList = new List<Null>();
		}
		msgType = json['msgType'];
		sendName = json['sendName'];
		musicUrl = json['musicUrl'];
		messageId = json['messageId'];
		pageSize = json['pageSize'];
		musicTime = json['musicTime'];
		msgContent = json['msgContent'];
		msgTitle = json['msgTitle'];
		msgScopeType = json['msgScopeType'];
		readType = json['readType'];
		msgReceiveNames = json['msgReceiveNames'];
		createDateApi = json['createDateApi'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.photoList != null) {
      data['photoList'] =  [];
    }
		data['msgType'] = this.msgType;
		data['sendName'] = this.sendName;
		data['musicUrl'] = this.musicUrl;
		data['messageId'] = this.messageId;
		data['pageSize'] = this.pageSize;
		data['musicTime'] = this.musicTime;
		data['msgContent'] = this.msgContent;
		data['msgTitle'] = this.msgTitle;
		data['msgScopeType'] = this.msgScopeType;
		data['readType'] = this.readType;
		data['msgReceiveNames'] = this.msgReceiveNames;
		data['createDateApi'] = this.createDateApi;
		return data;
	}
}

class MessageDetailBeanReturnvalueListvo {
	int sendMoileId;
	int contentId;
	int pageSize;
	String userName;
	int userId;
	String content;
	String createDate;

	MessageDetailBeanReturnvalueListvo({this.sendMoileId, this.contentId, this.pageSize, this.userName, this.userId, this.content, this.createDate});

	MessageDetailBeanReturnvalueListvo.fromJson(Map<String, dynamic> json) {
		sendMoileId = json['sendMoileId'];
		contentId = json['contentId'];
		pageSize = json['pageSize'];
		userName = json['userName'];
		userId = json['userId'];
		content = json['content'];
		createDate = json['createDate'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['sendMoileId'] = this.sendMoileId;
		data['contentId'] = this.contentId;
		data['pageSize'] = this.pageSize;
		data['userName'] = this.userName;
		data['userId'] = this.userId;
		data['content'] = this.content;
		data['createDate'] = this.createDate;
		return data;
	}
}
