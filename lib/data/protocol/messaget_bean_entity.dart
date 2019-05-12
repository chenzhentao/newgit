class MessagetBeanEntity {
	String msg;
	MessagetBeanReturnvalue returnValue;
	String code;
	String status;

	MessagetBeanEntity({this.msg, this.returnValue, this.code, this.status});

	MessagetBeanEntity.fromJson(Map<String, dynamic> json) {
		msg = json['msg'];
		returnValue = json['returnValue'] != null ? new MessagetBeanReturnvalue.fromJson(json['returnValue']) : null;
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

class MessagetBeanReturnvalue {
	int totalPages;
	List<MessagetBeanReturnvalueListvo> listVo;

	MessagetBeanReturnvalue({this.totalPages, this.listVo});

	MessagetBeanReturnvalue.fromJson(Map<String, dynamic> json) {
		totalPages = json['totalPages'];
		if (json['listVo'] != null) {
			listVo = new List<MessagetBeanReturnvalueListvo>();(json['listVo'] as List).forEach((v) { listVo.add(new MessagetBeanReturnvalueListvo.fromJson(v)); });
		}
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['totalPages'] = this.totalPages;
		if (this.listVo != null) {
      data['listVo'] =  this.listVo.map((v) => v.toJson()).toList();
    }
		return data;
	}
}

class MessagetBeanReturnvalueListvo {
	int msgType;
	String sendName;
	int messageId;
	int pageSize;
	String msgContent;

	String msgReceiveIds;
	String msgTitle;

	int msgScopeType;
	int hasRead;
	int readType;
	int readCount;
	int commentCount;
	int ownerMobileUserId;
	String msgReceiveNames;
	String createDateApi;

	MessagetBeanReturnvalueListvo({this.msgType, this.sendName, this.messageId, this.pageSize, this.msgContent, this.msgReceiveIds, this.msgTitle, this.msgScopeType,
		this.hasRead,this.readCount,this.commentCount, this.readType, this.ownerMobileUserId, this.msgReceiveNames, this.createDateApi});

	MessagetBeanReturnvalueListvo.fromJson(Map<String, dynamic> json) {
		msgType = json['msgType'];
		sendName = json['sendName'];
		messageId = json['messageId'];
		pageSize = json['pageSize'];
		msgContent = json['msgContent'];
		msgReceiveIds = json['msgReceiveIds'];
		msgTitle = json['msgTitle'];
		msgScopeType = json['msgScopeType'];
		hasRead = json['hasRead'];
		readCount = json['readCount'];
		commentCount = json['commentCount'];
		readType = json['readType'];
		ownerMobileUserId = json['ownerMobileUserId'];
		msgReceiveNames = json['msgReceiveNames'];
		createDateApi = json['createDateApi'];
	}

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		data['msgType'] = this.msgType;
		data['sendName'] = this.sendName;
		data['messageId'] = this.messageId;
		data['pageSize'] = this.pageSize;
		data['msgContent'] = this.msgContent;
		data['msgReceiveIds'] = this.msgReceiveIds;
		data['msgTitle'] = this.msgTitle;
		data['msgScopeType'] = this.msgScopeType;
		data['hasRead'] = this.hasRead;
		data['readCount'] = this.readCount;
		data['commentCount'] = this.commentCount;
		data['readType'] = this.readType;
		data['ownerMobileUserId'] = this.ownerMobileUserId;
		data['msgReceiveNames'] = this.msgReceiveNames;
		data['createDateApi'] = this.createDateApi;
		return data;
	}
}
